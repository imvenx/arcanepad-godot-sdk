extends Control

const PadScenePath = "res://Scenes/Pad/Pad.tscn"
const ViewScenePath = "res://Scenes/View/View.tscn"


func _ready():
    call_deferred("goToPropperScene")
    

func goToPropperScene():
    if ResourceLoader.exists(PadScenePath) and not ResourceLoader.exists(ViewScenePath):
        goToPadScene()
        return
        
    goToViewScene()


func goToPadScene():
    get_tree().change_scene_to_file(PadScenePath)


func goToViewScene():
    get_tree().change_scene_to_file(ViewScenePath)
