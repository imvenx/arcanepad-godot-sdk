class_name ArcanePad

var user
var deviceId: String
var internalId: String
var internalIdList: Array[String]
var iframeId: String
var iframeIdList: Array[String]
var isConnected: bool

var msg = Arcane.msg
var events: Dictionary = {}  # Dictionary to hold callbacks

func _init(_deviceId: String, _internalId: String, _iframeId: String, _isConnected: bool, _user = null):
	user = _user
	deviceId = _deviceId
	internalId = _internalId
	internalIdList = [_internalId]
	iframeId = _iframeId
	iframeIdList = [_iframeId]
	isConnected = _isConnected
	
	setupEvents()
	
func setupEvents():
	
	msg.on(AEventName.IframePadConnect, _onIframePadConnect)
	msg.on(AEventName.IframePadDisconnect, _onIframePadDisconnect)
	
	msg.on(AEventName.GetQuaternion, _proxyEvent)
	
	msg.on(AEventName.GetRotationEuler, _proxyEvent)
	
	msg.on(AEventName.GetPointer, _proxyEvent)
	
	msg.on(AEventName.OpenArcaneMenu, _proxyEvent)
	msg.on(AEventName.CloseArcaneMenu, _proxyEvent)


func _proxyEvent(event, from):
	var fullEventName = event.name + '_' + from
	_triggerEvent(fullEventName, event)

func _triggerEvent(eventNameWithId: String, event:Dictionary):
	if events.has(eventNameWithId):
		for callback in events[eventNameWithId]:
			if callback is Callable:
				callback.callv([event])	
				callback.callv([])	

func on(eventName: String, handler: Callable):
	if not events.has(eventName):
		events[eventName] = []
	events[eventName].append(handler)

func _onIframePadConnect(event, _from):
	_proxyEvent(event, event.iframeId)

func _onIframePadDisconnect(event, _from):
	_proxyEvent(event, event.iframeId)
	
func onConnect(callback: Callable):
	on(AEventName.IframePadConnect + '_' + iframeId, callback)
	
func onDisconnect(callback: Callable):
	on(AEventName.IframePadDisconnect + '_' + iframeId, callback)

func startGetQuaternion():
	msg.emit(AEvents.StartGetQuaternionEvent.new(), internalIdList)

func stopGetQuaternion(offAllListeners: bool = false):
	msg.emit(AEvents.StopGetQuaternionEvent.new(), internalIdList)
	if offAllListeners:
		events.erase(AEventName.GetQuaternion + '_' + internalId)

func onGetQuaternion(callback: Callable):
	on(AEventName.GetQuaternion + '_' + internalId, callback)

func calibrateQuaternion():
	msg.emit(AEvents.CalibrateQuaternionEvent.new(), internalIdList)

func startGetRotationEuler():
	msg.emit(AEvents.StartGetRotationEulerEvent.new(), internalIdList)

func stopGetRotationEuler(offAllListeners: bool = false):
	msg.emit(AEvents.StopGetRotationEulerEvent.new(), internalIdList)
	if offAllListeners:
		events.erase(AEventName.GetRotationEuler + '_' + internalId)

func onGetRotationEuler(callback: Callable):
	on(AEventName.GetRotationEuler + '_' + internalId, callback)

func startGetPointer():
	msg.emit(AEvents.StartGetPointerEvent.new(), internalIdList)

func stopGetPointer(offAllListeners: bool = false):
	msg.emit(AEvents.StopGetPointerEvent.new(), internalIdList)
	if offAllListeners:
		events.erase(AEventName.GetPointer + '_' + internalId)

func onGetPointer(callback: Callable):
	on(AEventName.GetPointer + '_' + internalId, callback)

func calibratePointer():
	msg.emit(AEvents.CalibratePointerEvent.new(), internalIdList)

func vibrate(milliseconds: int):
	msg.emit(AEvents.VibrateEvent.new(milliseconds), internalIdList)

func onOpenArcaneMenu(callback: Callable):
	on(AEventName.OpenArcaneMenu + '_' + iframeId, callback)

func onCloseArcaneMenu(callback: Callable):
	on(AEventName.CloseArcaneMenu + '_' + iframeId, callback)

func emit(event: AEvents.ArcaneBaseEvent):
	msg.emit(event, iframeIdList)

func offAll():
	events.clear()
