X = {};

local ABILITY1 = 1;
local ABILITY2 = 2;
local ABILITY3 = 3;
local ABILITY4 = 4;
local ABILITY5 = 5;
local ABILITY6 = 6;
local ABILITY7 = 7;
local ABILITY8 = 8;


local SKILL_Q = "keeper_of_the_light_illuminate";
local SKILL_W = "keeper_of_the_light_mana_leak";
local SKILL_E = "keeper_of_the_light_chakra_magic";
local SKILL_R = "keeper_of_the_light_spirit_form";    


X["HardSupport_items"] = {	
				"item_tango",
				"item_clarity",
				"item_clarity",
				"item_ring_of_protection",
				--出门
				"item_boots",
				"item_ring_of_regen",
				--绿鞋
				"item_ogre_axe",
				"item_blade_of_alacrity",
				"item_staff_of_wizardry",
				"item_point_booster",
				--A帐
				"item_ghost",
				--绿
				"item_cloak",
				"item_shadow_amulet",
				--微光
				"item_ultimate_orb",
				"item_mystic_staff",
				"item_void_stone",
				--羊刀
			}
X["HardSupport_skills"] = {
    SKILL_W,    SKILL_E,    SKILL_E,    SKILL_Q,    SKILL_E,
    SKILL_R,    SKILL_E,    SKILL_Q,    SKILL_Q,    ABILITY1,--"special_bonus_intelligence_8",
    SKILL_Q,    SKILL_R,    SKILL_W,    SKILL_W,    ABILITY3,--"special_bonus_attack_damage_40",
    SKILL_W,    "-1",       SKILL_R,    "-1",   	ABILITY5,--"special_bonus_spell_amplify_8",
    "-1",   	"-1",   	"-1",       "-1",       ABILITY7,--"special_bonus_gold_income_50"
};


X["Support_items"] = {
				"item_tango",
				"item_clarity",
				"item_clarity",
				"item_ring_of_protection",
				--出门
				"item_boots",
				"item_ring_of_regen",
				--绿鞋
				"item_ogre_axe",
				"item_blade_of_alacrity",
				"item_staff_of_wizardry",
				"item_point_booster",
				--A帐
				"item_ghost",
				--绿
				"item_cloak",
				"item_shadow_amulet",
				--微光
				"item_ultimate_orb",
				"item_mystic_staff",
				"item_void_stone",
				--羊刀

}
X["Support_skills"] = {
	SKILL_W,    SKILL_E,    SKILL_E,    SKILL_Q,    SKILL_E,
    SKILL_R,    SKILL_E,    SKILL_Q,    SKILL_Q,    ABILITY1,--"special_bonus_intelligence_8",
    SKILL_Q,    SKILL_R,    SKILL_W,    SKILL_W,    ABILITY3,--"special_bonus_attack_damage_40",
    SKILL_W,    "-1",       SKILL_R,    "-1",   	ABILITY5,--"special_bonus_spell_amplify_8",
    "-1",   	"-1",   	"-1",       "-1",       ABILITY7,--
}

return X