local X = {};

function X:CheckIsCombineItem(ItemName)
	for k,v in pairs(self.TableCombine) do 
		if k == ItemName then
			return true
		end
	end
	return false;
end


function X:GetTheItemToBuy(ItemName)
	if self:CheckIsCombineItem(ItemName) then
		for k,v in ipairs(self.TableCombine[ItemName]) do
			self:GetTheItemToBuy(v)
		end
	else
	--translate table ,true table is GetBot().ItemTable
		table.insert(GetBot().ItemTable,ItemName)
	end
end

-- Use this function
function X:GetItemTable(ItemTable) 
	GetBot().ItemTable = {};
	
	for k,v in ipairs(ItemTable) do
		self:GetTheItemToBuy(v);
	end
end


X.TableCombine = {
		["item_moon_shard"] = {	--银月
			"item_hyperstone",
			"item_hyperstone"
		}
		,["item_abyssal_blade"] = {	--	深渊
			"item_basher",
			"item_vanguard",
			"item_recipe_abyssal_blade"
			}
		,["item_heavens_halberd"] = {	--天堂
			"item_sange",
			"item_talisman_of_evasion"
		}
		,["item_travel_boots"] = {	--飞鞋
			"item_boots",
			"item_recipe_travel_boots"
		}
		,["item_urn_of_shadows"] = {	--	骨灰
			"item_gauntlets",
			"item_gauntlets",
			"item_sobi_mask",
			"item_recipe_urn_of_shadows"
		}
		,["item_solar_crest"] = {	--炎阳
			"item_medallion_of_courage",
			"item_talisman_of_evasion"
		}
		,["item_medallion_of_courage"] = {	--勋章
			"item_blight_stone",
			"item_sobi_mask",
			"item_chainmail"
		}
		,["item_pipe"] = {	--烟斗
			"item_hood_of_defiance",
			"item_headdress",
			"item_recipe_pipe"
		}
		,["item_cyclone"] = {	--风杖
			"item_wind_lace",
			"item_void_stone",
			"item_staff_of_wizardry",
			"item_recipe_cyclone"
		}
		,["item_dagon"] = {	--红帐
			"item_null_talisman",
			"item_staff_of_wizardry",
			"item_recipe_dagon"
		}
		,["item_veil_of_discord"] = {	--纷争
			"item_null_talisman",
			"item_null_talisman",
			"item_helm_of_iron_will",
			"item_recipe_veil_of_discord"
		}
		,["item_refresher"] = {	--刷新球
			"item_pers",
			"item_pers",
			"item_recipe_refresher"
		}
		,["item_bloodstone"] = {	--血精
			"item_soul_ring",
			"item_soul_booster",
			"item_recipe_bloodstone"
		}
		,["item_soul_ring"] = {	--魂戒
			"item_sobi_mask",
			"item_ring_of_regen",
			"item_recipe_soul_ring"
		}
		,["item_heart"] = {	--龙芯
			"item_vitality_booster",
			"item_reaver",
			"item_recipe_heart"
		}
		,["item_basher"] = {	--晕锤
			"item_javelin",
			"item_belt_of_strength",
			"item_recipe_basher"
		}
		,["item_silver_edge"] = {	--大隐刀
			"item_invis_sword",
			"item_ultimate_orb",
			"item_recipe_silver_edge"
		}
		,["item_invis_sword"] = {	--	影刀
			"item_shadow_amulet_fade",
			"item_claymore"
		}
		,["item_bfury"] = {	--狂战
			"item_quelling_blade",
			"item_pers",
			"item_claymore",
			"item_broadsword"
		}
		,["item_radiance"] = {	--辉耀
			"item_relic",
			"item_recipe_radiance"
		}
		,["item_monkey_king_bar"] = {	--金箍棒
			"item_demon_edge",
			"item_javelin",
			"item_javelin"
		}
		,["item_greater_crit"] = {	--大炮
			"item_lesser_crit",
			"item_demon_edge",
			"item_recipe_greater_crit"
		}
		,["item_bloodthorn"] = {	--血棘
			"item_orchid",
			"item_lesser_crit",
			"item_recipe_bloodthorn"
		}
		,["item_lesser_crit"] = {	--水晶剑
			"item_broadsword",
			"item_blades_of_attack",
			"item_recipe_lesser_crit"
		}
		,["item_butterfly"] = {	--蝴蝶
			"item_eagle",
			"item_talisman_of_evasion",
			"item_quarterstaff"
		}
		,["item_rapier"] = {	--圣剑
			"item_relic",
			"item_demon_edge"
		}
		,["item_mask_of_madness"] = {	--疯脸
			"item_lifesteal",
			"item_recipe_mask_of_madness"
		}
		,["item_lotus_orb"] = {	--	莲花
			"item_pers",
			"item_platemail",
			"item_energy_booster"
		}
		,["item_diffusal_blade"] = {	--散失
			"item_blade_of_alacrity",
			"item_blade_of_alacrity",
			"item_robe",
			"item_recipe_diffusal_blade"
		}
		,["item_mjollnir"] = {	--大电锤
			"item_maelstrom",
			"item_hyperstone",
			"item_recipe_mjollnir"
		}
		,["item_maelstrom"] = {	--小雷锤
			"item_gloves",
			"item_mithril_hammer",
			"item_recipe_cloak"
		}
		,["item_glimmer_cape"] = {	--微光
			"item_shadow_amulet_fade",
			"item_cloak"
		}
		,["item_skadi"] = {	--冰眼
			"item_orb_of_venom",
			"item_ultimate_orb",
			"item_ultimate_orb",
			"item_point_booster"
		}
		,["item_satanic"] = { -- 撒旦
			"item_lifesteal",
			"item_mithril_hammer",
			"item_reaver"
		}
		,["item_hand_of_midas"] = { -- 点金
			"item_gloves",
			"item_recipe_hand_of_midas"
		}
		,["item_manta"] = {	--分身
			"item_yasha",
			"item_ultimate_orb",
			"item_recipe_manta"
		}
		,["item_aether_lens"] = {	--以太
			"item_energy_booster",
			"item_ring_of_health",
			"item_recipe_aether_lens",
		}
		,["item_ethereal_blade"] = {		--虚灵
			"item_ghost",
			"item_eagle",
		}
		,["item_helm_of_the_dominator"] = {	--支配
			"item_headdress",
			"item_gloves",
			"item_recipe_helm_of_the_dominator"
		}
		,["item_necronomicon"] = { --死灵书
			"item_staff_of_wizardry",
			"item_belt_of_strength",
			"item_recipe_necronomicon",
		}
		,["item_assault"] = {		--强袭
			"item_hyperstone",
			"item_platemail",
			"item_chainmail",
			"item_recipe_assault"
		}
		,["item_echo_sabre"] = {	--回音战刃
			"item_ogre_axe",
			"item_quarterstaff",
			"item_sobi_mask",
			"item_robe",
		}
		,["item_black_king_bar"] = { -- BKB
			"item_ogre_axe",
			"item_mithril_hammer",
			"item_recipe_black_king_bar",
		}
		,["item_armlet"] = {	--	臂章
			"item_helm_of_iron_will",
			"item_blades_of_attack",
			"item_gloves",
			"item_recipe_armlet",
		}
		,["item_octarine_core"] = { -- 玲珑心
			"item_soul_booster",
			"item_mystic_staff"
		}
		,["item_soul_booster"] = {	-- 镇魂
			"item_energy_booster",
			"item_vitality_booster",
			"item_point_booster"
		}
		,["item_blade_mail"] = { -- 刃甲
			"item_chainmail",
			"item_robe",
			"item_broadsword"
		}
		,["item_bracer"] = {	--护腕
			"item_gauntlets",
			"item_circlet",
			"item_recipe_bracer"
		}
		,["item_ancient_janggo"] = {	--战鼓
			"item_wind_lace",
			"item_bracer",
			"item_sobi_mask",
			"item_recipe_ancient_janggo"
		}
		,["item_ring_of_aquila"] = {	--天鹰
			"item_ring_of_basilius",
			"item_wraith_band",
		}
		,["item_wraith_band"] = { -- 幽灵系带
			"item_slippers",
			"item_circlet",
			"item_recipe_wraith_band"
		}
		,["item_vladmir"] = {	--祭品
			"item_ring_of_basilius",
			"item_headdress",
			"item_lifesteal",
			"item_recipe_vladmir",
		}
		,["item_ring_of_basilius"] = { --圣殿
			"item_ring_of_protection",
			"item_sobi_mask",
		}
		,["item_buckler"] = { -- 玄冥盾牌
			"item_tango",
			"item_chainmail",
			"item_recipe_buckler",
		}
		,["item_headdress"] = { -- 恢复头巾
			"item_branches",
			"item_ring_of_regen",
            "item_recipe_headdress",
		}
        ,["item_magic_wand"] = { -- 大魔棒
            "item_magic_stick",
            "item_branches",
            "item_branches",
            "item_circlet"}
        ,["item_arcane_boots"] = { --秘法鞋
            "item_boots",
            "item_energy_booster"}
        ,["item_null_talisman"] = { --无用挂件
            "item_circlet",
            "item_mantle",
            "item_recipe_null_talisman"}
        ,["item_iron_talon"] = { --寒铁钢爪
            "item_quelling_blade",
            "item_ring_of_protection",
            "item_recipe_iron_talon"}
        ,["item_poor_mans_shield"] = { --穷鬼盾
            "item_slippers",
            "item_slippers",
            "item_stout_shield"}
        ,["item_ultimate_scepter"] = { --神杖
           "item_point_booster",
           "item_staff_of_wizardry",
           "item_ogre_axe",
           "item_blade_of_alacrity"}
        ,["item_power_treads"] = { --动力鞋
           "item_boots",
           "item_gloves",
           "item_belt_of_strength"}
        ,["item_force_staff"] = { --原力法杖o
           "item_ring_of_regen",
           "item_staff_of_wizardry",
           "item_recipe_force_staff"}
        ,["item_dragon_lance"] = { --魔龙枪
           "item_ogre_axe",
           "item_boots_of_elves",
           "item_boots_of_elves"}
        ,["item_hurricane_pike"] = { --飓风长矛
           "item_force_staff",
           "item_dragon_lance",
           "item_recipe_hurricane_pike"}
        ,["item_sange"] = {--散华
           "item_ogre_axe",
           "item_belt_of_strength",
           "item_recipe_sange"}
        ,["item_yasha"] = {--夜叉
           "item_blade_of_alacrity",
           "item_boots_of_elves",
           "item_recipe_yasha"}
        ,["item_sange_and_yasha"] = { --双刀
           "item_yasha",
           "item_sange"}
        ,["item_hood_of_defiance"] = {--挑战头巾
           "item_ring_of_health",
           "item_cloak",
           "item_ring_of_regen"}
        ,["item_phase_boots"] = { --相位鞋
           "item_boots",
           "item_blades_of_attack",
           "item_blades_of_attack"}
        ,["item_vanguard"] = { --先锋盾
           "item_stout_shield",
           "item_ring_of_health",
           "item_vitality_booster"}
        ,["item_rod_of_atos"] = { --阿托斯
           "item_vitality_booster",
           "item_staff_of_wizardry",
           "item_staff_of_wizardry"}
        ,["item_mekansm"] = { --梅肯
           "item_headdress",
           "item_buckler",
           "item_recipe_mekansm"}
         ,["item_guardian_greaves"] = { --守卫鞋
           "item_arcane_boots",
           "item_mekansm",
           "item_recipe_guardian_greaves"}
        ,["item_orchid"] = { --紫苑
           "item_oblivion_staff",
           "item_oblivion_staff",
           "item_recipe_orchid"}
        ,["item_oblivion_staff"] = { --空明杖
            "item_sobi_mask",
            "item_robe",
            "item_quarterstaff"}
        ,["item_sphere"] = { --林肯法球
            "item_pers",
            "item_ultimate_orb",
            "item_recipe_sphere"}
        ,["item_pers"] = { --坚韧球
            "item_ring_of_health",
            "item_void_stone"}
        ,["item_sheepstick"] = { --羊刀
            "item_void_stone",
            "item_ultimate_orb",
            "item_mystic_staff"}
        ,["item_heavens_halberd"] = { --天堂
            "item_sange",
            "item_talisman_of_evasion"}
        ,["item_shivas_guard"] = { --西瓦
            "item_platemail",
            "item_mystic_staff",
            "item_recipe_shivas_guard"}
}

return X;