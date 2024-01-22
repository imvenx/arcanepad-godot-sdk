extends Node

var count = 0

func _ready():
    Arcane.init(self)
    Arcane.msg.on(AEventName.ArcaneClientInitialized, onInit)
      
func onInit(initialState: AModels.InitialState):
    
    Arcane.pad = ArcanePad.new("d", "i", "if", false, {"name":"test", "color":"1166ff"}) 
    Arcane.pad.on("Count", Count)
    Arcane.pad.on("Count", Count2)
    print(Arcane.msg.events.has("Count"))
    print(Arcane.msg.events.has("Count2"))
    
func Count():
    count += 1
    
func Count2():
    count += 1
