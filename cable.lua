---@diagnostic disable:undefined-global
local MOD_NAME = minetest.get_current_modname()

local function get_cable_name(name) return name .. "_cable" end
local function get_cable_description(display_name) return display_name .. " Cable" end
local function get_cable_connects_to(name) return { minetest.get_current_modname() .. ":" .. name .. "_cable" } end
local function get_cable_groups(hardness)
    if smm_compat.mtg_available then
        return { cracky = hardness * 2, level = 1, oddly_breakable_by_hand = 1 }
    elseif smm_compat.mcl_available then
        return { handy = 1, pickaxey = 1 }
    end
end
local function get_energy_cable_name(name) return get_cable_name(name .. "_energy") end
local function get_energy_cable_description(display_name) return get_cable_description(display_name .. " Energy") end
local function get_energy_cable_connects_to(name) return get_cable_connects_to(name .. "_energy") end
local function get_wire_name(name) return name .. "_wire" end
local function get_wire_description(display_name) return display_name .. " Wire" end
local function on_energy_cable_construct(position)
    smm_util.get_connectable_nodes(position)
end
local function on_energy_cable_destruct(position)
    smm_util.get_connectable_nodes(position)
end

function smm_industry.register_wire_craftitem(name, display_name)
    local mod_name = minetest.get_current_modname()
    local translator = minetest.get_translator(mod_name)
    local craftitem_name = get_wire_name(name)
    local craftitem_description = get_wire_description(display_name)

    minetest.register_craftitem(mod_name .. ":" .. craftitem_name, {
        description = translator(craftitem_description),
        inventory_image = mod_name .. "_" .. smm_compat.texture_prefix .. "_" .. craftitem_name .. ".png"
    })
end

function smm_industry.register_wire_shaped_craft(name, ingot_itemstring)
    local mod_name = minetest.get_current_modname()
    local wire_itemstring = mod_name .. ":" .. get_wire_name(name)

    minetest.register_craft({
        type = "shaped",
        output = wire_itemstring .. " 8",
        recipe = {
            { "",               "",               "" },
            { ingot_itemstring, ingot_itemstring, ingot_itemstring },
            { "",               "",               "" },
        }
    })
end

function smm_industry.register_energy_cable_node(name, display_name, nodebox_size, hardness, blast_resistance,
                                                 energy_flow)
    local mod_name = minetest.get_current_modname()
    local translator = minetest.get_translator(mod_name)
    local node_name = get_energy_cable_name(name)
    local node_description = get_energy_cable_description(display_name)

    local definition = {
        description = translator(node_description),
        inventory_image = mod_name .. "_" .. node_name .. "_inv.png",
        wield_image = mod_name .. "_" .. node_name .. "_inv.png",
        tiles = { mod_name .. "_" .. node_name .. ".png" },
        sunlight_propagates = true,
        paramtype = "light",
        drawtype = "nodebox",
        node_box = {
            type = "connected",
            fixed = { -nodebox_size, -nodebox_size, -nodebox_size, nodebox_size, nodebox_size, nodebox_size },
            connect_left = { -0.5, -nodebox_size, -nodebox_size, nodebox_size, nodebox_size, nodebox_size },
            connect_bottom = { -nodebox_size, -0.5, -nodebox_size, nodebox_size, nodebox_size, nodebox_size },
            connect_front = { -nodebox_size, -nodebox_size, -0.5, nodebox_size, nodebox_size, nodebox_size },
            connect_right = { -nodebox_size, -nodebox_size, -nodebox_size, 0.5, nodebox_size, nodebox_size },
            connect_top = { -nodebox_size, -nodebox_size, -nodebox_size, nodebox_size, 0.5, nodebox_size },
            connect_back = { -nodebox_size, -nodebox_size, -nodebox_size, nodebox_size, nodebox_size, 0.5 },
        },
        connects_to = get_energy_cable_connects_to(name),
        on_construct = on_energy_cable_construct,
        on_destruct = on_energy_cable_destruct,
        groups = get_cable_groups(hardness * 2),
        sounds = smm_compat.sound.node_sound_metal_defaults(),
        _smm_energy_flow = energy_flow
    }
    definition.groups.smm_industry_energy_cable = 1
    table.insert(definition.connects_to, "group:" .. MOD_NAME .. "_energy_producer")
    table.insert(definition.connects_to, "group:" .. MOD_NAME .. "_energy_consumer")
    table.insert(definition.connects_to, "group:" .. MOD_NAME .. "_energy_storage")
    if smm_compat.mcl_available then
        definition._mcl_hardness = hardness
        definition._mcl_blast_resistance = blast_resistance
    end

    minetest.register_node(mod_name .. ":" .. node_name, definition)
end

function smm_industry.register_energy_cable_shaped_craft(name, wire_itemstring)
    local mod_name = minetest.get_current_modname()
    local energy_cable_itemstring = mod_name .. ":" .. get_energy_cable_name(name)

    minetest.register_craft({
        type = "shaped",
        output = energy_cable_itemstring .. " 8",
        recipe = {
            { wire_itemstring, wire_itemstring,                  wire_itemstring },
            { wire_itemstring, smm_compat.itemstring.group_wool, wire_itemstring },
            { wire_itemstring, wire_itemstring,                  wire_itemstring },
        }
    })
end

function smm_industry.register_energy_cable(
    name,
    display_name,
    nodebox_size,
    hardness,
    blast_resistance,
    energy_flow,
    ingot_itemstring
)
    smm_industry.register_wire_craftitem(name, display_name)
    smm_industry.register_wire_shaped_craft(name, ingot_itemstring)
    smm_industry.register_energy_cable_node(name, display_name, nodebox_size, hardness, blast_resistance, energy_flow)
    smm_industry.register_energy_cable_shaped_craft(name, minetest.get_current_modname() .. ":" .. get_wire_name(name))
end
