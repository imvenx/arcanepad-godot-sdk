extends Node

# INFO: This is an implementation of how you could handle your gamepads
# connection/disconection, but is not definitive, if your game requires
# a different implementation go ahead and change this. For example maybe
# you don't want to destroy players on gamepad disconnect, instead you may
# want to pause the game.


var players := [] 
var gameStarted := false
var isGamePaused := false
var playerScene = preload("res://Scenes/View/Player/Player.tscn")

func _ready():
    Arcane.init(self, { "deviceType": "view", "logLevel": "verbose" })
    
    Arcane.msg.on(AEventName.ArcaneClientInitialized, onArcaneClientInitialized)

func onArcaneClientInitialized(initialState: AModels.InitialState):
    
    # Create a player for each gamepad that existed before the view was created
    for pad in initialState.pads: createPlayer(pad)
        
    # Listen to gamepads connecting after the view was created and create them if no exist
    Arcane.msg.on(AEventName.IframePadConnect, onIframePadConnect)
    # Listen for gamepads disconnecting and destroy the player
    Arcane.msg.on(AEventName.IframePadDisconnect, onIframePadDisconnect)

    # Listen pause app    
    Arcane.msg.on(AEventName.PauseApp, onPauseApp)

    # Listen resume app    
    Arcane.msg.on(AEventName.ResumeApp, onResumeApp)
    

func onPauseApp():
    $PausePanel.show()
    
func onResumeApp():
    $PausePanel.hide()
        
    
# We create a player if it wasn't created before
func onIframePadConnect(e):
    var playerExists = players.any(func(player): return player.pad.iframeId == e.iframeId)
    if playerExists: return

    var pad = ArcanePad.new(e.deviceId, e.internalId, e.iframeId, true, e.user)
    createPlayer(pad)
    

func onIframePadDisconnect(event):
    var disconnectedPlayer = null
    for _player in players:
        if _player.pad.iframeId == event.iframeId:
            disconnectedPlayer = _player
            break
            
    if disconnectedPlayer == null:
        push_error("Player not found to remove on disconnect")
        return

    destroy_player(disconnectedPlayer)


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
