class_name ArcanePad

var user
var deviceId: String
var internalId: String
var internalIdList: Array[String]
var iframeId: String
var iframeIdList: Array[String]
var isConnected: bool

var msg = Arcane.msg
var eventEmitter = AEventEmitter.new() 

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
    
    msg.on(AEventName.IframePadConnect, func(e): _proxyEvent(e, e.iframeId))
    msg.on(AEventName.IframePadDisconnect, func(e): _proxyEvent(e, e.iframeId))
    
    msg.on(AEventName.GetQuaternion, _proxyEvent)
    
    msg.on(AEventName.GetRotationEuler, _proxyEvent)

    msg.on(AEventName.GetLinearAcceleration, _proxyEvent)
    
    msg.on(AEventName.GetPointer, _proxyEvent)
    
    msg.on(AEventName.OpenArcaneMenu, _proxyEvent)
    msg.on(AEventName.CloseArcaneMenu, _proxyEvent)
    
    msg.on(AEventName.PauseApp, _proxyEvent)
    msg.on(AEventName.ResumeApp, _proxyEvent)
    


func _proxyEvent(event, from):
    var fullEventName = event.name + '_' + from
    eventEmitter.emit(fullEventName, event)
#	_triggerEvent(fullEventName, event)

#func _triggerEvent(eventNameWithId: String, event:Dictionary):
#	if events.has(eventNameWithId):
#		for callback in events[eventNameWithId]:
#			if callback is Callable:
#				callback.callv([event])	
#				callback.callv([])	

func onConnect(callback: Callable):
    eventEmitter.on(AEventName.IframePadConnect + '_' + iframeId, callback)
    
func onDisconnect(callback: Callable):
    eventEmitter.on(AEventName.IframePadDisconnect + '_' + iframeId, callback)

func startGetQuaternion():
    msg.emit(AEvents.StartGetQuaternionEvent.new(), internalIdList)

func stopGetQuaternion(offAllListeners: bool = false):
    msg.emit(AEvents.StopGetQuaternionEvent.new(), internalIdList)
    if offAllListeners:
        eventEmitter.offAll(AEventName.GetQuaternion + '_' + internalId)

func onGetQuaternion(callback: Callable):
    eventEmitter.on(AEventName.GetQuaternion + '_' + internalId, callback)

func calibrateQuaternion():
    msg.emit(AEvents.CalibrateQuaternionEvent.new(), internalIdList)

func startGetRotationEuler():
    msg.emit(AEvents.StartGetRotationEulerEvent.new(), internalIdList)

func stopGetRotationEuler(offAllListeners: bool = false):
    msg.emit(AEvents.StopGetRotationEulerEvent.new(), internalIdList)
    if offAllListeners:
        eventEmitter.offAll(AEventName.GetRotationEuler + '_' + internalId)
      
func onGetRotationEuler(callback: Callable):
    eventEmitter.on(AEventName.GetRotationEuler + '_' + internalId, callback)
    

func startGetLinearAcceleration():
    msg.emit(AEvents.StartGetLinearAccelerationEvent.new(), internalIdList)

func stopGetLinearAcceleration(offAllListeners: bool = false):
    msg.emit(AEvents.StopGetLinearAccelerationEvent.new(), internalIdList)
    if offAllListeners:
        eventEmitter.offAll(AEventName.GetRotationEuler + '_' + internalId)
        
func onGetLinearAcceleration(callback: Callable):
    eventEmitter.on(AEventName.GetLinearAcceleration + '_' + internalId, callback)
    
    
func startGetPointer():
    msg.emit(AEvents.StartGetPointerEvent.new(), internalIdList)

func stopGetPointer(offAllListeners: bool = false):
    msg.emit(AEvents.StopGetPointerEvent.new(), internalIdList)
    if offAllListeners:
        eventEmitter.offAll(AEventName.GetPointer + '_' + internalId)

func onGetPointer(callback: Callable):
    eventEmitter.on(AEventName.GetPointer + '_' + internalId, callback)

func calibratePointer(isTopLeft:bool):
    msg.emit(AEvents.CalibratePointerEvent.new(isTopLeft), internalIdList)
    
    
func setScreenOrientationPortrait():
    msg.emit(AEvents.SetScreenOrientationPortraitEvent.new(), internalIdList)

func setScreenOrientationLandscape():
    msg.emit(AEvents.SetScreenOrientationLandscapeEvent.new(), internalIdList)

    

func vibrate(milliseconds: int):
    msg.emit(AEvents.VibrateEvent.new(milliseconds), internalIdList)


func onOpenArcaneMenu(callback: Callable):
    eventEmitter.on(AEventName.OpenArcaneMenu + '_' + iframeId, callback)

func onCloseArcaneMenu(callback: Callable):
    eventEmitter.on(AEventName.CloseArcaneMenu + '_' + iframeId, callback)


func onPauseApp(callback: Callable):
    eventEmitter.on(AEventName.PauseApp + '_' + iframeId, callback)
    
func onResume(callback: Callable):
    eventEmitter.on(AEventName.ResumeApp + '_' + iframeId, callback)

func emit(event: AEvents.ArcaneBaseEvent):
    msg.emit(event, iframeIdList)


func on(eventName: String, callback: Callable):
    var fullEventName = eventName + '_' + iframeId
    eventEmitter.on(fullEventName, callback)
    
    msg.on(eventName, proxyByIframeId)

 
func off(eventName:String):
    var fullEventName = eventName + '_' + iframeId
    eventEmitter.off(fullEventName)   
    msg.off(eventName, proxyByIframeId)


#func offCallback(eventName:String, callback:Callable):
    #var fullEventName = eventName + '_' + iframeId
    #eventEmitter.offCallback(fullEventName, callback) 
    #msg.offCallback(eventName, proxyByIframeId)
      #
    #msg.offCallback(eventName, proxyByIframeId)
    #msg.offCallback(eventName, proxyByIframeId)


# This is used both on on() and off() methods to unsubscribe properly
var proxyByIframeId = func(event, clientId): 
            if(clientId == iframeId):
                _proxyEvent(event, iframeId)
