extends Node

class_name WebsocketService

signal event_received(event_data, from)

var ws: WebSocketPeer = WebSocketPeer.new()
var event_handlers: Dictionary = {}
var client_id: String
var device_id: String
var reconnection_delay_miliseconds: int = 1000
var clientInitData: AModels.ArcaneClientInitData
var url: String
var device_type:String

func _init(_url: String, _device_type: String) -> void:
	url = _url
	device_type = _device_type
	initWebsocket()

func initWebsocket():
	clientInitData = AModels.ArcaneClientInitData.new("external", "godot-dev", device_type)
	var clientInitDataDictionary = AUtils.objectToDictionary(clientInitData)
	var stringifiedClientInitData = JSON.stringify(clientInitDataDictionary)
	var encodedClientInitData = AUtils.urlEncode(stringifiedClientInitData)
	url = url + "?clientInitData=" + encodedClientInitData
	connectToServer(url)

func connectToServer(_url:String) -> void:
	print("connecting  to server: ", _url)
	var err = ws.connect_to_url(_url)
	if err != OK:
		printerr("Failed to connect:", err)
		return
		
var isConnected = false  # Add this variable to keep track
func _process(delta: float) -> void:
#	ws.poll()
#	var state = ws.get_ready_state()
#
#	if state == WebSocketPeer.STATE_OPEN and not has_connected:
#		print("WebSocket connection opened.")
#		has_connected = true
#	elif state == WebSocketPeer.STATE_CLOSED:
#		print("Connection closed")
#		set_process(false)
#		has_connected = false  # Reset the flag
#		await get_tree().create_timer(float(reconnection_delay_miliseconds) / 1000.0).timeout
#		reconnect()

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
#				print("Received text data: %s" % packet.get_string_from_utf8())
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
		set_process(false)  # Stop _process() from being called
		isConnected = false  # Reset the flag
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

func onMessage(data: String) -> void:
#	print(JSON.parse_string(data))
	var arcaneMsg:ArcaneEvents.ArcaneMessageFrom = JSON.parse_string(data) 
	print(arcaneMsg.e.name)
#	if (event_handlers.has(arcaneMsg.e.name)):
#		for callback in event_handlers[event["e"]["name"]]:
#			callback(event["e"], event["from"])

#func emit(event: Dictionary, to: Array) -> void:
#	var msg: Dictionary = {"event": event, "to": to}
#	print("Sending message: %s" % str(msg))
#	ws.send(to_json(msg))

#func on(event_name: String, callback: Signal) -> void:
#	if not event_handlers.has(event_name):
#		event_handlers[event_name] = []
#	event_handlers[event_name].append(callback)

#func off(event_name: String, callback: Signal) -> void:
#	if not event_handlers.has(event_name):
#		return
#	if callback:
#		event_handlers[event_name].erase(callback)
#		if event_handlers[event_name].size() == 0:
#			event_handlers.erase(event_name)
#	else:
#		event_handlers.erase(event_name)

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

#func on_initialize(e: ArcaneEvents.InitializeEvent) -> void:
#	if not e.has("assignedClientId"):
#		return printerr("Missing client id on initialize")
#	if not e.has("assignedDeviceId"):
#		return printerr("Missing device id on initialize")
#	client_id = e["assignedClientId"]
#	device_id = e["assignedDeviceId"]
#	print("Client initialized with clientId: %s and deviceId: %s" % [client_id, device_id])
