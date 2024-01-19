extends Button


func _on_pressed():
    Arcane.msg.emitToViews(AEvents.ArcaneBaseEvent.new("Attack"))
