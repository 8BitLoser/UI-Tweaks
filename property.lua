---@class bs_UITweaks_Property
local property = {
    embed = { ---@class bs_EmbededServices.property
        visible = "Embed_Visible",
        repair_obj = "BS_Repair_Object",
        repair_data = "BS_Repair_itemData",
        repair_cost = "BS_Repair_Cost",

        spell_obj = "BS_Spells_Spell",
        spell_cost = "BS_Spells_Cost",

        trainSkill = "Train_Skill",
        trainNPCLevel = "Train_NPCLevel",
        trainNext = "Train_NextLevel",
        trainCost = "Train_Cost",
        trainAttribute = "Train_AttributeBase",
        trainHours = "BS_Embed_Train_Hours",
    }
}

return property