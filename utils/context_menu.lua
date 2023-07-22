local context_menu_modul = {}

context_menu_modul.check_context = function(to_check)
    if to_check == nil then
        return {
            ["prefix"] = ""
        }
    else
        return to_check
    end
end;

-- Context Menu Helpers
context_menu_modul.add_context_toggle = function(label, var_name)
    local toggle = function()
        self.setVar(var_name, not self.getVar(var_name))
        context_menu_modul.rebuild_context_menu()
    end

    if self.getVar(var_name) then
        self.addContextMenuItem("[X] "..label, toggle, false)
    else
        self.addContextMenuItem("[  ] "..label, toggle, false)
    end
end;

context_menu_modul.add_context_dividing_line = function()
    local noop = function() end

    self.addContextMenuItem("-------", noop, true)
end;

context_menu_modul.add_context_selection = function(label, selection, var_name)
    local gen_set_func = function(x)
        return function()
            self.setVar(var_name, x)
            context_menu_modul.rebuild_context_menu()
        end
    end

    local noop = function() end

    self.addContextMenuItem(label, noop, true)
    for _, v in pairs(selection) do
        if self.getVar(var_name) == v then 
            self.addContextMenuItem("|  [X] "..v, noop, true)
        else
            self.addContextMenuItem("|  [  ] "..v, gen_set_func(v), false)
        end
    end

end;

context_menu_modul.owner = "";
context_menu_modul.owner_first_click = false;
context_menu_modul.add_context_ower = function()
    if owner == "" then
        local callback = function(player)
            owner = player
            context_menu_modul.rebuild_context_menu()
        end
        self.addContextMenuItem("Register Owner", callback, false)
    else
        if owner_first_click then
            local callback = function()
                owner = ""
                context_menu_modul.rebuild_context_menu()
            end
            self.addContextMenuItem("Click again to clear", callback, false) 
        else
            local callback = function()
                owner_first_click = true
                context_menu_modul.rebuild_context_menu()
                owner_first_click = false
            end
            self.addContextMenuItem("Owner: "..owner, callback, false)
        end
    end
end;

context_menu_modul.context_folder_states = {};
context_menu_modul.add_context_folder = function(folder_name, folder_setup, context_in)
    local context = context_menu_modul.check_context(context_in)


    if not context_menu_modul.context_folder_states[folder_name] then
        context_menu_modul.context_folder_states[folder_name] = false
    end

    if context_menu_modul.context_folder_states[folder_name] then
        folder_setup()
    end

end;

context_menu_modul.rebuild_context_menu = function()
    self.clearContextMenu()
    setup_context_menu()
end

context_menu_modul.setup_context_menu = function () end;
context_menu_modul.init_context_menu = function (setup_method)
    setup_context_menu = setup_method
    context_menu_modul.rebuild_context_menu()
end;


return context_menu_modul

