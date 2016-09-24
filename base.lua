--角色方法表
local base_mt = {level=0,hp=200,mp=50,natt=20,ndef=0,sdef=0,bpos=0,bspd=1,accu=0,miss=0,crit=0,skill={},buffround={},justice=0}
base_mt.__index = base_mt

--获取某项
function base_mt:getattr(attrname)
	return self[attrname]
end

--攻击行为
function base_mt:createdmg(target,damagetype)
	local attacker = self
	local damage = self.natt
	local damagetype =damagetype
	target:applydmg({attacker,damage})
end

--受到伤害
function base_mt:applydmg(t_dmg)
	local attacker,damage = table.unpack(t_dmg)
	self.hp = self.hp - damage
end

--是否死亡
function base_mt:isdie()
	if self.hp<1 then 
		return true
	else
		return false
	end
end

function base_mt:castability()
	
end
--升级
function base_mt:upgrade(grade)
	print("shengji ")
	-- body
end

--战斗行为
function base_mt:actshow()

end

function base_mt:castskill(skill,target,arg)
	local caster = self
	local target = target
	local arg = arg
	skill(caster,target,arg)
end

--add skill
function base_mt:addskill(skill) 
	self.skill[#self.skill+1] = {}
	self.skill[#self.skill].name = tostring(skill)
	self.skill[#self.skill].skillfunc = skill
end

--remove skill
function base_mt:removeskill(skill)
	local skillname = tostrin
	-- body
end

--add modifier
function base_mt:addmodifier(modname)
	-- body
end

--removemodifier
function base_mt:removemodifier(modname)
	-- body
end




return base_mt
