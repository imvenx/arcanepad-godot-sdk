extends Node

# Assuming PlayerController is a custom class you've created
var players := []  # Array of PlayerController instances
#var playerPrefab := preload("res://path/to/playerPrefab.tscn")  # Replace with actual path
var gameStarted := false
var isGamePaused := false
var playerScene = preload("res://Player/Player.tscn")

func _ready():
	AGlobalEventEmitter.on(AEventName.ArcaneClientInitialized, onArcaneClientInitialized)

func onArcaneClientInitialized(initialState: AModels.InitialState):
	for pad in initialState.pads:
		createPlayer(pad)
		
	initialState.pads[0].onDisconnect(asd)
		
	Arcane.msg.on(AEventName.IframePadConnect, onIframePadConnect)
	Arcane.msg.on(AEventName.IframePadDisconnect, onIframePadDisconnect)

func onIframePadConnect(e):
	var playerExists = false
	for p in players:
		if p.Pad.iframeId == e.iframeId:
			playerExists = true
			break
	if playerExists:
		return

	var pad = ArcanePad.new(e.deviceId, e.internalId, e.iframeId, true, e.user)
	createPlayer(pad)

func asd():
	print('asdasd')

func onIframePadDisconnect(event):
	var player = false
	for p in players:
		if p.pad.iframeId == event.iframeId:
			player = p
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
	player.queue_free()
