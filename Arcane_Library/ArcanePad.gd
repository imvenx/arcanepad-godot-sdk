class_name ArcanePad

# Declare signals
signal getQuaternion(event, clientId)
signal getRotationEuler(event, clientId)
signal getPointer(event, clientId)
signal iframePadConnect(event, from)
signal iframePadDisconnect(event, from)
signal openArcaneMenu(event, fromId)
signal closeArcaneMenu(event, fromId)

var user
var deviceId: String
var internalId: String
var internalIdList: Array
var iframeId: String
var iframeIdList: Array
var isConnected: bool

var msg = Arcane.msg

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
    # msg.on("GetQuaternion", proxyEvent)
    # msg.on("GetRotationEuler", onGetRotationEuler)
    # msg.on("GetPointer", onGetPointer)
    msg.on("IframePadConnect", proxyEvent)
    # msg.on("IframePadDisconnect", iframePadDisconnect)
    # msg.on("OpenArcaneMenu", openArcaneMenu)
    # msg.on("CloseArcaneMenu", closeArcaneMenu)

func proxyEvent(event, padId: String):
    print("proxying some event!!!!!!!!!!!", event.name)
    var fullEventName = "%s_%s" % [event.name, padId]
    emit_signal(event.name, fullEventName, event)

# func onGetQuaternion(event, clientId):
#     emit_signal("getQuaternion", event, clientId)

# func onGetRotationEuler(event, clientId):
#     emit_signal("getRotationEuler", event, clientId)

# func onGetPointer(event, clientId):
#     emit_signal("iframePadConnect", event, closeArcaneMenu)

func onIframePadConnect(_event, _from):
    print("emiting iframe pad connected!!!!!!!!!!!")
    isConnected = true
    emit_signal(AEventName.IframePadConnect, _event, _event.iframeId)

# func onIframePadDisconnect(event, from):
#     isConnected = false
#     emit_signal("iframe_pad_disconnect", event, event.iframeId)

# func _on_open_arcane_menu(event, fromId):
#     emit_signal("open_arcane_menu", event, fromId)

# func _on_close_arcane_menu(event, fromId):
#     emit_signal("close_arcane_menu", event, fromId)
