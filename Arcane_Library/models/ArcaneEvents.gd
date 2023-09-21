class_name ArcaneEvents

class ArcaneBaseEvent:
	var name: String

	func _init(name: String):
		self.name = name


class ArcaneMessageTo:
	var e: ArcaneBaseEvent
	var to

	func _init(e: ArcaneBaseEvent, to):
		self.e = e
		self.to = to


class ArcaneMessageFrom:
	var e: ArcaneBaseEvent
	var from: String

	func _init(e: ArcaneBaseEvent, from: String):
		self.e = e
		self.from = from


class InitializeEvent extends ArcaneBaseEvent:
	var assignedClientId: String
	var assignedDeviceId: String
	var globalState

	func _init(assignedClientId: String, assignedDeviceId: String, globalState):
		self.name = "Initialize"
		self.assignedClientId = assignedClientId
		self.assignedDeviceId = assignedDeviceId
		self.globalState = globalState


class ClientConnectEvent extends ArcaneBaseEvent:
	var clientId: String
	var clientType: String

	func _init(clientId: String, clientType: String):
		self.name = "ClientConnect"
		self.clientId = clientId
		self.clientType = clientType


class UpdateUserEvent extends ArcaneBaseEvent:
	var user

	func _init(user):
		self.name = "UpdateUser"
		self.user = user


class OpenArcaneMenuEvent extends ArcaneBaseEvent:
	func _init():
		self.name = "OpenArcaneMenu"


class CloseArcaneMenuEvent extends ArcaneBaseEvent:
	func _init():
		self.name = "CloseArcaneMenu"


class ClientDisconnectEvent extends ArcaneBaseEvent:
	var clientId: String
	var clientType

	func _init(clientId: String, clientType):
		self.name = "ClientDisconnect"
		self.clientId = clientId
		self.clientType = clientType


class IframePadConnectEvent extends ArcaneBaseEvent:
	var deviceId: String
	var internalId: String
	var iframeId: String

	func _init(clientId: String, internalId: String, deviceId: String):
		self.name = "IframePadConnect"
		self.iframeId = clientId
		self.internalId = internalId
		self.deviceId = deviceId


class IframePadDisconnectEvent extends ArcaneBaseEvent:
	var IframeId: String
	var DeviceId: String

	func _init(iframeId: String, deviceId: String):
		self.name = "IframePadDisconnect"
		self.IframeId = iframeId
		self.DeviceId = deviceId


class StartGetQuaternionEvent extends ArcaneBaseEvent:
	func _init():
		self.name = "StartGetQuaternion"


class StopGetQuaternionEvent extends ArcaneBaseEvent:
	func _init():
		self.name = "StopGetQuaternion"


class GetQuaternionEvent extends ArcaneBaseEvent:
	var w: float
	var x: float
	var y: float
	var z: float

	func _init(w: float, x: float, y: float, z: float):
		self.name = "GetQuaternion"
		self.w = w
		self.x = x
		self.y = y
		self.z = z


class CalibrateQuaternion extends ArcaneBaseEvent:
	func _init():
		self.name = "CalibrateQuaternion"


class StartGetRotationEulerEvent extends ArcaneBaseEvent:
	func _init():
		self.name = "StartGetRotationEuler"


class StopGetRotationEulerEvent extends ArcaneBaseEvent:
	func _init():
		self.name = "StopGetRotationEuler"


class GetRotationEulerEvent extends ArcaneBaseEvent:
	var x: float
	var y: float
	var z: float

	func _init(x: float, y: float, z: float):
		self.name = "GetRotationEuler"
		self.x = x
		self.y = y
		self.z = z


class StartGetPointerEvent extends ArcaneBaseEvent:
	func _init():
		self.name = "StartGetPointer"


class StopGetPointerEvent extends ArcaneBaseEvent:
	func _init():
		self.name = "StopGetPointer"


class GetPointerEvent extends ArcaneBaseEvent:
	var x: float
	var y: float

	func _init(x: float, y: float):
		self.name = "GetPointer"
		self.x = x
		self.y = y


class CalibratePointer extends ArcaneBaseEvent:
	func _init():
		self.name = "CalibratePointer"


class VibrateEvent extends ArcaneBaseEvent:
	var milliseconds: int

	func _init(milliseconds: int):
		self.name = "Vibrate"
		self.milliseconds = milliseconds

class RefreshGlobalStateEvent extends ArcaneBaseEvent:
	var refreshedGlobalState

	func _init(refreshedGlobalState) -> void:
		self.name = "RefreshGlobalState"
		self.refreshedGlobalState = refreshedGlobalState
