X = {};



local ABILITY1 = 1;
local ABILITY2 = 2;
local ABILITY3 = 3;
local ABILITY4 = 4;
local ABILITY5 = 5;
local ABILITY6 = 6;
local ABILITY7 = 7;
local ABILITY8 = 8;

local SKILL_Q = "weaver_the_swarm";
local SKILL_W = "weaver_shukuchi";
local SKILL_E = "weaver_geminate_attack";
local SKILL_R = "weaver_time_lapse";    


X["Support_items"] = {
				"item_tango",
				"item_clarity",
				"item_clarity",
				"item_blight_stone",
-------------------------------				
				"item_sobi_mask",
				"item_chainmail",
				---- courage
				"item_magic_stick",
				---
				"item_infused_raindrop",
--------------------------
				"item_sobi_mask",
				"item_gauntlets",
				"item_gauntlets",
				"item_recipe_urn_of_shadows",
				----
				"item_ogre_axe",
				"item_blade_of_alacrity",
				"item_staff_of_wizardry",
				"item_point_booster",
				-------------A帐
				"item_talisman_of_evasion",
				-----
				"item_void_stone",
				"item_ring_of_health",
				"item_energy_booster",
				"item_platemail",
				-----
				"item_ultimate_orb",
				"item_ring_of_health",
				"item_void_stone",
				"item_recipe_sphere",
				-----
				"item_blade_of_alacrity",
				"item_blade_of_alacrity",
				"item_robe",
				"item_recipe_diffusal_blade",
				
			}
X["Support_skills"] = {
    SKILL_W,    SKILL_Q,    SKILL_E,    SKILL_W,    SKILL_W,
    SKILL_R,    SKILL_W,    SKILL_Q,    SKILL_Q,    ABILITY1,
    SKILL_Q,    SKILL_R,    SKILL_E,    SKILL_E,    ABILITY4,
    SKILL_E,    "-1",       SKILL_R,    "-1",   	ABILITY5,
    "-1",   	"-1",   	"-1",       "-1",       ABILITY7,
};
X["Carry_items"] = {
				"item_tango",
				"item_flask",
				--
				"item_ring_of_aquila",
				--
				"item_blight_stone",
				--
				"item_sphere",
				--
				"item_dragon_lance",
				--
				"item_mithril_hammer",
				"item_mithril_hammer",
				--
				"item_ultimate_scepter",
				--
				"item_black_king_bar",
}
X["Carry_skills"] = {
    SKILL_W,    SKILL_Q,    SKILL_W,    SKILL_E,    SKILL_W,
    SKILL_R,    SKILL_W,    SKILL_E,    SKILL_E,    ABILITY2,
    SKILL_E,    SKILL_R,    SKILL_Q,    SKILL_Q,    ABILITY3,
    SKILL_Q,    "-1",       SKILL_R,    "-1",   	ABILITY6,
    "-1",   	"-1",   	"-1",       "-1",       ABILITY8,
};

return X