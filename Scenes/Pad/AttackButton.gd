extends Button


func _ready():
    connect("pressed", func(): Arcane.msg.emitToViews(AEvents.ArcaneBaseEvent.new("Attack")))
