--角色方法表
local base_mt = {level=0,hp=200,mp=50,natt=20,ndef=0,sdef=0,bpos=0,bspd=1,accu=0,miss=0,crit=0,skill={},buffround={},name ="name",justice=0}
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

--释放技能
function base_mt:castskill(skillname,target,arg)
	local skillfunc
	for i,v in ipairs(self.skill) do 
		if v.name == skillname then 
			skillfunc = v.func
			break
		end
	end
	skillfunc(self,target,arg)
end

--获得技能
function base_mt:addskill(skillname)
	--如果已拥有该技能,则无法获得
	for i,v in ipairs(self.skill) do 
		if v.name == skillname then
			print(ERROR_SAME_SKILL)
			return false
		end
	end
	--如果技能已经是4个则提示失败,返回false
	if #self.skill == MAX_SKILL_NUM then 
		print(ERROR_MAX_SKILL_NUM)
		return false
	else
		self.skill[#self.skill+1] = skill[skillname]
		return true
	end
end

--删除技能
function base_mt:removeskill(skillname)
	for i,v in ipairs(self.skill) do 
		if v.name == skillname then 
			self.skill[i] = nil 
			return true
		else
			print(ERROR_DELETE_SKILL)
			return false
		end
	end
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
