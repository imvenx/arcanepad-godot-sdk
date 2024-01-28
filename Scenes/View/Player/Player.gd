extends Node


var pad:ArcanePad
var padQuaternion := Quaternion.IDENTITY

func initialize(_pad:ArcanePad) -> void:
    
    pad = _pad
    
     # Get User Name
    print("User Name: ", pad.user.name)
     # Get User Color
    print("User Color: #", pad.user.color)
    
    # Listen messages from the gamepad
    pad.on("Attack", onAttack)
    pad.on("CustomEvent", onCustomEvent)
    
    pad.on("SomeEvent", func(): print("something")) 
    # Stop Listening
    pad.off("SomeEvent") 
    
    # Send message from viewer to gamepad
    pad.emit(AEvents.ArcaneBaseEvent.new("HelloFromView")) 
    
    # Get rotation quaternion of the gamepad
    pad.startGetQuaternion()
    pad.onGetQuaternion(onGetQuaternion)
    # pad.stopGetQuaternion() 
    
    # Get pointer of the gamepad
    pad.startGetPointer()
    pad.onGetPointer(onGetPointer)
    # pad.stopGetPointer() 
    
    # Get linear acceleration of the gamepad
    #pad.startGetLinearAcceleration()
    #pad.onGetLinearAcceleration(onGetLinearAcceleration)
    #pad.stopGetLinearAcceleration() 
    
    
func _process(_delta):
    # Rotate player mesh with gamepad rotation
    $MeshInstance3D.transform.basis = Basis(padQuaternion)
    
    
func onAttack():
    
    # Send message to pad
    pad.emit(AEvents.ArcaneBaseEvent.new("HelloFromView")) 
    
    AUtils.writeToScreen(self, pad.user.name + " attacked")


func onCustomEvent(e):
    prints("Received custom event with val: ", e.someVal)
    

func onGetQuaternion(e):
    if(e.w == null || e.x == null || e.y == null || e.z == null): return
    
    # Set gamepad rotation to our padQuaternion variable, which will be used on _process
    # to rotate the mesh
    padQuaternion.x = -e.x
    padQuaternion.y = -e.y
    padQuaternion.z = e.z
    padQuaternion.w = e.w
    

func onGetPointer(e):
    if(e.x == null || e.y == null): return
    
    # Move the pointer
    var viewport_size = get_viewport().get_size()

    var new_x = viewport_size.x * (e.x / 100.0)
    var new_y = viewport_size.y * (e.y / 100.0)
    
    $Pointer.position = Vector2(new_x, new_y)
    
    
func onGetLinearAcceleration(e):
    prints("Linear Acceleration: ", e)
