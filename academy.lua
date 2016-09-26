academy ={}
--全局设置
math.randomseed(os.time())
--[[HP_PER_CON=10 				--每点体质增加hp值
NATT_PER_CON=1 				--每点体质增加普攻值
NDEF_PER_CON =1 			--每点体质增加普防值
MP_PER_SPIR = 5 			--每点精神增加mp值
SATT_PER_SPIR = 2.5  		--每点精神增加技能攻击值
SDEF_PER_SPIR = 1 			--每点精神增加技能防御值
BSPD_PER_AGIL = 4         	--每点敏捷增加战斗速度值
ACCU_PER_AGIL = 1   		--每点敏捷增加命中值，只有闪避时才额外计算
MISS_PER_AGIL = 1 			--每点敏捷增加闪避值
CRIT_PER_AGIL = 1 			--每点敏捷增加的暴击值
BASEEXP_LEVEL_NEED = 10 	--升级需要的基础经验
ADJEXP_LEVEL_NEED = 3 		--升级调整经验(adjexp*level)
BLENGTH=100					--战斗回合距离值]]

local pwd = string.sub(io.popen("pwd"):read("*a"),1,-2) 
package.path = package.path ..";" .. pwd .. "/" .."?.lua"
require("tuning")
require("debugfunc")

skill = require("skill")   						--skill前面不能加local不然在base中会访问不到,要么在base中重新require.
local fight = require("fight")
local base_mt = require("base")

--解析加密配置
function academy:getconfig(filename)
	local filename = filename
	local pwd = string.sub(io.popen("pwd"):read("*a"),1,-2)
	local codestr = io.open(pwd .. "/" .. filename ..".config"):read("*a")
	local code =""
	for p,c in utf8.codes(codestr) do
		--code = code .. utf8.char(c-13)
		code = code .. utf8.char(c)
	end
	return load(code)()
end

--获取输入(游戏不给输入其他文字,只给输入数字)
function academy:getinput(isstr)
	local input
	if not isstr then
		input = io.read("*number")
	else 
		input = io.read()
	end
	if string.byte(input) == nil then
		return self:getinput(isstr)
	else 
		return input
	end
end

--小数2为取整
function academy:decfloor(tinysec)
	return tinysec - tinysec%(0.1^2)
end

--延时程序,没吊用,就是在那等几秒(支持0.01s数量级)
function academy:delay(delay)
	local delay = delay or 3
	local i =10000
	local pre = self:decfloor(os.clock())
	while self:decfloor(os.clock())<pre +delay do
		 i = i +10000
	end
	return delay
end

--单位生成
function academy:unitborn(t)
	unit = t or {}
	setmetatable(unit,base_mt)
	--这儿写一些熟悉计算的公式，怪物的话应该没有基础属性，并且lv=0,如果不是1则认为是角色。
	--另外没有的属性会从元表继承
	if unit.level>0 then 
		unit.hp = math.floor(unit.con+unit.level*unit.conplv)*HP_PER_CON
		unit.natt = math.floor(unit.con+unit.level*unit.conplv)*NATT_PER_CON
		unit.ndef = math.floor(unit.con+unit.level*unit.conplv)*NDEF_PER_CON
		unit.mp = math.floor(unit.spir+unit.level*unit.spirplv)*MP_PER_SPIR
		unit.satt = math.floor(unit.spir+unit.level*unit.spirplv)*SATT_PER_SPIR
		unit.sdef = math.floor(unit.spir+unit.level*unit.spirplv)*SDEF_PER_SPIR
		unit.bspd = math.floor(unit.agil+unit.level*unit.agilplv)*BSPD_PER_AGIL
		unit.accu = math.floor(unit.agil+unit.level*unit.agilplv)*ACCU_PER_AGIL
		unit.miss = math.floor(unit.agil+unit.level*unit.agilplv)*MISS_PER_AGIL
		unit.crit = math.floor(unit.agil+unit.level*unit.agilplv)*CRIT_PER_AGIL
	end
	return unit
end

--创建角色
function academy:createrole()
	--print(string.rep("\n",1000))
	os.execute("clear")
	local attr = 15
	print([[请分配熟悉点至体质、精神、敏捷：
每一点体质增加10点生命，1点普通攻击，1点普通防御
每一点精神增加5点魔法，2.5点技能伤害，1点魔法防御
每一点敏捷增加0.4的速度，0.2暴击，0.2闪避]])
	--这儿是属性分配读取
	local con,spir,agil = 5,5,5
	--随机获得成长,升一级获得5点属性
	print([[roll随机成长，属性成长总和不能大于5，计算属性值时只会计算整数部分。]])
	local conplv,spirplv,agilplv
	repeat
		conplv = self:decfloor(math.random()*5)
		spirplv = self:decfloor(math.random()*5)
		agilplv = self:decfloor(math.random()*5)
	until conplv+spirplv+agilplv <= MAX_ATTR_GAIN
	--获得角色名
	local name = "role"
	--获得角色初始阵营值
	local law = 5 				--虚假阵营值秩序,由各种剧情选择改变
	local good = 5 				--虚假阵营值善良,由各种剧情选择改变
	--保存生成的属性
	self.roleattr = {con=con ,spir=spir,agil=agil,conplv=conplv,spirplv=spirplv,agilplv=agilplv,level=1,name=name,law=law,good=good}
	self.role = self:unitborn(self.roleattr)
	self.role:addskill("普通攻击")
	return self:levelstart(1)
end 

--战斗是宠物小精灵xy
function academy:fight()
	local battleturn = fight:battlespeed(self.role,self.monster)
	--如果是真，则让玩家采取行动，否则怪物AI
	if battleturn == true  then 
		self.role:addskill("超电磁炮")
		self:actlist()
		--local act = self:getinput()
		--print(act)
		print("普攻","怪物生命",self.role.natt,self.monster.hp)
		self.role:castskill("超电磁炮",self.monster)
		print(self.monster.hp)
	else
		print(self.monster.bpos)
	end
end

--剧情播放
function academy:storyplay(story_t,id)
	--在剧情里面
	local story = story_t
	local id = id or 1
	if id > #story then 
		return STORY_RESULT_PASS
	elseif story.func(self) then 
		--开始展示剧情、读取选择、改变阵营值
			--代码
		-----
		return self:storyplay(story,id+1)
	else 
		return STORY_RESULT_FIGHT
	end
end

--进入关卡
function academy:levelstart(levelid)
	--生成基本信息
	local level = self.level[levelid]				
	self.role = self:unitborn(self.roleattr)
	self.monster = self:unitborn(level.monster)
	self.story = level.story 
	local story_result = self:storyplay(self.story)
	if story_result == STORY_RESULT_PASS then 
		return self:levelstart(levelid+1)
	elseif story_result == STORY_RESULT_FIGHT then 
		return self:fight()
	end
end

function academy:actlist()
	--将攻击、技能存在一个表里面
	local skill = self.role.skill
	local skillinfo = {}
	for i = 1,MAX_SKILL_NUM do 
		if skill[i] then 
			skillinfo[(i-1)*2+1] = skill[i].name
			skillinfo[(i-1)*2+2]= skill[i].desc
		else
			skillinfo[(i-1)*2+1] = ""
			skillinfo[(i-1)*2+2] = "" 
		end
	end 
	local output =[[
① %s %s
② %s %s
③ %s %s
④ %s %s
⑤ %s %s
⑥ %s %s]]
	print(string.format(output,table.unpack(skillinfo)))
end

--游戏
function academy:startgame()
	print(WELCOME)
	self.level = self:getconfig("academy")
	self:createrole()
end

academy:startgame()
