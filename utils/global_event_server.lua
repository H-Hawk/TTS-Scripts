events = {}

function new_event(event_name)
	if events[event_name] == nil then
		events[event_name] = {}
	end
end

function register_to_event(event_name, guid, callback)
	if events[event_name] ~= nil then
		table.insert(events[event_name], {
			["guid"] = guid,
			["callback"] = callback
		})
	end
end

function trigger_event(event_name)
	for _, v in pairs(events[event_name]) do
		getObjectFromGUID(v["guid"]).call(v["callback"])
	end
end


global_store = {}

function get_global_value(key)
	return global_store[key]
end

function set_global_value(key, value)
	global_store[key] = value
end