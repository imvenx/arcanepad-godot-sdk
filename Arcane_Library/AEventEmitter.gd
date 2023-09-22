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


class_name EventEmitter

var _events: Dictionary = {}

func on(event: String, callback: Callable):
	if not _events.has(event):
		_events[event] = []
	_events[event].append(callback)

func off(event: String, callback: Callable):
	if _events.has(event):
		if callback:
			_events[event].erase(callback)
		else:
			_events[event] = []

func emit(event: String, data = null):
	if _events.has(event):
		for callback in _events[event]:
			callback.call_func(data)
