X = {}

local ABILITY1 = 1;
local ABILITY2 = 2;
local ABILITY3 = 3;
local ABILITY4 = 4;
local ABILITY5 = 5;
local ABILITY6 = 6;
local ABILITY7 = 7;
local ABILITY8 = 8;

local SKILL_Q = "queenofpain_shadow_strike";
local SKILL_W = "queenofpain_blink";
local SKILL_E = "queenofpain_scream_of_pain";
local SKILL_R = "queenofpain_sonic_wave";    

X["Solo_items"] = { 
                "item_tango",
               -- "item_flask",
				"item_circlet",
                "item_mantle",
                "item_recipe_null_talisman",
				"item_bottle",
				--"瓶子",
				"item_boots",
				"item_infused_raindrop",
				"item_gloves",
                "item_belt_of_strength",
				--假腿
				-- -- -- -- -- -- --
				"item_void_stone",
				"item_ring_of_health",
				"item_ultimate_orb",
				"item_recipe_sphere",
				--林肯
				---
				"item_energy_booster",
				"item_vitality_booster",
				"item_point_booster",
				"item_mystic_staff",
				--玲珑心
				"item_gloves",
				"item_mithril_hammer",
				"item_recipe_maelstrom",
				--小雷锤
				"item_platemail",
				"item_mystic_staff",
				"item_recipe_shivas_guard",
				--冰甲
				"item_hyperstone",
				"item_recipe_mjollnir",
				--大雷锤
				
				
				"item_boots",
				"item_recipe_travel_boots",
				--飞鞋
			};
--use -1 for levels that shouldn't level a skill
X["Solo_skills"] = {
    SKILL_Q,    SKILL_W,    SKILL_E,    SKILL_E,    SKILL_E,
    SKILL_R,    SKILL_E,    SKILL_W,    SKILL_W,    ABILITY1,--"",
    SKILL_W,    SKILL_R,    SKILL_Q,    SKILL_Q,    ABILITY3,--"",
    SKILL_Q,    "-1",       SKILL_R,    "-1",  		ABILITY6,--"",
    "-1",   	"-1",   	"-1",       "-1",       ABILITY8,--""
};

return X