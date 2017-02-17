X = {}

local ABILITY1 = 1; 
local ABILITY2 = 2; 
local ABILITY3 = 3;
local ABILITY4 = 4;
local ABILITY5 = 5;
local ABILITY6 = 6;
local ABILITY7 = 7;
local ABILITY8 = 8;


local SKILL_Q = "antimage_mana_break";
local SKILL_W = "antimage_blink";
local SKILL_E = "antimage_spell_shield";
local SKILL_R = "antimage_mana_void";  


X["Carry_items"] = {
				"item_tango",
				"item_flask",
				"item_stout_shield",
				--
				"item_quelling_blade",
				--
				"item_ring_of_health",
				--
				"item_power_treads",
				--
				"item_void_stone",
				"item_claymore",
				"item_broadsword",
				--
				"item_manta",
				--
				"item_ultimate_scepter",
				--
				"item_abyssal_blade",
				--
				"item_butterfly",
				--
				"item_moon_shard",
				--
				"item_travel_boots"
}
X["Carry_skills"] = {
   SKILL_Q,		SKILL_W,	SKILL_E,	SKILL_Q,	SKILL_W,
   SKILL_R,		SKILL_W,	SKILL_W,	SKILL_Q,	ABILITY2,
   SKILL_Q,		SKILL_R,	SKILL_E,	SKILL_E,	ABILITY3,
   SKILL_E,		"-1",		SKILL_R,	"-1",		ABILITY6,
   "-1",		"-1",		"-1",		"-1",		ABILITY7,
}


return X