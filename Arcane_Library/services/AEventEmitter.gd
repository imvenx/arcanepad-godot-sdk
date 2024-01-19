class_name AEventEmitter

var _events: Dictionary = {}

func on(eventName: String, callback: Callable):
    if not _events.has(eventName):
        _events[eventName] = []
    _events[eventName].append(callback)

func off(eventName: String, callback: Callable):
    if _events.has(eventName):
        if callback:
            _events[eventName].erase(callback)
        else:
            _events[eventName] = []
            
func offAll(eventName: String):
    if _events.has(eventName):
        _events[eventName].erase()

func emit(eventName: String, eventData = null):
    if _events.has(eventName):
        for callback in _events[eventName]:
            callback.callv([eventData])
            callback.callv([])
