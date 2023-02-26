function getHoveredObjbyColor(player)
    for _,v in pairs(Player.getPlayers()) do
        if v.color == player then
            if v.getHoverObject() ~= nil then
                return v.getHoverObject()
            else
                return false
            end
        end
    end
end

rot = 90

function onScriptingButtonDown(index, player)
    obj = getHoveredObjbyColor(player)

    if index == 4 then
        obj.alt_view_angle = obj.alt_view_angle + Vector(0, rot, 0)
        print(obj.alt_view_angle)
    elseif index == 6 then 
        obj.alt_view_angle = obj.alt_view_angle + Vector(0, -rot, 0)
        print(obj.alt_view_angle)
    elseif index == 8 then 
        obj.alt_view_angle = obj.alt_view_angle + Vector(0, 0, -rot)
        print(obj.alt_view_angle)
    elseif index == 2 then 
        obj.alt_view_angle = obj.alt_view_angle + Vector(0, 0, rot)
        print(obj.alt_view_angle)
    elseif index == 5 then
        obj.alt_view_angle = Vector(0, 0, 0)
    elseif index == 3 then
        obj.alt_view_angle = obj.alt_view_angle + Vector(rot, 0, 0)
        print(obj.alt_view_angle)
    elseif index == 1 then
        obj.alt_view_angle = obj.alt_view_angle + Vector(-rot, 0, 0)
        print(obj.alt_view_angle)
    elseif index == 7 then
        rot = rot - 15
        if rot < 15 then 
            rot = 15
        end
        print(rot)
    elseif index == 9 then
        rot = rot + 15
        if rot > 90 then
            rot = 90
        end
        print(rot)
    end
end

