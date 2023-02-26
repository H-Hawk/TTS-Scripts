global_store = {}

function get_global_value(key)
	return global_store[key]
end

function set_global_value(input)
	local key = input["key"]
	local value = input["value"]
	
	global_store[key] = value
end