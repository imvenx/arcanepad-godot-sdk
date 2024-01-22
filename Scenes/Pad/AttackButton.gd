extends Button


func _ready():
    # Send Event to views on attack button pressed
    connect("pressed", func(): Arcane.msg.emitToViews(AEvents.ArcaneBaseEvent.new("Attack")))
