extends Node

# Assuming PlayerController is a custom class you've created
var players := []  # Array of PlayerController instances
#var playerPrefab := preload("res://path/to/playerPrefab.tscn")  # Replace with actual path
var gameStarted := false
var isGamePaused := false
var playerScene = preload("res://Scenes/View/Player/Player.tscn")

func _ready():
    Arcane.init(self, "view")
    
    Arcane.msg.on(AEventName.ArcaneClientInitialized, onArcaneClientInitialized)

func onArcaneClientInitialized(initialState: AModels.InitialState):
    for pad in initialState.pads:
        createPlayer(pad)
        
#	initialState.pads[0].onDisconnect(asd)
        
    Arcane.msg.on(AEventName.IframePadConnect, onIframePadConnect)
    Arcane.msg.on(AEventName.IframePadDisconnect, onIframePadDisconnect)

func onIframePadConnect(e):
    var playerExists = false
    for _player in players:
        if _player.pad.iframeId == e.iframeId:
            playerExists = true
            break
    if playerExists:
        return

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
    var newPlayer = playerScene.instantiate()
    print(newPlayer)
    newPlayer.initialize(pad)
    add_child(newPlayer)
    players.append(newPlayer)

func destroy_player(player):
    players.erase(player)
    if player:	player.queue_free()
