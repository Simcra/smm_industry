---@diagnostic disable:undefined-global
local MOD_NAME = minetest.get_current_modname()
local MOD_PATH = minetest.get_modpath(MOD_NAME)

smm_industry = {}
dofile(MOD_PATH .. "/cable.lua")

-- Register cables
smm_industry.register_energy_cable("tin", "Tin", 0.09, 0.5, 1, 800, smm_compat.itemstring.tin_ingot)
smm_industry.register_energy_cable("copper", "Copper", 0.1, 0.5, 1, 1600, smm_compat.itemstring.copper_ingot)
smm_industry.register_energy_cable("iron", "Iron", 0.11, 0.5, 1, 2400, smm_compat.itemstring.iron_ingot)
smm_industry.register_energy_cable("gold", "Gold", 0.12, 0.5, 1, 3200, smm_compat.itemstring.gold_ingot)
