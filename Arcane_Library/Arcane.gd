extends Node

class_name Arcane

static var msg
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
