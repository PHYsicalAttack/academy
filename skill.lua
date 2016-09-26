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

--强力击
local poweratt = {}
poweratt.name = "强力击"
poweratt.cost =5
poweratt.desc = "强力攻击,造成3倍于攻击力的普攻伤害"
skill[poweratt.name] = poweratt
poweratt.func = function (caster,target)
	local poweratt_muti = 3				--强力击倍数
	local damage = (caster.natt*poweratt_muti)
	--强力击计算暴击
	if math.random(100) <= caster.crit then 
		damage = damage * CRIT_MUTI
	end 
	local attacker = caster
	local damagetype = NATT
	target:applydmg({attacker,damage,damagetype})
end
 
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





return skill