class_name AModels

class ArcaneClient:
	var id: String
	var clientType: String

	func _init(_id: String, _clientType: String) -> void:
		id = _id
		clientType = _clientType

class ArcaneClientType:
	const internal = "internal"
	const iframe = "iframe"
	const external = "external"

class ArcaneDevice:
	var id: String
	var clients: Array[ArcaneClient] = []
	var deviceType: String
	var user = null

class ArcaneDeviceType:
	const pad = "pad"
	const view = "view"
	const none = "none"

enum ArcaneDeviceTypeEnum { view, pad }

class ArcaneClientInitData:
	var clientType: String
	var deviceType: String
	var deviceId: String

	func _init(_clientType:String, _deviceType:String, _deviceId:String):
		clientType = _clientType
		deviceType = _deviceType
		deviceId = _deviceId

class AssignedDataInitEvent:
	var eventTag: String = "init"
	var assignedClientId: String
	var assignedDeviceId: String

class InitIframeQueryParams:
	var deviceId: String

class GlobalState:
	var devices: Array[ArcaneDevice] = []

	func _init(_devices) -> void:
		devices = _devices

class InitialState:
	var pads: Array[ArcanePad] = []

	func _init(_pads) -> void:
		pads = _pads

class ArcaneUser:
	var id: String
	var name: String
	var color: String

	func _init(_id: String, _name: String, _color: String) -> void:
		id = id
		name = name
		color = color
