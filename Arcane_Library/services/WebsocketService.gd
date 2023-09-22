extends Node

class_name WebsocketService

# signal event_received(event_data, from)

var ws: WebSocketPeer = WebSocketPeer.new()
var events: Dictionary = {}
var clientId: String
var deviceId: String
var reconnection_delay_miliseconds: int = 1000
var clientInitData: AModels.ArcaneClientInitData
var url: String
var deviceType:String
var isConnected = false

func _init(_url: String, _deviceType: String) -> void:
	url = _url
	deviceType = _deviceType
	initWebsocket()
#	on("RefreshGlobalState", qwe)
	
#func qwe(refreshGlobalStateEvent:Dictionary, from:String):
##	var asd = AEvents.RefreshGlobalStateEvent.new({refreshGlobalStateEvent: AModels.GlobalState.new("")})
##	print("Event data:", refreshGlobalStateEvent.refreshedGlobalState.devices)
#	print("From:", from)
#	emit(AEvents.OpenArcaneMenuEvent.new(), [])

func initWebsocket():
	clientInitData = AModels.ArcaneClientInitData.new("external", "godot-dev", deviceType)
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
	print("Client initialized with clientId: %s and deviceId: %s" % [clientId, deviceId])

func connectToServer(_url:String) -> void:
	print("connecting  to server: ", _url)
	var err = ws.connect_to_url(_url)
	if err != OK:
		printerr("Failed to connect:", err)
		return
		
func _process(_delta: float) -> void:

	ws.poll()  # Update the connection state and receive incoming packets

	var state = ws.get_ready_state() 
	
#	if(state == WebSocketPeer.STATE_CONNECTING):
#		print("Websocket connecting...")

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

#
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

func on(eventName: String, handler: Callable) -> void:
	if not events.has(eventName):
		events[eventName] = []
	events[eventName].append(handler)

func emit(event: AEvents.ArcaneBaseEvent, to: Array[String]) -> void:
	var msg = AEvents.ArcaneMessageTo.new(event, to)
	print("Sending message: ", msg.e.name, " to: ", to)
	
	var msgDict = AUtils.objectToDictionary(msg)
	var msgJson = JSON.stringify(msgDict)
#	var byteArray = PackedByteArray(msgJson.to_ascii_buffer())
#	ws.send(byteArray)
	ws.send_text(msgJson)

#func on(event_name: String, callback: Signal) -> void:
#	if not events.has(event_name):
#		events[event_name] = []
#	events[event_name].append(callback)

#func off(event_name: String, callback: Signal) -> void:
#	if not events.has(event_name):
#		return
#	if callback:
#		events[event_name].erase(callback)
#		if events[event_name].size() == 0:
#			events.erase(event_name)
#	else:
#		events.erase(event_name)

#func close() -> void:
#	ws.close()

func reconnect() -> void:
	print("Attempting to reconnect...")
	connectToServer(url)

#func initialize_ws(url: String, client_init_data: Dictionary) -> void:
#	ws.uri = "%s?clientInitData=%s" % [url, to_json(client_init_data)]
#	ws.connect("connection_established", self, "on_open")
#	ws.connect("connection_error", self, "on_error")
#	ws.connect("connection_closed", self, "on_close")
#	ws.connect("data_received", self, "on_message")
#	ws.connect_to_url(ws.uri)

#const InitializeEvent = preload("res://models/arcaneevents.gd").InitializeEvent

#func on_initialize(e: AEvents.InitializeEvent) -> void:
#	if not e.has("assignedClientId"):
#		return printerr("Missing client id on initialize")
#	if not e.has("assignedDeviceId"):
#		return printerr("Missing device id on initialize")
#	clientId = e["assignedClientId"]
#	deviceId = e["assignedDeviceId"]
#	print("Client initialized with clientId: %s and deviceId: %s" % [clientId, deviceId])
