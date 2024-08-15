extends Node

class_name AUtils

static func urlEncode(s: String) -> String:
	var result = ""
	var utf8_bytes = s.to_utf8_buffer()
	for byte in utf8_bytes:
		if char(byte) in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.~{}":
			result += char(byte)
		elif char(byte) == " ":
			result += "+"
		else:
			result += "%" + "%02X" % byte
	return result

static func objectToDictionary(obj) -> Dictionary:
	var result = {}
	if obj is Dictionary or obj is Array or typeof(obj) in [TYPE_FLOAT, TYPE_STRING, TYPE_INT]:
		return obj
	
	for property in obj.get_property_list():
		var propertyName = property.name
		# Skip unwanted or built-in properties.
		if propertyName in ["RefCounted", "script"] or not property.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
			continue
		
		var value = obj.get(propertyName)
		# Handle recursive conversion of objects, dictionaries, and arrays.
		if value is Object:
			value = objectToDictionary(value)
		elif value is Array:
			var newArray = []
			for item in value:
				if item is Object:
					newArray.append(objectToDictionary(item))
				else:
					newArray.append(item)
			value = newArray
		elif value is Dictionary:
			var newDict = {}
			for key in value.keys():
				if value[key] is Object:
					newDict[key] = objectToDictionary(value[key])
				else:
					newDict[key] = value[key]
			value = newDict

		result[propertyName] = value
	return result

# static func dictionaryToObject(d: Dictionary, obj: Object) -> void:
# 	if typeof(d) != TYPE_DICTIONARY:
# 		return
	
# 	for key in d.keys():
# 		var value = d[key]
# 		if typeof(value) == TYPE_DICTIONARY:
# 			# Replace 'Object' with the type you're expecting for sub-objects
# 			var subObj = preload("YourObjectType.gd").new()  
# 			dictionaryToObject(value, subObj)
# 			obj.set(key, subObj)
# 		elif typeof(value) == TYPE_ARRAY:
# 			var newArray: Array = []
# 			for item in value:
# 				if typeof(item) == TYPE_DICTIONARY:
# 					# Replace 'Object' with the type you're expecting for array items
# 					var subObj = preload("YourObjectType.gd").new()  
# 					dictionaryToObject(item, subObj)
# 					newArray.append(subObj)
# 				else:
# 					newArray.append(item)
# 			obj.set(key, newArray)
# 		else:
# 			obj.set(key, value)
			

# static func applyJsonToObject(obj: Object, data: Dictionary) -> void:
# 	for key in data.keys():
# 		if obj.has_property(key):
# 			obj.set(key, data[key])
#

# static func dictionaryToObject(dict: Dictionary, obj: Object) -> void:
# 	var property_names = []
# 	for property in obj.get_property_list():
# 		property_names.append(property.name)

# 	for key in dict.keys():
# 		if key in property_names:
# 			obj.set(key, dict[key])

static func dictionaryToObject(dictionary: Dictionary) -> Object:
	# print(ClassDB.get_class_list())
	# ClassDB.set()
	# var asd = RefreshGlobalStateEvent.new()
	var className = dictionary["name"] + "Event"
	# print("Checking class: ", className)

	# if ClassDB.class_exists(className):
	var instance = ClassDB.instantiate(className)
	
	if instance == null:
		print("Failed to instantiate class: ", className)
		return null

	for key in dictionary.keys():
		var method_name = "set_" + key
		if instance.has_method(method_name):
			instance.call(method_name, dictionary[key])
		else:
			print("Method does not exist: ", method_name)

	return instance
	# else:
	# 	print("Class does not exist: ", className)
	# 	return null
	
		
static func fillPropertiesFromDictionary(obj, _dict: Dictionary):
	for key in _dict.keys():
#		if obj.has(key):
		obj.set(key, _dict[key])


static func isNullOrEmpty(val:String):
	return val == null || val == ""
	
	
static func find(array: Array, condition: Callable) -> Variant:
	for element in array:
		if condition.call(element):
			return element
	return null

static var textPosY = 0
static func writeToScreen(el, text:String):
	prints('writing to screen:', text)
	var label = Label.new() 
	label.text = text 
	el.add_child(label)  
	label.position = Vector2(0, textPosY) 
	textPosY += 20
