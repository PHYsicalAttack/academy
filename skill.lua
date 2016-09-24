--技能元表
local skill_mt = {}

local pwd = string.sub(io.popen("pwd"):read("*a"),1,-2) 
package.path = package.path ..";" .. pwd .. "/" .."?.lua"

require("tuning")
function doublehurt(caster,target)
	local damage = 2*caster.natt
	local damagetype = NATT
	local attacker = caster
	print(target)
	target:applydmg({attacker,damage})
end
