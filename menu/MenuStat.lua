local cfg = require("BeefStranger.UI Tweaks.config")
local bs = require("BeefStranger.UI Tweaks.common")
local id = require("BeefStranger.UI Tweaks.ID")

---@class bsMenuStat
local Stat = {}
function Stat:get() return tes3ui.findMenu(tes3ui.registerID(id.Stat)) end
function Stat:child(child) return self:get() and self:get():findChild(child) end
function Stat:visible() return self:get() and self:get().visible end
function Stat:update() return self:get() and self:get():updateLayout() end
function Stat:SkillList() return self:child("MenuStat_scroll_pane"):getContentElement() end
function Stat:BirthSign() return self:child("birth") end
function Stat:RepBlock() return self:child("MenuStat_reputation_name").parent end
function Stat:BountyBlock() return self:child("MenuStat_Bounty_name").parent end

function Stat:Acrobatics() return self:Skill(tes3.skill.acrobatics) end
function Stat:Alchemy() return self:Skill(tes3.skill.alchemy) end
function Stat:Alteration() return self:Skill(tes3.skill.alteration) end
function Stat:Armorer() return self:Skill(tes3.skill.armorer) end
function Stat:Athletics() return self:Skill(tes3.skill.athletics) end
function Stat:Axe() return self:Skill(tes3.skill.axe) end
function Stat:Block() return self:Skill(tes3.skill.block) end
function Stat:BluntWeapon() return self:Skill(tes3.skill.bluntWeapon) end
function Stat:Conjuration() return self:Skill(tes3.skill.conjuration) end
function Stat:Destruction() return self:Skill(tes3.skill.destruction) end
function Stat:Enchant() return self:Skill(tes3.skill.enchant) end
function Stat:HandToHand() return self:Skill(tes3.skill.handToHand) end
function Stat:HeavyArmor() return self:Skill(tes3.skill.heavyArmor) end
function Stat:Illusion() return self:Skill(tes3.skill.illusion) end
function Stat:LightArmor() return self:Skill(tes3.skill.lightArmor) end
function Stat:LongBlade() return self:Skill(tes3.skill.longBlade) end
function Stat:Marksman() return self:Skill(tes3.skill.marksman) end
function Stat:MediumArmor() return self:Skill(tes3.skill.mediumArmor) end
function Stat:Mercantile() return self:Skill(tes3.skill.mercantile) end
function Stat:Mysticism() return self:Skill(tes3.skill.mysticism) end
function Stat:Restoration() return self:Skill(tes3.skill.restoration) end
function Stat:Security() return self:Skill(tes3.skill.security) end
function Stat:ShortBlade() return self:Skill(tes3.skill.shortBlade) end
function Stat:Sneak() return self:Skill(tes3.skill.sneak) end
function Stat:Spear() return self:Skill(tes3.skill.spear) end
function Stat:Speechcraft() return self:Skill(tes3.skill.speechcraft) end
function Stat:Unarmored() return self:Skill(tes3.skill.unarmored) end
function Stat:focus() return self:get() and self:get():triggerEvent(tes3.uiEvent.focus) end

function Stat:Ashlanders() return self:findFaction("Ashlanders") end
function Stat:Blades() return self:findFaction("Blades") end
function Stat:CamonnaTong() return self:findFaction("Camonna Tong") end
function Stat:CensusAndExcise() return self:findFaction("Census and Excise") end
function Stat:ClanAundae() return self:findFaction("Clan Aundae") end
function Stat:ClanBerne() return self:findFaction("Clan Berne") end
function Stat:ClanQuarra() return self:findFaction("Clan Quarra") end
function Stat:EastEmpireCompany() return self:findFaction("East Empire Company") end
function Stat:FightersGuild() return self:findFaction("Fighters Guild") end
function Stat:Hlaalu() return self:findFaction("Hlaalu") end
function Stat:ImperialCult() return self:findFaction("Imperial Cult") end
function Stat:ImperialKnights() return self:findFaction("Imperial Knights") end
function Stat:ImperialLegion() return self:findFaction("Imperial Legion") end
function Stat:MagesGuild() return self:findFaction("Mages Guild") end
function Stat:Redoran() return self:findFaction("Redoran") end
function Stat:RoyalGuard() return self:findFaction("Royal Guard") end
function Stat:SixthHouse() return self:findFaction("Sixth House") end
function Stat:TCyrAbeceanTradingCompany() return self:findFaction("T_Cyr_AbeceanTradingCompany") end
function Stat:TCyrFightersGuild() return self:findFaction("T_Cyr_FightersGuild") end
function Stat:Temple() return self:findFaction("Temple") end
function Stat:TGlbArchaeologicalSociety() return self:findFaction("T_Glb_ArchaeologicalSociety") end
function Stat:TMwClanBaluath() return self:findFaction("T_Mw_Clan_Baluath") end
function Stat:TMwClanOrlukh() return self:findFaction("T_Mw_Clan_Orlukh") end
function Stat:TMwHouseDres() return self:findFaction("T_Mw_HouseDres") end
function Stat:TMwHouseIndoril() return self:findFaction("T_Mw_HouseIndoril") end
function Stat:TMwImperialNavy() return self:findFaction("T_Mw_ImperialNavy") end
function Stat:TSkyClanKhulari() return self:findFaction("T_Sky_ClanKhulari") end



---@param skill tes3.skill
function Stat:SkillLabel(skill) return self:Skill(skill).children[1] end
---@param skill tes3.skill
function Stat:SkillValue(skill) return self:Skill(skill).children[2] end
---Returns Skills Element:
---@param skill tes3.skill
---@return tes3uiElement? skillElement
function Stat:Skill(skill)
  for _, skillElement in ipairs(self:SkillList().children) do
    if skillElement:getPropertyInt("MenuStat_message") == skill then
      return skillElement
    end
  end
end
---Used to Manually Find Faction Element, if its not predefined.
---@param factionID string 
---@return tes3uiElement?
function Stat:findFaction(factionID)
  for child in table.traverse(self:SkillList().children) do
      if child.name == "MenuStat_faction_layout" then
          if child:getPropertyObject("MenuStat_message").id == factionID then
              return child
          end
      end
  end
end

return Stat