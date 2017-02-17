X = {};

local ABILITY1 = 1;
local ABILITY2 = 2;
local ABILITY3 = 3;
local ABILITY4 = 4;
local ABILITY5 = 5;
local ABILITY6 = 6;
local ABILITY7 = 7;
local ABILITY8 = 8;


local SKILL_Q = "lycan_summon_wolves";
local SKILL_W = "lycan_howl";
local SKILL_E = "lycan_feral_impulse";
local SKILL_R = "lycan_shapeshift";    


X["Carry_items"] = {
				"item_tango",
				--"item_flask",
				"item_slippers",
				"item_slippers",
				"item_stout_shield",
				"item_quelling_blade",
				"item_boots",
				"item_blight_stone",
				--"item_belt_of_strength" ,
				--"item_gloves", 
-------------------------------				
				"item_helm_of_iron_will",
				"item_blades_of_attack",
				"item_gloves",
				"item_recipe_armlet",
--------------------------armlet
				"item_mithril_hammer",
				"item_mithril_hammer",
				------------------
				"item_ogre_axe",
				"item_quarterstaff",
				"item_sobi_mask",
				"item_robe",
				-----------------------
				"item_ogre_axe",
				"item_mithril_hammer",
				"item_recipe_black_king_bar",
				-----------------------
				"item_hyperstone",
				"item_platemail",
				"item_chainmail",
				"item_recipe_assault"
			}
--use -1 for levels that shouldn't level a skill
X["Carry_skills"] = {
    SKILL_E,    SKILL_W,    SKILL_E,    SKILL_W,    SKILL_E,
    SKILL_R,    SKILL_E,    SKILL_W,    SKILL_W,    ABILITY1,--"special_bonus_intelligence_8",
    SKILL_Q,    SKILL_R,    SKILL_Q,    SKILL_Q,    ABILITY4,--"special_bonus_attack_damage_40",
    SKILL_Q,    "-1",       SKILL_R,    "-1",   	ABILITY6,--"special_bonus_spell_amplify_8",
    "-1",   	"-1",   	"-1",       "-1",       ABILITY8,--"special_bonus_gold_income_50"
};

X["Solo_items"] = {
				"item_poor_mans_shield",
				"item_tango",
				---
				"item_bottle",
				--
				"item_vladmir",
				--
				"item_helm_of_the_dominator",
				--
				"item_necronomicon_3L",
				--
				"item_assault",
				
}
X["Solo_skills"] = {
	SKILL_E,    SKILL_Q,    SKILL_E,    SKILL_Q,    SKILL_Q,
    SKILL_R,    SKILL_Q,    SKILL_W,    SKILL_W,    ABILITY1,--"special_bonus_intelligence_8",
    SKILL_W,    SKILL_R,    SKILL_W,    SKILL_E,    ABILITY4,--"special_bonus_attack_damage_40",
    SKILL_E,    "-1",       SKILL_R,    "-1",   	ABILITY6,--"special_bonus_spell_amplify_8",
    "-1",   	"-1",   	"-1",       "-1",       ABILITY8,--"special_bonus_gold_income_50"
}


return X