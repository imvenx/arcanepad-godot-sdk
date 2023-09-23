# class_name ArcaneEventEmitter

# var eventHandlers: Dictionary = {}

# func on(name: String, callback):
#     if not eventHandlers.has(name):
#         eventHandlers[name] = []
#     eventHandlers[name].append(callback)
#     return funcref(self, "off").bind(name, callback)

# func off(name: String, callback = null):
#     if not eventHandlers.has(name):
#         return
#     if callback == null:
#         eventHandlers.erase(name)
#     else:
#         eventHandlers[name].erase(callback)

# func emit(name: String, event):
#     if eventHandlers.has(name):
#         for singleCallback in eventHandlers[name]:
#             singleCallback.call_func(event)

# func offAll():
#     eventHandlers.clear()


class_name AEventEmitter

static var _events: Dictionary = {}

static func on(eventName: String, callback: Callable):
	if not _events.has(eventName):
		_events[eventName] = []
	_events[eventName].append(callback)

static func off(eventName: String, callback: Callable):
	if _events.has(eventName):
		if callback:
			_events[eventName].erase(callback)
		else:
			_events[eventName] = []
			
static func offAll(eventName: String):
	if _events.has(eventName):
		_events[eventName].erase()

static func emit(eventName: String, eventData = null):
	if _events.has(eventName):
		for callback in _events[eventName]:
			callback.callv([eventData])
			callback.callv([])
