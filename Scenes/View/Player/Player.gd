extends Node


var pad:ArcanePad
var padQuaternion := Quaternion.IDENTITY

func initialize(_pad:ArcanePad) -> void:
    
    pad = _pad
    
     # Get User Name
    print("User Name: ", pad.user.name)
     # Get User Color
    print("User Color: #", pad.user.color)
    
    # Listen Event
    pad.on("Attack", onAttack)
    
    pad.on("SomeEvent", func(): print("something")) 
    
    # Stop Listening event
    pad.off("SomeEvent") 
    
    pad.startGetQuaternion()
    pad.onGetQuaternion(onGetQuaternion)
    
    pad.startGetPointer()
    pad.onGetPointer(onGetPointer)
    
    
func _process(_delta):
    $MeshInstance3D.transform.basis = Basis(padQuaternion)
    
    
func onAttack():
    
    # Send message to pad
    pad.emit(AEvents.ArcaneBaseEvent.new("HelloFromView")) 
    
    AUtils.writeToScreen(self, pad.user.name + " attacked")
    
func onAttack2():
    AUtils.writeToScreen(self, pad.user.name + " attacked2")
    

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
