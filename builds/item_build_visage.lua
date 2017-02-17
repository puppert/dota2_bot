X = {};


local ABILITY1 = 1;
local ABILITY2 = 2;
local ABILITY3 = 3;
local ABILITY4 = 4;
local ABILITY5 = 5;
local ABILITY6 = 6;
local ABILITY7 = 7;
local ABILITY8 = 8;


local SKILL_Q = "visage_grave_chill";
local SKILL_W = "visage_soul_assumption";
local SKILL_E = "visage_gravekeepers_cloak";
local SKILL_R = "visage_summon_familiars";    


X["Support_items"] = { 
                "item_clarity",
                "item_tango",
				"item_branches",
				"item_branches",
				----
                "item_boots",
				"item_energy_booster",
				----
                "item_ring_of_regen",
                "item_recipe_headdress",
				"item_chainmail",
				"item_recipe_buckler",
				"item_recipe_mekansm",
				---
                "item_cloak" ,
				"item_ring_of_health",
				"item_ring_of_regen",
				--
				"item_chainmail",
				"item_blight_stone",
				"item_sobi_mask",
				"item_talisman_of_evasion",
				--
				"item_point_booster" ,
				"item_ogre_axe",
				"item_blade_of_alacrity",
				"item_staff_of_wizardry",
				---
				"item_recipe_guardian_greaves",
				
			};
X["Support_skills"] = {
    SKILL_Q,    SKILL_W,    SKILL_W,    SKILL_E,    SKILL_W,
    SKILL_R,    SKILL_W,    SKILL_E,    SKILL_E,    ABILITY1,--"special_bonus_intelligence_8",
    SKILL_E,    SKILL_R,    SKILL_Q,    SKILL_Q,    ABILITY4,--"special_bonus_attack_damage_40",
    SKILL_Q,    "-1",       SKILL_R,    "-1",  		ABILITY6,--"special_bonus_spell_amplify_8",
    "-1",   	"-1",  	 	"-1",       "-1",       ABILITY8,--"special_bonus_gold_income_50"
};




return X