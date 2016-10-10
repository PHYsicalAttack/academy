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

skill = require("skill")   						--skill是全局变量,不能加local不然在base中会访问不到,要么在base中重新require.
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
	if (not input)or string.byte(input) == nil then
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
	local delay = self:decfloor(delay) or 3
	local i =10000
	local pre = self:decfloor(os.clock())
	while self:decfloor(os.clock())<pre +delay do
		 i = i +10000
	end
	return delay
end

--彩色字输出
function academy:colprint(ansi_str)
	local str 

	-- body
end


--单位生成
function academy:unitborn(t)
	local unit = t or {}
	--单独将skill表等插入unit不从元表继承那个skill空表。
	unit.skill = unit.skill or {}
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
	print(ANSI_RESET_CLEAR)
	--os.execute("clear")
	local attr = 15
	local createword = string.format(CREATEWORD,HP_PER_CON,NATT_PER_CON,NDEF_PER_CON,MP_PER_SPIR,SATT_PER_SPIR,SDEF_PER_SPIR,BSPD_PER_AGIL,ACCU_PER_AGIL,MISS_PER_AGIL,CRIT_PER_AGIL)
	print(createword)
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
	self.roleattr = {level=1,name=name,con=con,spir=spir,agil=agil,conplv=conplv,spirplv=spirplv,agilplv=agilplv,law=law,good=good}
	self.role = self:unitborn(self.roleattr)
	--生成角色时增加普通攻击
	self.role:addskill(SKILL_NATT_NAME)
	return self:levelstart(1)
end 

--剧情播放
function academy:storyplay(story_t,id)
	do 
	--return STORY_RESULT_FIGHT
	end
	--在剧情里面
	local story = story_t
	local id = id or 1
	if id > #story then
		print(story.pass)
		return STORY_RESULT_PASS
	elseif id <math.random(#story) or story.func(self) then 				--至少会进行最后一次判断
		--显示怪物说的话,现将所有对话都存进一个表
		local dialog = {}
		for i,v in ipairs(story[id]) do 
			if type(v) == "string" then 
				dialog[#dialog+1] = v 
			elseif  type(v) == "table" then 
				dialog[#dialog+1] = SERIAL[i-1] ..string.char(SPACE) ..  v[1]
			else
				print(ERROR_INVALID_CONFIG)
			end
		end
		--开始逐步显示dialog,先显示怪物说的话,稍等后再显示选择
		print(dialog[1])
		self:delay(0.7)
		for i,v in ipairs(dialog) do 
			if i >1 then 
				print(v)
			end
		end
		--显示完毕，获取玩家输入，计算
		local tem 
		repeat 
			if tem then 
				print(ERROR_INPUT_OUTOF_RANGE)
			end
			tem = self:getinput()
		until story[id][tem+1]
		local choice = tem + 1 				--实际内容是输入+1表中的值
		local change_law,change_good = story[id][choice][2],story[id][choice][3]
		self.role.law = self.role.law + change_law
		self.role.good = self.role.good + change_good
		--符合条件继续进行下一个
		return self:storyplay(story,id+1)
	else 
		print(story.fight)
		return STORY_RESULT_FIGHT
	end
end

--每次进入关卡后刷新角色战斗属性,并去掉所有modifier。开战斗前调用来释放怪物被动？
function academy:refresh(level)
	--刷新所有的战斗属性,如果还没有战斗胜利或战斗失败则不刷新
	--print(self.role.bspd)
	if self.wintimes or self.losetimes then 
		local unit = self.role 
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
	--刷新怪物数据
	self.monster = self:unitborn(level.monster)
	--怪物增加技能
	for _,v in ipairs (self.monster._skill) do 
		self.monster:addskill(v)
	end
	--怪物释放超级技能
	for _,v in ipairs (self.monster._superskill) do 
		self.monster:castskill(v)
	end
end

--战斗是宠物小精灵xy
function academy:fight()
	if self.role:isdie() then 			--玩家死亡
		return FIGHT_RESULT_LOSE
	elseif self.monster:isdie() then 
		return FIGHT_RESULT_WIN
	end
	--print(ANSI_CLEAR)
	print(self.monster.bspd,self.monster.bpos,"|| ",self.role.bspd,self.role.bpos)
	self.battlerounds = self.battlerounds + 1
	--如果是真，则让玩家采取行动，否则怪物AI
	local battleturn = fight:battlespeed(self.role,self.monster)
	if battleturn == true  then 
		self.role:addskill("超电磁炮")
		self.monster:addskill("矢量操作:反射")
		--self.monster:castskill("矢量操作:反射")
		--self.monster:removeskill("矢量操作:反射")
		print("角色生命",self.role.hp,"!!! ","怪物生命",self.monster.hp)
		self:actlist()
		--local act = self:getinput()
		--print(act)
		self.role:castskill("超电磁炮",self.monster)
		--self.role:castskill("普通攻击",self.monster)
		print("角色生命",self.role.hp," ","怪物生命",self.monster.hp)
	else
		self:delay(math.random()*3)
		--这儿不能用冒号语法糖，不然传进去的是self.monster
		self.monster.think(self)
	end
	return self:fight() 
end

--进入关卡
function academy:levelstart(levelid)
	--生成基本信息
	local level = self.level[levelid]		
	local level_title = string.format("第%d关",levelid)
	print(level_title)
	--self.role这儿要去掉，重新进入不会重新生成角色,而是根据属性重新计算属性值，去掉buff和debuff这些,另写一个refresh函数
	self:refresh(level)
	self.story = level.story 
	local story_result = self:storyplay(self.story)
	if story_result == STORY_RESULT_PASS then 
		self.storytimes = (self.storytimes or 0) +1 			--剧情通过次数+1
		return self:levelstart(levelid+1)
	elseif story_result == STORY_RESULT_FIGHT then
		--[[self.battlerounds是记录的self:fight调用次数,意思是role或者monster每出手一次,rounds就会+1]]
		self.battlerounds = 0 
		local fight_result =  self:fight()
		if fight_result == FIGHT_RESULT_WIN then 
			self.wintimes = (self.wintimes or 0) +1 			--战斗胜利次数+1
			self.role:levelup(1000)
			return self:levelstart(levelid+1)
		elseif fight_result==FIGHT_RESULT_LOSE then
			print("这儿是战斗失败从0开始")
			self.losetimes = (self.losetimes or 0) +1 			--战斗失败次数+1
			return false
		end
	end
end

--角色行为展示
function academy:actlist()
	--将攻击、技能存在一个表里面
	local skill = self.role.skill
	local skillnum = #skill
	local skillinfo = {}
	for i = 1,skillnum do
		--将可用技能信息存进一个info_n*skillnum的表里面(当前是4个)
		skillinfo[(i-1)*4+1] = SERIAL[i] 
		if skill[i] then 
			skillinfo[(i-1)*4+2] = skill[i].name 
			skillinfo[(i-1)*4+3]= skill[i].cost  
			skillinfo[(i-1)*4+4]= skill[i].desc 
		else
			skillinfo[(i-1)*4+2] = ""
			skillinfo[(i-1)*4+3] = "" 
			skillinfo[(i-1)*4+4] = "" 
		end
	end 
	local output =string.rep([[
%s %s[%s]  %s
]],skillnum)
	print(string.format(output,table.unpack(skillinfo)))
end

--游戏
function academy:startgame()
	print(ANSI_RESET_CLEAR)
	print(WELCOME)
	self.level = self:getconfig("academy")
	self:delay(3.7)
	self:createrole()
end

academy:startgame()
