extends Node


var pad:ArcanePad
var padQuaternion := Quaternion.IDENTITY

func initialize(_pad:ArcanePad) -> void:
    
    print("Pad user!!", _pad.user.name)
    pad = _pad
    
    pad.on("Attack", onAttack)
    
    pad.startGetQuaternion()
    pad.onGetQuaternion(onGetQuaternion)
    
    pad.startGetPointer()
    pad.onGetPointer(onGetPointer)
    
    
func _process(delta):
    $MeshInstance3D.transform.basis = Basis(padQuaternion)
    
    
func onAttack():
    prints(pad.user.name, "attacked")
    #pad.vibrate(100)
    pad.send(AEvents.ArcaneBaseEvent.new("HelloFromView"))


func onGetQuaternion(e):
    if(e.w == null || e.x == null || e.y == null || e.z == null): return
    
    padQuaternion.x = -e.x
    padQuaternion.y = -e.y
    padQuaternion.z = e.z
    padQuaternion.w = e.w
    

func onGetPointer(e):
    if(e.x == null || e.y == null): return
    
    var viewport_size = get_viewport().get_size()

    var new_x = viewport_size.x * (e.x / 100.0)
    var new_y = viewport_size.y * (e.y / 100.0)
    
    $Pointer.position = Vector2(new_x, new_y)
