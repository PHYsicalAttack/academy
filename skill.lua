--技能(NATT类别会计算暴击和闪避)
local skill ={}
local modifier = {}
--可供外部访问modifier的函数
function skill:getmodifier(modname)
	if  not modifier[modname] and SUPERDEBUG then 
		print(modname .. ":buff不存在")
	else
		return modifier[modname]
	end
end

modifier["失明"] = {name="失明",accu = -50} 					--失明效果
modifier["光之影"] = {name="光之影",miss = 5}
modifier["光之耀"] = {name ="光之耀",satt = 1}
modifier["光之匿"] = {name =光之匿,sdef =999,ndef=999}


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
poweratt.cost = 5
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
smallfire.desc = "操纵小型火焰攻击敌人,造成14+自身魔法攻击力的魔法伤害"
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
mindwater.desc = "控制周围光场使敌人无法命中自己,接下来的4回合额外提升5点闪避"
skill[mindwater.name] = mindwater
mindwater.func= function (caster,target)
	caster:addmodifier("光之影",4)
end

--[[第四关获得的技能]]
--聚合光束
local conlight = {}
conlight.name = "聚合光束"
conlight.cost = 10
conlight.desc = "将周围空间的漫光聚合成强烈的激光束攻击敌人,造成2倍于魔法攻击力的伤害，并有20%的几率使敌人失明2回合"
skill[conlight.name] = conlight
conlight.func = function (caster,target)
	local attacker = caster
	local target = target
	local damage = caster.satt *2
	local damagetype = SATT
	target:applydmg({attacker,damage,damagetype})
	if math.random(100) <= 20 then
		target:addmodifier("失明",2)
	end
end

--光之耀
local shinelight = {}
shinelight.name = "光之耀"
shinelight.cost = 5
shinelight.desc = "光的能量充盈着你的身体,是自己在接下来的2回合中魔法攻击力翻倍"
skill[shinelight.name] = shinelight
shinelight.func = function (caster,target)
	caster:addmodifier("光之耀",2)
end
--穿透光束
local riftlight = {}
riftlight.name = "穿透光束"
riftlight.cost = 20
riftlight.desc = "瞬间捕捉空间所有光线并聚合反射,形成具有极大杀伤力的激光造成致命一击"
skill[riftlight.name] = riftlight
riftlight.func = function (caster,target)
	local attacker = caster
	local damage = caster.satt 
	while math.random(100) <= 30 do 
		damage  = 2*damage
	end
	local damagetype = SATT
	target:applydmg({attacker,damage,damagetype})
end
--光之匿
local hidelight = {}
hidelight.name = "光之匿"
hidelight.cost = 10
hidelight.desc = "消失在光的保护之中,在下次行动之前免疫所有伤害"
skill[hidelight.name] = hidelight
hidelight.func = function (caster,target)
	caster:addmodifier("光之匿",1)
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