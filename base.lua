--角色方法表
local base_mt = {level=0,exp=0,hp=200,mp=50,natt=20,ndef=0,sdef=0,bpos=0,bspd=0,accu=0,miss=0,crit=0,skill={},buffround={},name ="name",law=0,good=0}
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
	elseif damagetype == SATT then 
		truedmg = damage - self.sdef
		self.hp = self.hp - truedmg
	else 
		print(ERROR_UNKNOW_DMGTYPE)
		return false
	end
	local col_losehp= string.format(STR_COLOR_FORMAT,STR_COLOR_RED,truedmg)
	local col_victimname= string.format(STR_COLOR_FORMAT,STR_COLOR_RED,self.name)
	local applydmgword =  string.format("%s受到了%s点伤害",col_victimname,col_losehp)
	print(applydmgword)
	return true
end

--是否死亡
function base_mt:isdie()
	if self.hp<1 then 
		return true
	else
		return false
	end
end

--升级,会返回升了多少级
function base_mt:levelup(exp)
	local exp = exp 
	local prelvl = self.level
	self.exp = self.exp + exp
	local nowlvl 
	for i,v in ipairs(LEVEL_TOTAL_EXP) do
		if self.exp <=v then 
			nowlvl = i
			break
		end
	end
	self.level = nowlvl
	return nowlvl-prelvl
end

--战斗行为
function base_mt:actshow()

end

--释放技能
function base_mt:castskill(skillname)
	local skillfunc
	local cost 
	for i,v in ipairs(self.skill) do 
		if v.name == skillname then 
			skillfunc = v.func
			cost = v.cost
			break
		end
	end
	--如果蓝量不足则不能释放，否则扣蓝释放技能
	if self.mp < cost then 
		print(ERROR_NOT_ENOUGH_MP)
		return false
	end
		--self.mp = self.mp -cost 
	if not target then 
		 target = self
	end
	--释放技能记录打印
	local col_name1= string.format(STR_COLOR_FORMAT,STR_COLOR_DGREEN,self.name)
	local col_name2= string.format(STR_COLOR_FORMAT,STR_COLOR_RED,target.name)
	local col_skill = string.format(STR_COLOR_FORMAT,STR_COLOR_YELLOW,skillname)
	local castword = string.format("%s对%s使用了[%s]",col_name1,col_name2,col_skill)
	print(castword)
	skillfunc(self,target,arg)
	return true
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
	--不能删除掉普攻技能
	if skillname == SKILL_NATT_NAME then 
		print(ERROR_DELETE_SKILL_NORM)
		return false
	end 
	--正常删除技能
	for i,v in ipairs(self.skill) do 
		if v.name == skillname then 
			self.skill[i] = nil 
			return true
		end
	end
	--或许有其他异常
	print(ERROR_DELETE_SKILL)
	return false

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
