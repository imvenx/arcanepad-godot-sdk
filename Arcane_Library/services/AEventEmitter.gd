class_name AEventEmitter

var _events: Dictionary = {}

func on(eventName: String, callback: Callable):
                
    #if isCallbackRepeated(eventName, callback): 
        #print_rich("[color=yellow]<a-warn> EvtEmt: Callback for ", eventName, " event is repeated, skipping")
        #return
        
    if(_events.has(eventName)):
        print_rich("[color=yellow]<a-warn> EvtEmt: ", eventName, " event has registered a callback already, skipping, if you want to register a new callback first off the old one")
        return
        
    if not _events.has(eventName):
        _events[eventName] = []
        
    _events[eventName].append(callback)
    
    
func isCallbackRepeated(eventName:String, callback:Callable):
    var callbackExists = false
    if(_events.has(eventName)):
        for cb in _events[eventName]:
            if(cb == callback):
                callbackExists = true
                break
    return callbackExists


func off(eventName: String):
    if _events.has(eventName):
        #_events[eventName].clear()
        _events.erase(eventName)
        
#func off(eventName: String, callback: Callable):
    #if _events.has(eventName):
        #if callback:
            #_events[eventName].erase(callback)
        #else:
            #_events[eventName] = []
            

        

#func offCallback(eventName: String, callback: Callable):
    #if _events.has(eventName):
        #_events[eventName].erase(callback)


func emit(eventName: String, eventData = null):
    if _events.has(eventName):
        for callback in _events[eventName]:
            callback.callv([eventData])
            callback.callv([])
