extends Button


func _ready():
    connect("pressed", func(): Arcane.pad.calibratePointer(true))
