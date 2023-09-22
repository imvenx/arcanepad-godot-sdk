extends Node

class_name Arcane

static var msg: WebsocketService
static var devices = [AModels.ArcaneDevice]
static var pads = []
static var internalViewsIds = []
static var internalPadsIds = []
static var iframeViewsIds = []
static var iframePadsIds = []
#static var _pad = null  # private static variable

func _ready():
	var url = "wss://localhost:3005/"
	
	if Engine.has_singleton("DebugMode") or ["Windows", "X11", "OSX"].has(OS.get_name()):
		url = "ws://localhost:3009/"

	var deviceType = "view"
	msg = WebsocketService.new(url, deviceType)
	self.add_child(msg)

	msg.on("Initialize", initialize)

func initialize(initializeEvent, _from):
	refreshGlobalState(initializeEvent.globalState)

func refreshGlobalState(refreshedGlobalState):
	devices = refreshedGlobalState.devices
	refreshClientsIds(devices)
	pads = getPads(devices)
	
func refreshClientsIds(_devices: Array) -> void:
	var _internalPadsIds: Array = []
	var _internalViewsIds: Array = []
	var _iframePadsIds: Array = []
	var _iframeViewsIds: Array = []
	
	for device in _devices:
		if device.deviceType == AModels.ArcaneDeviceType.pad:
			for client in device.clients:
				if client.clientType == AModels.ArcaneClientType.internal:
					_internalPadsIds.append(client.id)
				else:
					_iframePadsIds.append(client.id)
					
		elif device.deviceType == AModels.ArcaneDeviceType.view:
			for client in device.clients:
				if client.clientType == AModels.ArcaneClientType.internal:
					_internalViewsIds.append(client.id)
				else:
					_iframeViewsIds.append(client.id)
					
	internalPadsIds = _internalPadsIds
	internalViewsIds = _internalViewsIds
	iframePadsIds = _iframePadsIds
	iframeViewsIds = _iframeViewsIds
	
func getPads(_devices: Array) -> Array:
	var _pads = []
	
	var padDevices = []
	for device in _devices:
		if device.deviceType == "ArcaneDeviceType.pad":
			var iframeClients = []
			for client in device.clients:
				if client.clientType == "ArcaneClientType.iframe":
					iframeClients.append(client)
			if iframeClients.size() > 0:
				padDevices.append(device)

	for padDevice in padDevices:
		var iframeClientId: String
		var internalClientId: String
		
		for client in padDevice.clients:
			if client.clientType == "ArcaneClientType.iframe":
				iframeClientId = client.id
			elif client.clientType == "ArcaneClientType.internal":
				internalClientId = client.id

		if iframeClientId == null or iframeClientId == "":
			print("Tried to set pad but iframeClientId was not found")
		
		if internalClientId == null or internalClientId == "":
			print("Tried to set pad but internalClientId was not found")
		
		if iframeClientId != null and internalClientId != null:
			var pad = ArcanePad.new(padDevice.id, internalClientId, iframeClientId, true, padDevice.user)
			_pads.append(pad)

	return _pads
