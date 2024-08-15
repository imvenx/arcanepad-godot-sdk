extends Control

func _ready():
	Arcane.init(self, {"deviceType": "pad", "padOrientation": "portrait"})

	# Listen when the gamepad is initialized
	Arcane.msg.on(AEventName.ArcaneClientInitialized, onArcaneClientInitialized)
	
	# Listen event sent from the view
	Arcane.msg.on("HelloFromView", onHelloFromView)
	
		
func onArcaneClientInitialized(initialState: AModels.InitialState):
	print(initialState.pads)
	AUtils.writeToScreen(self, "Arcane Client Initialized")
	
	# Send untyped Message from gamepad to viewer
	Arcane.msg.emitToViews(AEvents.ArcaneBaseEvent.new("HelloFromPad"))
	# Send typed event from gamepad to the viewer
	Arcane.msg.emitToViews(MyCustomEvent.new(5))
   

func onHelloFromView():
	AUtils.writeToScreen(self, "View Says Hello")
	Arcane.pad.vibrate(200)


# INFO: Your custom typed events inherit from ArcaneBaseEvent.
# This could be an attack event or jump or move, etc.
class MyCustomEvent extends AEvents.ArcaneBaseEvent:
	var someVal:int
	
	func _init(_someVal:int):
		super._init("MyCustomEvent")
		someVal = _someVal
