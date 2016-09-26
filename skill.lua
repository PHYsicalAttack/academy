--技能
local skill ={}

--重击
local doublehurt = {}
doublehurt.name = "重击"
skill[doublehurt.name] = doublehurt
doublehurt.func = function (caster,target)
	local damage = 2*caster.natt
	local damagetype = NATT
	local attacker = caster
	target:applydmg({attacker,damage})
end





return skill