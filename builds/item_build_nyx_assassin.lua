X = {};

local ABILITY1 = 1;
local ABILITY2 = 2;
local ABILITY3 = 3;
local ABILITY4 = 4;
local ABILITY5 = 5;
local ABILITY6 = 6;
local ABILITY7 = 7;
local ABILITY8 = 8;

local SKILL_Q = "nyx_assassin_impale";
local SKILL_W = "nyx_assassin_mana_burn";
local SKILL_E = "nyx_assassin_spiked_carapace";
local SKILL_R = "nyx_assassin_vendetta";    

X["Offline_items"] = { 
                "item_stout_shield",
                "item_slippers",
				"item_slippers",
				----
                "item_tango",
                "item_boots",
				"item_energy_booster",
				---
                "item_gloves",
                "item_recipe_hand_of_midas",
				---
                "item_blink" ,
				---
				"item_point_booster" ,
				"item_ogre_axe",
				"item_blade_of_alacrity",
				"item_staff_of_wizardry",
				---
				"item_energy_booster",
				"item_ring_of_health",
				"item_recipe_aether_lens",
				--
				"item_ethereal_blade",
			};
X["Offline_skills"] = {
    SKILL_Q,    SKILL_E,    SKILL_W,    SKILL_Q,    SKILL_Q,
    SKILL_R,    SKILL_Q,    SKILL_W,    SKILL_W,    ABILITY2,--"special_bonus_intelligence_8",
    SKILL_W,    SKILL_R,    SKILL_E,    SKILL_E,    ABILITY4,--"special_bonus_attack_damage_40",
    SKILL_E,    "-1",       SKILL_R,    "-1",  		ABILITY5,--"special_bonus_spell_amplify_8",
    "-1",   	"-1",  	 	"-1",       "-1",       ABILITY8,--"special_bonus_gold_income_50"
};


X["Support_items"] = { 
                "item_tango",
				"item_clarity",
				"item_clarity",
				--
                "item_boots",
				"item_energy_booster",
				---
                "item_gloves",
                "item_recipe_hand_of_midas",
				---
                "item_blink" ,
				---
				"item_point_booster" ,
				"item_ogre_axe",
				"item_blade_of_alacrity",
				"item_staff_of_wizardry",
				---
				"item_energy_booster",
				"item_ring_of_health",
				"item_recipe_aether_lens",
				--
				"item_ethereal_blade",
			};
X["Support_skills"] = {
    SKILL_Q,    SKILL_E,    SKILL_W,    SKILL_Q,    SKILL_Q,
    SKILL_R,    SKILL_Q,    SKILL_W,    SKILL_W,    ABILITY2,--"special_bonus_intelligence_8",
    SKILL_W,    SKILL_R,    SKILL_E,    SKILL_E,    ABILITY4,--"special_bonus_attack_damage_40",
    SKILL_E,    "-1",       SKILL_R,    "-1",  		ABILITY5,--"special_bonus_spell_amplify_8",
    "-1",   	"-1",  	 	"-1",       "-1",       ABILITY8,--"special_bonus_gold_income_50"
};


return X