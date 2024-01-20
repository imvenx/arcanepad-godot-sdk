extends Node


var pad:ArcanePad
var padQuaternion := Quaternion.IDENTITY


func initialize(_pad:ArcanePad) -> void:
    print("Pad user!!", _pad.user.name)
    pad = _pad
    
    pad.on("Attack", onAttack)
    
    pad.startGetQuaternion()
    pad.onGetQuaternion(onGetQuaternion)
    
    
func _process(delta):
    self.transform.basis = Basis(padQuaternion)
    
    
func onAttack():
    prints(pad.user.name, "attacked")
    #pad.vibrate(100)
    pad.send(AEvents.ArcaneBaseEvent.new("HelloFromView"))


func onGetQuaternion(e):
    padQuaternion.x = -e.x
    padQuaternion.y = -e.y
    padQuaternion.z = e.z
    padQuaternion.w = e.w
