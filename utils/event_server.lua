events = {}

function new_event(event_name)
	if events[event_name] == nil then
		events[event_name] = {}
	end
end

function register_to_event(input)
	local event_name = input["event_name"]
	local guid = input["guid"]
	local callback = input["callback"]

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

