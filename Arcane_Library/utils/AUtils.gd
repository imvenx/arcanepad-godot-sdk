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
		var name = property.name
		# Skip unwanted or built-in properties.
		if name in ["RefCounted", "script"] or not property.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
			continue
		
		var value = obj.get(name)
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

		result[name] = value
	return result
