extends Control


var eventEmitter := AEventEmitter.new()
var counter = 0

func _ready():
    #test_emit_multiple_callbacks()
    test_event_duplication_prevention()
    test_event_off()

func increaseCounter():
    counter+=1
  
func increaseCounter2():
    counter+=1
    

#func test_emit_multiple_callbacks():
    #eventEmitter.on("increaseCounter", increaseCounter) 
    #eventEmitter.on("increaseCounter", increaseCounter) 
    #eventEmitter.emit("increaseCounter")
    #assertIsSameNumber(2, counter, "test_emit_multiple_callbacks")   


func test_event_duplication_prevention():
    eventEmitter.on("increaseCounter", increaseCounter) 
    eventEmitter.on("increaseCounter", increaseCounter2) 
    eventEmitter.emit("increaseCounter")
    assertIsSameNumber(1, counter, "test_event_duplication_prevention")   


func test_event_off():
    eventEmitter.on("increaseCounter", increaseCounter) 
    eventEmitter.offCallback("increaseCounter", increaseCounter)
    eventEmitter.emit("increaseCounter")
    assertIsSameNumber(0, counter, "test_event_off")   
    
    
    
func assertIsSameNumber(expected:int, result:int, functionName:String):
    if expected == result:
        print("Success")
        counter = 0
    else:
        printerr("Test Fail", expected, result, functionName)
