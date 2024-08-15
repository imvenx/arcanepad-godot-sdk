extends Control

const PadScenePath = "res://Scenes/Pad/Pad.tscn"
const ViewScenePath = "res://Scenes/View/View.tscn"


func _ready():
	call_deferred("goToPropperScene")
	
# INFO: This is a trick we do to have automatically loaded the game pad in the web exports
# The way it works is: We set the export WebGL without the View scene, so when we load on our
# phone, it will go automatically to the Pad scene, but on the editor, since it has all the
# scenes it will load the View. Feel free to change it to fit your workflow.
func goToPropperScene():
	if ResourceLoader.exists(PadScenePath) and not ResourceLoader.exists(ViewScenePath):
		goToPadScene()
		return
		
	goToViewScene()


func goToPadScene():
	get_tree().change_scene_to_file(PadScenePath)


func goToViewScene():
	get_tree().change_scene_to_file(ViewScenePath)
