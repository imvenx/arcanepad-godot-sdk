extends Node

class_name Arcane

static var LIBRARY_VERSION: String = "1.1.1" 

static var msg: WebsocketService
static var devices = [AModels.ArcaneDevice]
static var pads: Array[ArcanePad] = []
static var internalViewsIds: Array[String] = []
static var internalPadsIds: Array[String] = []
static var iframeViewsIds: Array[String] = []
static var iframePadsIds: Array[String] = []
static var pad:ArcanePad
static var logLevel = ''
static var logVerbose = false
#static var logWarn = false

static var defaultParams = {
	'deviceType': 'view',
	'port': '3685',
	'reverseProxyPort': '3689',
	'hideMouse': true,
	'padOrientation': 'landscape',
	'logLevel': 'verbose'
#	'arcaneCode': '',
}

static var initParams = defaultParams
	
static func init(instance:Node, _initParams = defaultParams):

	# Merge the providedParams dictionary into the params dictionary
	for key in _initParams: initParams[key] = _initParams[key]
	   
	logLevel = initParams.logLevel
	logVerbose = logLevel == 'verbose'
	#logWarn = logLevel == 'verbose' || logLevel == 'warn'
	
	print_rich('[color=cyan][b]<> <> <> <> <> <> <> <> <> <> <> <> <> <>
  Using Arcanepad Library version ', LIBRARY_VERSION,
	'\n<> <> <> <> <> <> <> <> <> <> <> <> <> <>')
	
	print('Initializing Client...')
	
	msg = WebsocketService.new(initParams.deviceType)
	instance.add_child(msg)

	msg.on(AEventName.Initialize, _onInitialize)
	msg.on(AEventName.RefreshGlobalState, _refreshGlobalState)
	
static func _onInitialize(initializeEvent, _from):
	refreshGlobalState(initializeEvent.globalState)
	
	if msg.deviceType == "pad": _padInitialization()
	elif msg.deviceType == "view": _viewInitialization()
			  
	var initialState = AModels.InitialState.new(pads)
	msg.trigger(AEventName.ArcaneClientInitialized, initialState)
#	eventEmitter.emit(AEventName.ArcaneClientInitialized, initialState)
#	emit_signal("arcaneClientInitialized", initialState)
	
	msg.off(AEventName.Initialize, _onInitialize)


static func _padInitialization():
	for _pad in pads:
		if _pad.deviceId == msg.deviceId:
			pad = _pad
			break
			
	if pad == null: 
		printerr('Pad is null on iframe pad initialization')
		return
		
	if initParams.padOrientation == 'landscape': pad.setScreenOrientationLandscape()
	elif initParams.padOrientation == 'portrait': pad.setScreenOrientationPortrait()
	

static func _viewInitialization():
	if(initParams.hideMouse == true):
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


static func _refreshGlobalState(e):
	refreshGlobalState(e.refreshedGlobalState)


static func refreshGlobalState(refreshedGlobalState):
	devices = refreshedGlobalState.devices
	refreshClientsIds(devices)
	pads = getPads(devices)
#	pads[0].startGetQuaternion()
#	pads[0].onGetQuaternion(asd)
	
#func asd(e):
#	print(e)
	
	
static func refreshClientsIds(_devices: Array) -> void:
	var _internalPadsIds: Array[String] = []
	var _internalViewsIds: Array[String] = []
	var _iframePadsIds: Array[String] = []
	var _iframeViewsIds: Array[String] = []
	
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
	
	
static func getPads(_devices: Array) -> Array[ArcanePad]:
	var _pads:Array[ArcanePad] = []
	
	var padDevices = []
	
	for device in _devices:
		if device.deviceType == AModels.ArcaneDeviceType.pad:
			#var iframeClients = []
			#for client in device.clients:
				#if client.clientType == AModels.ArcaneClientType.iframe:
					#iframeClients.append(client)
			#if iframeClients.size() > 0:
			padDevices.append(device)

	for padDevice in padDevices:
		var iframeClientId: String = ""
		var internalClientId: String = ""
		
		for client in padDevice.clients:
			if client.clientType == AModels.ArcaneClientType.iframe:
				iframeClientId = client.id
			elif client.clientType == AModels.ArcaneClientType.internal:
				internalClientId = client.id
		
		if internalClientId == null: printerr("<> Arcane Error: Internal Client ID is null")
		else:
			
			var user = padDevice.user if padDevice.has('user') else {}
			
			var _pad = ArcanePad.new(padDevice.id, internalClientId, iframeClientId, true, user)
			_pads.append(_pad)

	return _pads
