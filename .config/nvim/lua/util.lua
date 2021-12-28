

--- @diagnostic disable-next-line: undefined-global
local api = vim.api

local function t(str)
    return api.nvim_replace_termcodes(str, true, true, true)
end

local function keymap(mode, trigger, action, extra_args)
    if not extra_args then
        extra_args = {}
    end
    local trigger_coded = api.nvim_replace_termcodes(trigger, true, true, true)
    local action_coded  = api.nvim_replace_termcodes(action, true, true, true)
    api.nvim_set_keymap(mode, trigger_coded, action_coded, extra_args)
end

-- From http://lua-users.org/wiki/CopyTable
local function deepcopy(orig, copies)
    copies = copies or {}
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        if copies[orig] then
            copy = copies[orig]
        else
            copy = {}
            copies[orig] = copy
            for orig_key, orig_value in next, orig, nil do
                copy[deepcopy(orig_key, copies)] = deepcopy(orig_value, copies)
            end
            setmetatable(copy, deepcopy(getmetatable(orig), copies))
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end


local M = {
    t = t,
    keymap = keymap,
    table = {
        deepcopy = deepcopy,
    },
}

return M
