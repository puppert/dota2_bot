X = {};


local ABILITY1 = 1;
local ABILITY2 = 2;
local ABILITY3 = 3;
local ABILITY4 = 4;
local ABILITY5 = 5;
local ABILITY6 = 6;
local ABILITY7 = 7;
local ABILITY8 = 8;

local SKILL_Q = "earth_spirit_boulder_smash";
local SKILL_W = "earth_spirit_rolling_boulder";
local SKILL_E = "earth_spirit_geomagnetic_grip";
local SKILL_D = "earth_spirit_stone_caller";
local SKILL_R = "earth_spirit_magnetize";    



local ABILITY8 = "special_bonus_unique_earth_spirit"
X["Support_items"] = {
				"item_orb_of_venom",
				"item_clarity",
				"item_clarity",
				--出门
				"item_boots",
				"item_energy_booster",
				--秘法
				"item_gauntlets" ,
				"item_gauntlets", 
				"item_sobi_mask",
				"item_recipe_urn_of_shadows",
				--骨灰
				"item_cloak",
				"item_shadow_amulet_fade",
-----------------微光
				"item_blink",
				----------跳刀
				"item_ogre_axe",
				"item_blade_of_alacrity",
				"item_staff_of_wizardry",
				"item_point_booster",
				-------------A帐
				"item_ogre_axe",
				"item_mithril_hammer",
				"item_recipe_black_king_bar",
				------------BKB
			}

--use -1 for levels that shouldn't level a skill
X["Support_skills"] = {
    SKILL_W,    SKILL_Q,    SKILL_E,    SKILL_Q,    SKILL_Q,
    SKILL_R,    SKILL_Q,    SKILL_E,    SKILL_E,    "-1",--"special_bonus_intelligence_8",
    SKILL_E,    SKILL_R,    SKILL_W,    SKILL_W,    "-1",--"special_bonus_attack_damage_40",
    SKILL_W,    "-1",       SKILL_R,    ABILITY1,   ABILITY3,--"special_bonus_spell_amplify_8",
    ABILITY5,   ABILITY7,   "-1",       "-1",       "-1",--"special_bonus_gold_income_50"
};

return X