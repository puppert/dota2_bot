X = {}

local ABILITY1 = 1; 
local ABILITY2 = 2; 
local ABILITY3 = 3;
local ABILITY4 = 4;
local ABILITY5 = 5;
local ABILITY6 = 6;
local ABILITY7 = 7;
local ABILITY8 = 8;


local SKILL_Q = "abaddon_death_coil";
local SKILL_W = "abaddon_aphotic_shield";
local SKILL_E = "abaddon_frostmourne";
local SKILL_R = "abaddon_borrowed_time";    


X["Support_items"] = { 
            "item_wind_lace",  
			"item_clarity",
			"item_clarity",
			"item_tango",
			"item_branches",
			"item_branches" ,
			----
			"item_boots",
			"item_energy_booster",
			--
			"item_gauntlets",
			"item_circlet",
			"item_recipe_bracer",
			"item_sobi_mask",
			"item_recipe_ancient_janggo",
			---
			"item_ring_of_regen",
			"item_recipe_headdress",
			"item_chainmail",
			"item_recipe_buckler",
			"item_recipe_mekansm",
			--
			"item_recipe_guardian_greaves",
			--
			"item_chainmail",
			"item_broadsword",
			"item_robe",
			-- -- -- -- -- -- -- ----
			"item_ogre_axe",
			"item_blade_of_alacrity",
			"item_staff_of_wizardry",
			"item_point_booster",
			---
			"item_energy_booster",
			"item_vitality_booster",
			"item_point_booster",
			"item_mystic_staff",
			};
X["Support_skills"] = {
   SKILL_W,		SKILL_Q,	SKILL_W,	SKILL_Q,	SKILL_W,
   SKILL_R,		SKILL_W,	SKILL_Q,	SKILL_Q,	ABILITY2,
   SKILL_E,		SKILL_R,	SKILL_E,	SKILL_E,	ABILITY3,
   SKILL_E,		"-1",		SKILL_R,	"-1",		ABILITY6,
   "-1",		"-1",		"-1",		"-1",		ABILITY8,
};

X["HardSupport_items"] = {
	"item_wind_lace",  
	"item_clarity",
	"item_clarity",
	"item_tango",
	--
	"item_arcane_boots",
	--
	"item_bracer",
	"item_sobi_mask",
	"item_recipe_ancient_janggo",
	--
	"item_mekansm",
    "item_recipe_guardian_greaves",
	--
	"item_rod_of_atos",
	--
	"item_ultimate_scepter"
	--
	"item_octarine_core"
}
X["HardSupport_skills"] = {
   SKILL_W,		SKILL_Q,	SKILL_W,	SKILL_Q,	SKILL_W,
   SKILL_R,		SKILL_W,	SKILL_Q,	SKILL_Q,	ABILITY2,
   SKILL_E,		SKILL_R,	SKILL_E,	SKILL_E,	ABILITY3,
   SKILL_E,		"-1",		SKILL_R,	"-1",		ABILITY6,
   "-1",		"-1",		"-1",		"-1",		ABILITY8,
}

X["Offline_items"] = {
	"item_stout_shield",
	"item_tango",
	"item_tango",
	"item_flask",
	--
	"item_phase_boots",
	--
	"item_ancient_janggo",
	--
	"item_vladmir",
	--
	"item_blade_mail",
	--
	"item_ultimate_scepter",
	--
	"item_octarine_core"
}
X["Offline_skills"] = {
   SKILL_E,		SKILL_W,	SKILL_E,	SKILL_W,	SKILL_W,
   SKILL_R,		SKILL_W,	SKILL_Q,	SKILL_Q,	ABILITY2,
   SKILL_Q,		SKILL_R,	SKILL_Q,	SKILL_E,	ABILITY4,
   SKILL_E,		"-1",		SKILL_R,	"-1",		ABILITY6,
   "-1",		"-1",		"-1",		"-1",		ABILITY8,
}


return X