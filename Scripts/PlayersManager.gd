extends Node

# Assuming PlayerController is a custom class you've created
var players := []  # Array of PlayerController instances
#var playerPrefab := preload("res://path/to/playerPrefab.tscn")  # Replace with actual path
var gameStarted := false
var isGamePaused := false
var playerScene = preload("res://Player/Player.tscn")

func _ready():
	AEventEmitter.on(AEventName.ArcaneClientInitialized, onArcaneClientInitialized)

func onArcaneClientInitialized(initialState: AModels.InitialState):
	for pad in initialState.pads:
		createPlayer(pad)
		
	Arcane.msg.on(AEventName.IframePadConnect, onIframePadConnect)
	Arcane.msg.on(AEventName.IframePadDisconnect, onIframePadDisconnect)

func onIframePadConnect(event):
	var playerExists = false
	for p in players:
		if p.Pad.iframeId == event.iframeId:
			playerExists = true
			break
	if playerExists:
		return

#	var pad = ArcanePad.new(device_id=event.device_id, internal_id=event.internal_id, iframeId=event.iframeId, is_connected=true, user=Arcane.Devices.find(func d: d.id == event.device_id).user)
#	createPlayer(pad)
#
func onIframePadDisconnect(event):
	var player = false
	for p in players:
		if p.Pad.iframeId == event.iframeId:
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
