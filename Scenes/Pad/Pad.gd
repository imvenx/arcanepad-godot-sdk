extends Control

func _ready():
    Arcane.init(self, {"deviceType": "pad", "padOrientation": "portrait"})

    Arcane.msg.on(AEventName.ArcaneClientInitialized, onArcaneClientInitialized)
    
    Arcane.msg.on("HelloFromView", onHelloFromView)
    
        
func onArcaneClientInitialized(initialState: AModels.InitialState):
    print(initialState.pads)
    AUtils.writeToScreen(self, "Arcane Client Initialized")
    
    
func onHelloFromView():
    AUtils.writeToScreen(self, "View Says Hello")
    Arcane.pad.vibrate(200)
