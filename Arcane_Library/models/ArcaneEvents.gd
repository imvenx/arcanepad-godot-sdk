class_name ArcaneEvents

class ArcaneBaseEvent:
	var name: String

	func _init(_name: String):
		name = _name


class ArcaneMessageTo:
	var e: ArcaneBaseEvent
	var to

	func _init(_e: ArcaneBaseEvent, _to):
		e = _e
		to = _to


class ArcaneMessageFrom:
	var e: ArcaneBaseEvent
	var from: String

	func _init(_e: ArcaneBaseEvent, _from: String):
		e = _e
		from = _from


class InitializeEvent extends ArcaneBaseEvent:
	var assignedClientId: String
	var assignedDeviceId: String
	var globalState

	func _init(_assignedClientId: String, _assignedDeviceId: String, _globalState):
		name = "Initialize"
		assignedClientId = _assignedClientId
		assignedDeviceId = _assignedDeviceId
		globalState = _globalState


class ClientConnectEvent extends ArcaneBaseEvent:
	var clientId: String
	var clientType: String

	func _init(_clientId: String, _clientType: String):
		name = "ClientConnect"
		clientId = _clientId
		clientType = _clientType


class UpdateUserEvent extends ArcaneBaseEvent:
	var user

	func _init(_user):
		name = "UpdateUser"
		user = _user


class OpenArcaneMenuEvent extends ArcaneBaseEvent:
	func _init():
		name = "OpenArcaneMenu"


class CloseArcaneMenuEvent extends ArcaneBaseEvent:
	func _init():
		name = "CloseArcaneMenu"


class ClientDisconnectEvent extends ArcaneBaseEvent:
	var clientId: String
	var clientType

	func _init(_clientId: String, _clientType):
		name = "ClientDisconnect"
		clientId = _clientId
		clientType = _clientType


class IframePadConnectEvent extends ArcaneBaseEvent:
	var deviceId: String
	var internalId: String
	var iframeId: String

	func _init(_clientId: String, _internalId: String, _deviceId: String):
		name = "IframePadConnect"
		iframeId = _clientId
		internalId = _internalId
		deviceId = _deviceId


class IframePadDisconnectEvent extends ArcaneBaseEvent:
	var IframeId: String
	var DeviceId: String

	func _init(iframeId: String, deviceId: String):
		name = "IframePadDisconnect"
		IframeId = iframeId
		DeviceId = deviceId


class StartGetQuaternionEvent extends ArcaneBaseEvent:
	func _init():
		name = "StartGetQuaternion"


class StopGetQuaternionEvent extends ArcaneBaseEvent:
	func _init():
		name = "StopGetQuaternion"


class GetQuaternionEvent extends ArcaneBaseEvent:
	var w: float
	var x: float
	var y: float
	var z: float

	func _init(_w: float, _x: float, _y: float, _z: float):
		name = "GetQuaternion"
		w = _w
		x = _x
		y = _y
		z = _z


class CalibrateQuaternion extends ArcaneBaseEvent:
	func _init():
		name = "CalibrateQuaternion"


class StartGetRotationEulerEvent extends ArcaneBaseEvent:
	func _init():
		name = "StartGetRotationEuler"


class StopGetRotationEulerEvent extends ArcaneBaseEvent:
	func _init():
		name = "StopGetRotationEuler"


class GetRotationEulerEvent extends ArcaneBaseEvent:
	var x: float
	var y: float
	var z: float

	func _init(_x: float, _y: float, _z: float):
		name = "GetRotationEuler"
		x = _x
		y = _y
		z = _z


class StartGetPointerEvent extends ArcaneBaseEvent:
	func _init():
		name = "StartGetPointer"


class StopGetPointerEvent extends ArcaneBaseEvent:
	func _init():
		name = "StopGetPointer"


class GetPointerEvent extends ArcaneBaseEvent:
	var x: float
	var y: float

	func _init(_x: float, _y: float):
		name = "GetPointer"
		x = _x
		y = _y


class CalibratePointer extends ArcaneBaseEvent:
	func _init():
		name = "CalibratePointer"


class VibrateEvent extends ArcaneBaseEvent:
	var milliseconds: int

	func _init(_milliseconds: int):
		name = "Vibrate"
		milliseconds = _milliseconds

class RefreshGlobalStateEvent extends ArcaneBaseEvent:
	var refreshedGlobalState:AModels.GlobalState

	func _init(_refreshedGlobalState:AModels.GlobalState) -> void:
		name = "RefreshGlobalState"
		refreshedGlobalState = _refreshedGlobalState
