extends Node

class_name WebsocketService

var ws: WebSocketPeer = WebSocketPeer.new()
var events: Dictionary = {}
var clientId: String
var deviceId: String
var reconnection_delay_miliseconds: int = 1000
var clientInitData: AModels.ArcaneClientInitData
var url: String
var deviceType:String
var isConnected = false

var protocol:String
var port:String
var reverseProxyPort:String
var ipOctets:String

func _init(_deviceType: String) -> void:
	deviceType = _deviceType
	initWebsocket()

func initWebsocket():
	if isInsideIframe(): initAsIframeClient()
	else: initAsExternalClient()

	
func initAsIframeClient():
	var queryParams = getQueryParamsDictionary()
	deviceId = queryParams.deviceId
	
	var host = JavaScriptBridge.eval("window.location.hostname")
	url = "wss://" + host + ":3685/"
	#url = "ws://localhost:3689/"
	clientInitData = AModels.ArcaneClientInitData.new("iframe", deviceType, deviceId)
	var clientInitDataDictionary = AUtils.objectToDictionary(clientInitData)
	var stringifiedClientInitData = JSON.stringify(clientInitDataDictionary)
	var encodedClientInitData = AUtils.urlEncode(stringifiedClientInitData)
	url = url + "?clientInitData=" + encodedClientInitData
	connectToServer(url)
	on(AEventName.Initialize, onInitialize)
 

func isInsideIframe():
	return JavaScriptBridge.eval("window == window.parent") == 0

func getQueryParamsDictionary():
	var queryParams = {}
	var query_string:String = JavaScriptBridge.eval("window.location.search.substring(1);")
	
	#AUtils.writeToScreen(self, query_string)
	
	if query_string.is_empty():
		return queryParams  # Return empty dictionary if no query string

	var pairs = query_string.split("&")

	for pair in pairs:
		var key_value = pair.split("=")
		if key_value.size() == 2:
			queryParams[key_value[0]] = key_value[1]

	return queryParams
	
	
func initAsExternalClient():
	url = "ws://localhost:3689/"
	clientInitData = AModels.ArcaneClientInitData.new("external", deviceType, "godot-dev")
	var clientInitDataDictionary = AUtils.objectToDictionary(clientInitData)
	var stringifiedClientInitData = JSON.stringify(clientInitDataDictionary)
	var encodedClientInitData = AUtils.urlEncode(stringifiedClientInitData)
	url = url + "?clientInitData=" + encodedClientInitData
	connectToServer(url)
	on(AEventName.Initialize, onInitialize)

func onInitialize(e, _from):
	if e.assignedClientId == null or e.assignedClientId == "":
		printerr("Missing clientId on initialize")
		return
	if e.assignedDeviceId == null or e.assignedDeviceId == "":
		printerr("Missing deviceId on initialize")
		return
	clientId = e.assignedClientId
	deviceId = e.assignedDeviceId
	prints("<> Client initialized - Device Type:", deviceType, "- ClientId:", clientId)
	

func connectToServer(_url:String) -> void:
	print("connecting  to server: ", _url)
	var err = ws.connect_to_url(_url)
	if err != OK:
		printerr("Failed to connect:", err)
		return
		
func _process(_delta: float) -> void:
	ws.poll()  # Update the connection state and receive incoming packets

	var state = ws.get_ready_state() 
	
	if(state == WebSocketPeer.STATE_CONNECTING):
		if Arcane.logVerbose: print("Websocket connecting...")

	if state == WebSocketPeer.STATE_OPEN:
		if(!isConnected):
			print("Websocket connection opened")
			isConnected = true
			
		while ws.get_available_packet_count() > 0:
			var packet = ws.get_packet()
			if ws.was_string_packet():
				onMessage(packet.get_string_from_utf8())
			else:
				print("Received binary data: ", packet)
	elif state == WebSocketPeer.STATE_CLOSING:
		print("Closing websocket connection")
		pass
	elif state == WebSocketPeer.STATE_CLOSED:
		var code = ws.get_close_code()
		var reason = ws.get_close_reason()
		print("WebSocket closed with code: %d, reason: %s" % [code, reason])
		# set_process(false)  # Stop _process() from being called
		isConnected = false  
		await get_tree().create_timer(float(reconnection_delay_miliseconds) / 1000.0).timeout
		reconnect()


func onOpen() -> void:
	print("WebSocket connection opened.")

func onClose(was_clean: bool, code: int, reason: String) -> void:
	if was_clean:
		print("WebSocket connection closed cleanly, code=%s, reason=%s" % [str(code), reason])
	else:
		printerr("WebSocket connection died")
		await get_tree().create_timer(float(reconnection_delay_miliseconds) / 1000.0).timeout
		reconnect()

func onError():
	print("Error on ws connection")

func onMessage(stringData: String) -> void:
	var arcaneMessageFrom = JSON.parse_string(stringData)
#	print("Received Message: ", arcaneMessageFrom.e.name)

	if (events.has(arcaneMessageFrom.e.name)):
		for callback in events[arcaneMessageFrom.e.name]:
			if callback is Callable:
				callback.callv([arcaneMessageFrom.e, arcaneMessageFrom.from])	
				callback.callv([arcaneMessageFrom.e])	
				callback.callv([])	


func trigger(eventName:String, event):
	if events.has(eventName):
		for callback in events[eventName]:
			if callback is Callable:
				callback.callv([event])	
				callback.callv([])	
	
func emit(event: AEvents.ArcaneBaseEvent, to: Array[String]) -> void:
	
	var msg = AEvents.ArcaneMessageTo.new(event, to)
	
	if Arcane.logVerbose: print("Sending message: ", msg.e.name, " to: ", to)
	
	var msgDict = AUtils.objectToDictionary(msg)
	var msgJson = JSON.stringify(msgDict)
	#	var byteArray = PackedByteArray(msgJson.to_ascii_buffer())
	#	ws.send(byteArray)
	ws.send_text(msgJson)
	
func emitToViews(e: AEvents.ArcaneBaseEvent):
	emit(e, Arcane.iframeViewsIds)

func emitToPads(e):
	emit(e, Arcane.iframePadsIds)
	
	
func on(eventName: String, callback: Callable) -> void:
	
	if isCallbackRepeated(eventName, callback): 
		print_rich("[color=yellow]<a-warn> WsSvc: Callback for ", eventName, " event is repeated, skipping")
		return
	
	if not events.has(eventName):
		events[eventName] = []
				
		
	events[eventName].append(callback)

func isCallbackRepeated(eventName:String, callback:Callable):
	var callbackExists = false
	if events.has(eventName):
		for cb in events[eventName]:
			if(cb == callback):
				callbackExists = true
				break
	return callbackExists


func off(eventName: String, callback: Callable) -> void:
	if not events.has(eventName):
		prints("<a-warn> Can't off listener for event <>", eventName, "<> because it doesn't exist")
		return
	if callback:
		events[eventName].erase(callback)
		if events[eventName].size() == 0:
			events.erase(eventName)
	#else:
		#events.erase(eventName)
		
#func offCallback(eventName: String, callback: Callable) -> void:
	#if not events.has(eventName):
		#prints("Can't off listener for event ", eventName, " because it doesn't exist")
		#return
	#if callback:
		
		
#func offAllForEvent(eventName: String) -> void:
	#if events.has(eventName):
		#events.erase(eventName)

func close() -> void:
	ws.close()

func reconnect() -> void:
	print("Attempting to reconnect...")
	connectToServer(url)
