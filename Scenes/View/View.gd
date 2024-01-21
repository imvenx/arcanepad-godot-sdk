extends Node

var players := [] 
var gameStarted := false
var isGamePaused := false
var playerScene = preload("res://Scenes/View/Player/Player.tscn")

func _ready():
    Arcane.init(self, { "deviceType": "view", "logLevel": "asd" })
    
    Arcane.msg.on(AEventName.ArcaneClientInitialized, onArcaneClientInitialized)

func onArcaneClientInitialized(initialState: AModels.InitialState):
    
    for pad in initialState.pads: createPlayer(pad)
        
    Arcane.msg.on(AEventName.IframePadConnect, onIframePadConnect)
    Arcane.msg.on(AEventName.IframePadDisconnect, onIframePadDisconnect)
    

func onIframePadConnect(e):
    var playerExists = players.any(func(player): return player.pad.iframeId == e.iframeId)
    if playerExists: return

    var pad = ArcanePad.new(e.deviceId, e.internalId, e.iframeId, true, e.user)
    createPlayer(pad)
    

func onIframePadDisconnect(event):
    var player = null
    for _player in players:
        if _player.pad.iframeId == event.iframeId:
            player = _player
            break
            
    if player == null:
        push_error("Player not found to remove on disconnect")
        return

    destroy_player(player)


func createPlayer(pad):
    if(AUtils.isNullOrEmpty(pad.iframeId)): return
    
    var newPlayer = playerScene.instantiate()
    print(newPlayer)
    newPlayer.initialize(pad)
    add_child(newPlayer)
    players.append(newPlayer)
    

func destroy_player(player):
    players.erase(player)
    player.queue_free()
