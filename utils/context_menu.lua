function check_context(to_check)
    if to_check == nil then
        return {
            ["prefix"] = ""
        }
    else
        return to_check
    end
end

-- Context Menu Helpers
function add_context_toggle(label, var_name)
    local toggle = function()
        self.setVar(var_name, not self.getVar(var_name))
        rebuild_context_menu()
    end

    if self.getVar(var_name) then
        self.addContextMenuItem("[X] "..label, toggle, false)
    else
        self.addContextMenuItem("[  ] "..label, toggle, false)
    end
end

function add_context_dividing_line()
    local noop = function() end

    self.addContextMenuItem("-------", noop, true)
end

function add_context_selection(label, selection, var_name)
    local gen_set_func = function(x)
        return function()
            self.setVar(var_name, x)
            rebuild_context_menu()
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

end

owner = ""
owner_first_click = false
function add_context_ower()
    if owner == "" then
        local callback = function(player)
            owner = player
            rebuild_context_menu()
        end
        self.addContextMenuItem("Register Owner", callback, false)
    else
        if owner_first_click then
            local callback = function()
                owner = ""
                rebuild_context_menu()
            end
            self.addContextMenuItem("Click again to clear", callback, false) 
        else
            local callback = function()
                owner_first_click = true
                rebuild_context_menu()
                owner_first_click = false
            end
            self.addContextMenuItem("Owner: "..owner, callback, false)
        end
    end
end

context_folder_states = {}
function add_context_folder(folder_name, folder_setup, context_in)
    local context = check_context(context_in)


    if not context_folder_states[folder_name] then
        context_folder_states[folder_name] = false
    end

    if context_folder_states[folder_name] then
        folder_setup()
    end

end

function rebuild_context_menu()
    self.clearContextMenu()
    setup_context_menu()
end

setup_context_menu = function () end
function init_context_menu(setup_method)
    setup_context_menu = setup_method
    rebuild_context_menu()
end

