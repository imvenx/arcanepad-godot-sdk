class_name AEvents


class ArcaneBaseEvent:
    var name: String

    func _init(_name: String):
        name = _name


class ArcaneMessageTo:
    var to: Array
    var e: ArcaneBaseEvent

    func _init(_e: ArcaneBaseEvent, _to:Array[String]):
        e = _e
        to = _to

class ArcaneMessageFrom:
    var from: String
    var e: ArcaneBaseEvent

    func _init(_e: ArcaneBaseEvent, _from: String):
        e = _e
        from = _from


class InitializeEvent extends ArcaneBaseEvent:
    var assignedClientId: String
    var assignedDeviceId: String
    var globalState

    func _init(_assignedClientId: String, _assignedDeviceId: String, _globalState):
        super._init(AEventName.Initialize)
        assignedClientId = _assignedClientId
        assignedDeviceId = _assignedDeviceId
        globalState = _globalState


class ClientConnectEvent extends ArcaneBaseEvent:
    var clientId: String
    var clientType: String

    func _init(_clientId: String, _clientType: String):
        super._init(AEventName.ClientConnect)
        clientId = _clientId
        clientType = _clientType


class UpdateUserEvent extends ArcaneBaseEvent:
    var user

    func _init(_user):
        super._init(AEventName.UpdateUser)
        user = _user


class PauseAppEvent extends ArcaneBaseEvent:
    func _init():
        super._init(AEventName.PauseApp)
        
class ResumeAppEvent extends ArcaneBaseEvent:
    func _init():
        super._init(AEventName.ResumeApp)


class OpenArcaneMenuEvent extends ArcaneBaseEvent:
    func _init():
        super._init(AEventName.OpenArcaneMenu)

class CloseArcaneMenuEvent extends ArcaneBaseEvent:
    func _init():
        super._init(AEventName.CloseArcaneMenu)


class ClientDisconnectEvent extends ArcaneBaseEvent:
    var clientId: String
    var clientType

    func _init(_clientId: String, _clientType):
        super._init(AEventName.ClientDisconnect)
        clientId = _clientId
        clientType = _clientType


class IframePadConnectEvent extends ArcaneBaseEvent:
    var deviceId: String
    var internalId: String
    var iframeId: String

    func _init(_clientId: String, _internalId: String, _deviceId: String):
        super._init(AEventName.IframePadConnect)
        iframeId = _clientId
        internalId = _internalId
        deviceId = _deviceId


class IframePadDisconnectEvent extends ArcaneBaseEvent:
    var IframeId: String
    var DeviceId: String

    func _init(iframeId: String, deviceId: String):
        super._init(AEventName.IframePadDisconnect)
        IframeId = iframeId
        DeviceId = deviceId


class StartGetQuaternionEvent extends ArcaneBaseEvent:
    func _init():
        super._init(AEventName.StartGetQuaternion)


class StopGetQuaternionEvent extends ArcaneBaseEvent:
    func _init():
        super._init(AEventName.StopGetQuaternion)


class GetQuaternionEvent extends ArcaneBaseEvent:
    var w: float
    var x: float
    var y: float
    var z: float

    func _init(_w: float, _x: float, _y: float, _z: float):
        super._init(AEventName.GetQuaternion)
        w = _w
        x = _x
        y = _y
        z = _z


class CalibrateQuaternionEvent extends ArcaneBaseEvent:
    func _init():
        super._init(AEventName.CalibrateQuaternion)


class StartGetRotationEulerEvent extends ArcaneBaseEvent:
    func _init():
        super._init(AEventName.StartGetRotationEuler)


class StopGetRotationEulerEvent extends ArcaneBaseEvent:
    func _init():
        super._init(AEventName.StopGetRotationEuler)


class GetRotationEulerEvent extends ArcaneBaseEvent:
    var x: float
    var y: float
    var z: float

    func _init(_x: float, _y: float, _z: float):
        super._init(AEventName.GetRotationEuler)
        x = _x
        y = _y
        z = _z
        

class StartGetLinearAccelerationEvent extends ArcaneBaseEvent:
    func _init():
        super._init(AEventName.StartGetLinearAcceleration)


class StopGetLinearAccelerationEvent extends ArcaneBaseEvent:
    func _init():
        super._init(AEventName.StopGetLinearAcceleration)


class GetLinearAccelerationEvent extends ArcaneBaseEvent:
    var x: float
    var y: float
    var z: float

    func _init(_x: float, _y: float, _z: float):
        super._init(AEventName.GetLinearAcceleration)
        x = _x
        y = _y
        z = _z


class StartGetPointerEvent extends ArcaneBaseEvent:
    func _init():
        super._init(AEventName.StartGetPointer)


class StopGetPointerEvent extends ArcaneBaseEvent:
    func _init():
        super._init(AEventName.StopGetPointer)


class GetPointerEvent extends ArcaneBaseEvent:
    var x: float
    var y: float

    func _init(_x: float, _y: float):
        super._init(AEventName.GetPointer)
        x = _x
        y = _y


class CalibratePointerEvent extends ArcaneBaseEvent:
    var isTopLeft: bool
    
    func _init(_isTopLeft:bool):
        super._init(AEventName.CalibratePointer)
        isTopLeft = _isTopLeft

class SetScreenOrientationPortraitEvent extends ArcaneBaseEvent:
    func _init(): super._init(AEventName.SetScreenOrientationPortrait)
        
class SetScreenOrientationLandscapeEvent extends ArcaneBaseEvent:
    func _init(): super._init(AEventName.SetScreenOrientationLandscape)


class VibrateEvent extends ArcaneBaseEvent:
    var milliseconds: int

    func _init(_milliseconds: int):
        super._init(AEventName.Vibrate)
        milliseconds = _milliseconds

class RefreshGlobalStateEvent extends ArcaneBaseEvent:
    var refreshedGlobalState:AModels.GlobalState

    func _init(_refreshedGlobalState:AModels.GlobalState) -> void:
        super._init(AEventName.RefreshGlobalState)
        refreshedGlobalState = _refreshedGlobalState

    # func _init(dictionary:Dictionary) -> void:
    # 	name = AEventName.RefreshGlobalState
    # 	refreshedGlobalState = dictionary.refreshedGlobalState
    
