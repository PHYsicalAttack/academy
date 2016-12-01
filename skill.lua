--技能(NATT类别会计算暴击和闪避)
local skill ={}

--普通攻击
local noratt = {}
noratt.name = SKILL_NATT_NAME
noratt.cost = 0
noratt.desc = "普通攻击,造成等于攻击力的普攻伤害"
skill[noratt.name] = noratt
noratt.func = function (caster,target)
	local damage = caster.natt
	--普攻会计算暴击
	if math.random(100) <= caster.crit then 
		damage = (damage * CRIT_MUTI)
	end
	local attacker = caster
	local damagetype = NATT
	target:applydmg({attacker,damage,damagetype})
end
--[[第一关混混技能]]
--强力击
local poweratt = {}
poweratt.name = "强力击"
poweratt.cost = 3
poweratt.desc = "强力攻击,造成2倍于攻击力的普攻伤害"
skill[poweratt.name] = poweratt
poweratt.func = function (caster,target)
	local poweratt_muti = 2				--强力击倍数
	local damage = (caster.natt*poweratt_muti)
	--强力击计算暴击
	if math.random(100) <= caster.crit then 
		damage = damage * CRIT_MUTI
	end 
	local attacker = caster
	local damagetype = NATT
	target:applydmg({attacker,damage,damagetype})
end
--小型火焰
local smallfire ={}
smallfire.name = "操纵火焰"
smallfire.cost = 5
smallfire.desc = "操纵小型火焰攻击敌人,造成少量魔法伤害"
skill[smallfire.name] = smallfire
smallfire.func = function (caster,target)
	local base_damage = 14
	local spir_damge = caster.satt
	local attacker = caster
	local damagetype = SATT
	local damage = base_damage +spir_damge
	target:applydmg({attacker,damage,damagetype})
end

--[[第二关技能]]
--意念之光
local mindwater ={}
mindwater.name = "意念之光"
mindwater.coast = 5
mindwater.desc = "控制身体周围的光能量场,使敌人无法准确命中自己"
skill[mindwater.name] = mindwater
mindwater.func= function (caster,target)
	local mus_speed = 5
	local col_losehp= string.format(STR_COLOR_FORMAT,STR_COLOR_RED,truedmg)
	local col_victimname= string.format(STR_COLOR_FORMAT,STR_COLOR_RED,self.name)
	local applydmgword =  string.format("%s受到了%s点伤害",col_victimname,col_losehp)
	print(applydmgword)
end

--[[第四关获得的技能]]
--聚合光束
local conlight = {}
conlight.name = "聚合光束"
conlight.cost = 15
conlight.desc = "伤害并致盲"
skill[conlight.name] = conlight
conlight.func = function (caster,target)

end
--奇异光芒
local magiclight = {}
magiclight.name = "奇异光芒"
magiclight.cost = 15
magiclight.desc = "提升闪避"
skill[magiclight.name] = magiclight
magiclight.func = function (caster,target)

end
--光之耀
local shinelight = {}
shinelight.name = "光之耀"
shinelight.cost = 15
shinelight.desc = "提升魔法伤害"
skill[shinelight.name] = shinelight
shinelight.func = function (caster,target)

end
--穿透光束
local riftlight = {}
riftlight.name = "穿透光束"
riftlight.cost = 15
riftlight.desc = "伤害并致命"
skill[riftlight.name] = riftlight
riftlight.func = function (caster,target)

end
--光之匿
local hidelight = {}
hidelight.name = "光之匿"
hidelight.cost = 15
hidelight.desc = "完全免疫下次伤害"
skill[hidelight.name] = hidelight
hidelight.func = function (caster,target)

end


--[[炮姐技能:超电磁炮、]]
--超电磁炮
local railgun = {}
railgun.name = "超电磁炮"
railgun.cost = 20
railgun.desc = "常盘台王牌lvl5超能力者-御坂美琴的招牌技能"
skill[railgun.name] = railgun
railgun.func = function (caster,target)
	local basedmg = 100
	local damage = caster.natt
	--额外附加攻击力倍率的魔法伤害
	if math.random(100) <= caster.crit then 
		damage = damage * CRIT_MUTI
	end 
	local attacker = caster
	local damagetype = SATT
	local totaldmg = basedmg + damage
	target:applydmg({attacker,totaldmg,damagetype})
end

--[[一方通行技能:反射、xxxxx、xxxxxxx]]
--反射
local reflect = {}
reflect.passive = true
reflect.name = "矢量操作:反射"
reflect.cost = 0
reflect.desc = "反射所有魔法伤害"
skill[reflect.name] = reflect
reflect.func = function (caster,target)
	caster.bfapplydmg = function (t_dmg)
		local attacker,damage,damagetype = table.unpack(t_dmg)
			if damagetype == SATT then 
				t_dmg[2]=0
				attacker:applydmg({caster,damage,damagetype})
			end
		-- body
	end	
end






return skill