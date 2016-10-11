--技能(NATT类别会计算暴击和闪避)
local skill ={}

--普通攻击
local noratt = {}
noratt.passive = true
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

--[[一方通行技能:反射、xxxxx、xxxxxxx]]
--反射： 这个技能被动生效调用一次后，会直接改变角色的applydmg方法
local reflect = {}
reflect.name = "矢量操作:反射"
reflect.cost = 0
reflect.desc = "反射所有魔法伤害"
skill[reflect.name] = reflect
reflect.func = function (caster,target)
	caster.applydmg = nil
	caster.applydmg = function (caster,t_dmg)
		local self = caster
		local attacker,damage,damagetype = table.unpack(t_dmg)
		local truedmg
		if damagetype == NATT then 
			--普攻会计算闪避
			if math.random(100) <=self.miss then
				truedmg = 0
			else 
				truedmg = damage - self.ndef
			end
			self.hp = self.hp - truedmg
			return true
		elseif damagetype == SATT then 
			truedmg = damage - self.sdef
			--改变伤害来源并反弹伤害，自己不受到伤害
			attacker:applydmg({self,truedmg,SATT})
			truedmg = 0
			self.hp = self.hp - truedmg
			return true
		else 
			print(ERROR_UNKNOW_DMGTYPE)
			return false
		end

			-- body
		end		
end






return skill