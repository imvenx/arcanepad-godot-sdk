extends Control

func _ready():
    Arcane.init(self, "pad")

    Arcane.msg.on(AEventName.ArcaneClientInitialized, onArcaneClientInitialized)
    
func onArcaneClientInitialized(initialState: AModels.InitialState):
    print(initialState.pads)
