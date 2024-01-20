extends Button


func _ready():
    connect("pressed", func(): Arcane.pad.calibrateQuaternion())
