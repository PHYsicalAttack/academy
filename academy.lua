academy ={}
--全局设置
math.randomseed(os.time())

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
function academy:getinput()
	local input
	repeat
		print(string.format(STR_COLOR_FORMAT,STR_COLOR_DGREEN,"请输入数字后按回车:"))
		input = io.read()
		if input == "myinfo" then dump(self.role) end
		if input == "moninfo" then dump(self.monster) end
		input = tonumber(input)
	until input
	return math.floor(input)
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

--记录数据
function academy:record(vname,value)
	self[vname] = value
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
		unit.hp = math.floor(unit.con+(unit.level-1)*unit.conplv)*HP_PER_CON
		unit.natt = math.floor(unit.con+(unit.level-1)*unit.conplv)*NATT_PER_CON
		unit.ndef = math.floor(unit.con+(unit.level-1)*unit.conplv)*NDEF_PER_CON
		unit.mp = math.floor(unit.spir+(unit.level-1)*unit.spirplv)*MP_PER_SPIR
		unit.satt = math.floor(unit.spir+(unit.level-1)*unit.spirplv)*SATT_PER_SPIR
		unit.sdef = math.floor(unit.spir+(unit.level-1)*unit.spirplv)*SDEF_PER_SPIR
		unit.bspd = math.floor(unit.agil+(unit.level-1)*unit.agilplv)*BSPD_PER_AGIL
		unit.accu = math.floor(unit.agil+(unit.level-1)*unit.agilplv)*ACCU_PER_AGIL
		unit.miss = math.floor(unit.agil+(unit.level-1)*unit.agilplv)*MISS_PER_AGIL
		unit.crit = math.floor(unit.agil+(unit.level-1)*unit.agilplv)*CRIT_PER_AGIL
	end
	return unit
end


--创建角色
function academy:createrole()
	--print(string.rep("\n",1000))
	print(ANSI_RESET_CLEAR)
	--os.execute("clear")
	print(string.format(STR_COLOR_FORMAT,STR_COLOR_PURPLE,"开始生成角色……"))
	local attr = INIT_ATTR
	local createword = string.format(CREATEWORD,HP_PER_CON,NATT_PER_CON,NDEF_PER_CON,MP_PER_SPIR,SATT_PER_SPIR,SDEF_PER_SPIR,BSPD_PER_AGIL,ACCU_PER_AGIL,MISS_PER_AGIL,CRIT_PER_AGIL)
	print(createword,"\n")
	--这儿是属性分配读取
	local con,spir,agil --= 5,5,5
	print(string.format(STR_COLOR_FORMAT,STR_COLOR_GREEN,"请输入你要分配的体质:" .. "(" ..attr .. "点属性未分配)"))
 	while true do
		local i = self:getinput()
		if i > 0 and i < attr then
			con = i
			attr = attr - i
			break 
		else 
			print(string.format(STR_COLOR_FORMAT,STR_COLOR_RED,"你的数学是体育老师教的吗?"))
		end 
	end
	print(string.format(STR_COLOR_FORMAT,STR_COLOR_GREEN,"请输入你要分配的精神:".. "(" ..attr .. "点属性未分配)"))
	while true do
		local i = self:getinput()
		if i > 0 and i < attr then
			spir = i
			attr = attr - i
			agil = attr
			break 
		else 
			print(string.format(STR_COLOR_FORMAT,STR_COLOR_RED,"你的数学是体育老师教的吗?"))
		end 
	end
	--随机获得成长,升一级获得5点属性
	print(string.format(STR_COLOR_FORMAT,STR_COLOR_DGREEN,"正在随机生成随机属性成长(智商不会超过5)……\n"))
	self:delay(1.3)
	local conplv,spirplv,agilplv
	repeat
		conplv = self:decfloor(math.random()*5)
		spirplv = self:decfloor(math.random()*5)
		agilplv = self:decfloor(math.random()*5)
	until conplv+spirplv+agilplv <= MAX_ATTR_GAIN
	
	--指定角色名
	local name = "小栗优一"
	local ccccol = {32,36,33}
	print(string.format(STR_COLOR_FORMAT,STR_COLOR_DGREEN,name .. "?你确定以下面的属性开始游戏吗?"))
	print(string.format("\27[32m基础体质:%s \27[36m基础精神:%s \27[33m基础敏捷:%s \n\27[32m体质成长:%s \27[36m精神成长:%s \27[33m敏捷成长:%s ",con,spir,agil,conplv,spirplv,agilplv))
	local sure = {"是,开始游戏!","否,我想重建角色……"}
	local sure_str = "\n"
	for i,v in ipairs(sure) do
		sure_str =sure_str .. SERIAL[i] .. " " .. v .."\n"
	end
	print(sure_str)
	local sure_ans
	repeat
		if sure_ans then 
			print(string.format(STR_COLOR_FORMAT,STR_COLOR_DGREEN,ERROR_INPUT_OUTOF_RANGE))
		end
		sure_ans = self:getinput()
	until sure[sure_ans] 
	if sure_ans == 2 then 
		return self:createrole()
	end
	--如果使用2维矩阵就可以更加灵活的绘制。。
	local body = [[

(づ｡◕‿‿◕｡)づ 				d(･｀ω´･d*)
   ◎   ◎                    		   ⊥   ⊥
]]
	--获得角色初始阵营值
	local law = 0 				--虚假阵营值秩序,由各种剧情选择改变
	local good = 0 				--虚假阵营值善良,由各种剧情选择改变
	print(string.format(STR_COLOR_FORMAT,STR_COLOR_DGREEN,"(机器人声音)开始学园都市人格测试……\n"))
	for i,v in ipairs(MENTALITY) do 
		print(string.format(STR_COLOR_FORMAT,STR_COLOR_DGREEN,i .. "、" .. v[1]))
		print(string.format(STR_COLOR_FORMAT,STR_COLOR_DGREEN,"① 是\n② 否"))
		local men_ans = self:getinput()
		if men_ans == 1 then 
			law = law + v[2]
			good = good +v[3]
		elseif men_ans ==2 then
			law = law -v[2]
			good = good -v[3]
		else
			law = law - 20
			good = good -20
		print(string.format(STR_COLOR_FORMAT,STR_COLOR_DGREEN,"(机器人声音)怀疑你是智障……"))
		end
		print(string.format(STR_COLOR_FORMAT,STR_COLOR_DGREEN,"\n(机器人声音)读取下一题……"))
		self:delay(1.3)
	end
	print(string.format(STR_COLOR_FORMAT,STR_COLOR_DGREEN,"(机器人声音)测试完毕……"))
	local robotword = string.format("\27[36m(机器人声音)经测试你的阵营值是 %s……\27[0m",-100)
	print(robotword)
	self:delay(1.3)
	print(string.format(STR_COLOR_FORMAT,STR_COLOR_DGREEN,"(机器人声音)感觉你这样的路人在学院都市中活不过1 ……"))
	self:delay(1.3)
	print(string.format(STR_COLOR_FORMAT,STR_COLOR_DGREEN,"(你狠狠地踹了测试机器一脚!!)"))
	self:delay(1.3)
	print(string.format(STR_COLOR_FORMAT,STR_COLOR_DGREEN,"(机器人声音)嘟…嘟嘟……嘟……"))
	self:delay(1.3)
	print(string.format(STR_COLOR_FORMAT,STR_COLOR_DGREEN,"(机器人声音)系统……故…障……遭到……破…坏……"))
	self:delay(1.3)
	print(string.format(STR_COLOR_FORMAT,STR_COLOR_DGREEN,"(警报声响起!你慌忙朝门口跑去……)"))
	self:delay(1.3+1.3)
	--保存生成的属性
	self.roleattr = {level=1,name=name,body = body,con=con,spir=spir,agil=agil,conplv=conplv,spirplv=spirplv,agilplv=agilplv,law=law,good=good}
	self.role = self:unitborn(self.roleattr)
	--生成角色时增加普通攻击
	--self.role.skill = nil 
	self.role:addskill(SKILL_NATT_NAME)
	self.role:addskill("超电磁炮")
	print(ANSI_RESET_CLEAR)
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
		self:delay(1.3)
		print(string.format(STR_COLOR_FORMAT,STR_COLOR_YELLOW,self.monster.name .. ":" .. story.pass))
		self:delay(1.3)
		return STORY_RESULT_PASS
	elseif id < 4 or story.func(self) then 				--跳过前3次对话的判断
		--显示怪物说的话,现将所有对话都存进一个表
		local dialog = {}
		for i,v in ipairs(story[id]) do 
			if type(v) == "string" then 
				dialog[#dialog+1] = v 
			elseif  type(v) == "table" then 
				dialog[#dialog+1] = string.format(STR_COLOR_FORMAT,STR_COLOR_DGREEN,SERIAL[i-1] ..string.char(SPACE) ..  v[1])
			else
				print(ERROR_INVALID_CONFIG)
			end
		end
		--开始逐步显示dialog,先显示怪物说的话,稍等后再显示选择
		print(string.format(STR_COLOR_FORMAT,STR_COLOR_YELLOW,self.monster.name .. ":".. dialog[1]))
		self:delay(1.3)
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
		self:delay(1.3)
		print(string.format(STR_COLOR_FORMAT,STR_COLOR_YELLOW,self.monster.name .. ":" .. story.fight))
		self:delay(1.3+1.3)
		return STORY_RESULT_FIGHT
	end
end

--每次进入关卡后刷新角色战斗属性,并去掉所有modifier。开战斗前调用来释放怪物被动？
function academy:refresh(level)
	--刷新所有的战斗属性,如果还没有战斗胜利或战斗失败则不刷新
	--print(self.role.bspd)
	if self.wintimes or self.losetimes then 
		local unit = self.role	 
		unit.hp = math.floor(unit.con+(unit.level-1)*unit.conplv)*HP_PER_CON
		unit.natt = math.floor(unit.con+(unit.level-1)*unit.conplv)*NATT_PER_CON
		unit.ndef = math.floor(unit.con+(unit.level-1)*unit.conplv)*NDEF_PER_CON
		unit.mp = math.floor(unit.spir+(unit.level-1)*unit.spirplv)*MP_PER_SPIR
		unit.satt = math.floor(unit.spir+(unit.level-1)*unit.spirplv)*SATT_PER_SPIR
		unit.sdef = math.floor(unit.spir+(unit.level-1)*unit.spirplv)*SDEF_PER_SPIR
		unit.bspd = math.floor(unit.agil+(unit.level-1)*unit.agilplv)*BSPD_PER_AGIL
		unit.accu = math.floor(unit.agil+(unit.level-1)*unit.agilplv)*ACCU_PER_AGIL
		unit.miss = math.floor(unit.agil+(unit.level-1)*unit.agilplv)*MISS_PER_AGIL
		unit.crit = math.floor(unit.agil+(unit.level-1)*unit.agilplv)*CRIT_PER_AGIL
		unit.bpos = 0
	end 
	--刷新怪物数据从关卡配置中复制属性数据
	local temp = {}
	for k,v in pairs(level.monster) do
		temp[k] = v 
	end 
	self.monster = self:unitborn(temp)
	--怪物增加技能
	for _,v in ipairs (self.monster._skill) do 
		self.monster:addskill(v)
	end
	--怪物释放超级技能
	for _,v in ipairs (self.monster._superskill) do 
		self.monster:castskill(v)
		print(ANSI_RESET_CLEAR)
	end
end

function academy:fightinfo()
	local LEN_CHTEXT = 4
	local LEN_ENTEXT = 5
	local CHSPACE = utf8.char(12288)
	local ENSPACE = utf8.char(32)
	local hp_text = self.role.hp ..  string.rep(ENSPACE,LEN_ENTEXT - string.len(self.role.hp))
	local mp_text =  self.role.mp .. string.rep(ENSPACE,LEN_ENTEXT - string.len(self.role.mp))
	local bpos_text = self.role.bpos .. string.rep(ENSPACE,LEN_ENTEXT - string.len(self.role.bpos))
	local col_hp = string.format(STR_COLOR_FORMAT,STR_COLOR_GREEN,"生命:" .. hp_text)
	local col_mp = string.format(STR_COLOR_FORMAT,STR_COLOR_DGREEN,"魔法:" ..mp_text)
	local col_bpos = string.format(STR_COLOR_FORMAT,STR_COLOR_YELLOW,"行动值:" ..bpos_text)

	local hp2_text = self.monster.hp ..  string.rep(ENSPACE,LEN_ENTEXT - string.len(self.monster.hp))
	local bpos2_text = self.monster.bpos .. string.rep(ENSPACE,LEN_ENTEXT - string.len(self.monster.bpos))
	local col_hp2 = string.format(STR_COLOR_FORMAT,STR_COLOR_GREEN,string.rep(ENSPACE,8).. "生命:" .. hp2_text)
	local col_bpos2 = string.format(STR_COLOR_FORMAT,STR_COLOR_YELLOW,"行动值:" ..bpos2_text)

	local output = string.format([[%s%s%s%s%s]],col_hp,col_mp,col_bpos,col_hp2,col_bpos2)
	print(output)
	print(self.role.body)
end

function academy:checkattr()

end

--战斗是宠物小精灵xy
function academy:fight()
	if self.role:isdie() then 			--玩家死亡
		return FIGHT_RESULT_LOSE
	elseif self.monster:isdie() then 
		return FIGHT_RESULT_WIN
	end
	print(ANSI_RESET_CLEAR)
	self.battlerounds = self.battlerounds + 1
	print(string.format(STR_COLOR_FORMAT,STR_COLOR_PURPLE,"第" .. self.battlerounds .."回合"))
	--回复魔法值计算
	local unit= self.role
	if math.random(10000)/100 <= 2 * math.floor(unit.spir+(unit.level-1)*unit.spirplv) then
		local add_mp = math.floor(unit.spir+(unit.level-1)*unit.spirplv)
		print(string.format(STR_COLOR_FORMAT,STR_COLOR_DGREEN,"幸运发生了,你恢复了一些魔法……"))
		self.role.mp = math.min(math.floor(unit.spir+(unit.level-1)*unit.spirplv)*MP_PER_SPIR,self.role.mp+add_mp)
	end
	self:fightinfo()
	--如果是真，则让玩家采取行动，否则怪物AI
	local battleturn = fight:battlespeed(self.role,self.monster)
	if battleturn == true  then
    	print(string.format(STR_COLOR_FORMAT,STR_COLOR_DGREEN,"请选择下一步行动:"))
		self:actlist()
		local actionid 
		repeat 
			if actionid then 
				print(ERROR_INPUT_OUTOF_RANGE)
			end
			actionid = self:getinput()
		until self.role.skill[actionid]
		--技能选择目标，拙略的
		local target = self.monster
		self.role:castskill(self.role.skill[actionid].name,target)
	else
		local delaytime = 1+math.random()*2
		local thinkword = string.format(STR_COLOR_FORMAT,STR_COLOR_GREEN,self.monster.name .. "正在考虑下一步行动……")
		print(thinkword)
		self:delay(delaytime)
		self.monster.think(self)
		self:delay(1)
	end
	print(string.format(STR_COLOR_FORMAT,STR_COLOR_GREEN,"\n\n正在打扫战场……"))
	self:delay(1.5)
	print(ANSI_RESET_CLEAR)
	return self:fight() 
end

--进入关卡
function academy:levelstart(levelid)
	self:record("curlevelid",levelid)
	--生成基本信息
	local level = self.level[levelid]
	self:refresh(level)
	print(ANSI_RESET_CLEAR)	
	local level_title = string.format(STR_COLOR_FORMAT,STR_COLOR_PURPLE,"第".. levelid .. "关  " ..level.name)
	print(level_title)

	local col_name1 = string.format(STR_COLOR_FORMAT,STR_COLOR_GREEN,self.role.name) 		--人物形象。。
	local col_name2 = string.format(STR_COLOR_FORMAT,STR_COLOR_YELLOW,self.monster.name)
	local nameoutput = string.format("%s%s%s",col_name1,string.rep(utf8.char(32),32),col_name2)
	print(nameoutput) 
	print(self.role.body)
	self.story = level.story 		
	local story_result = self:storyplay(self.story)
	if story_result == STORY_RESULT_PASS then 
		self.storytimes = (self.storytimes or 0) +1 			--剧情通过次数+1
		return self:levelpass(levelid)
	elseif story_result == STORY_RESULT_FIGHT then
		--[[self.battlerounds是记录的self:fight调用次数,意思是role或者monster每出手一次,rounds就会+1]]
		self.battlerounds = 0 
		local fight_result =  self:fight()
		if fight_result == FIGHT_RESULT_WIN then 
			self.wintimes = (self.wintimes or 0) +1 			--战斗胜利次数+1
			return self:levelpass(levelid)
		elseif fight_result==FIGHT_RESULT_LOSE then
			print(string.format(STR_COLOR_FORMAT,STR_COLOR_RED,"战斗失败,你得到了一次惨烈的教训……"))
			self.losetimes = (self.losetimes or 0) +1 			--战斗失败次数+1
			self:delay(1.3+1.3)
			return self:restart()
		end
	end
end

--levelpass
function academy:levelpass(curlevelid)
	local passed = self.level[curlevelid]
	print(string.format(STR_COLOR_FORMAT,STR_COLOR_DGREEN,"通关成功!"))
	local exp = passed.exp
	local loot = passed.loot
	local leveladd = self.role:levelup(exp)
	if leveladd > 0 then 
		print(string.format(STR_COLOR_FORMAT,STR_COLOR_DGREEN,"等级提升了"..leveladd .. "级"))
	end
	local realloot ={}
	for i,v in ipairs(loot) do 
		if math.random(10000) <= v[1] then 
			table.insert(realloot,v[2])
		end
	end
	--拾取战利品
	if #realloot >0 then 
		repeat
			local str = ""
			for i,v in ipairs(realloot) do
				str = str .. SERIAL[i] .. utf8.char(32) .. v .. "\n"
			end
			print(string.format(STR_COLOR_FORMAT,STR_COLOR_YELLOW,"\n\n幸运发生了,你有未学习的技能:"))
			print(string.format(STR_COLOR_FORMAT,STR_COLOR_DGREEN,str))
			if #self.role.skill == MAX_SKILL_NUM then 
				print(string.format(STR_COLOR_FORMAT,STR_COLOR_YELLOW,"已经有6个技能,请选择一个来忘记!"))
				local forgetid 
				repeat
					if forgetid then 
						print(ERROR_INPUT_OUTOF_RANGE) 
					end
					forgetid = self:getinput()
				until self.role.skill[forgetid]
				self.role:removeskill(self.role.skill[forgetid].name)
			else 
				print(string.format(STR_COLOR_FORMAT,STR_COLOR_YELLOW,"请输入你想要学习的技能序号(错误的输入会随机放弃某个技能):"))
				local learnid = self:getinput()
				if realloot[learnid] then
					print(string.format(STR_COLOR_FORMAT,STR_COLOR_PURPLE,"你学会了" .. realloot[learnid]))
					self.role:addskill(realloot[learnid])
					table.remove(realloot,learnid)
				else
					local dropid = math.random(#realloot)
					print(string.format(STR_COLOR_FORMAT,STR_COLOR_DGREEN,"你没有学会" .. realloot[dropid]))
					table.remove(realloot,dropid)
				end
			end
		until #realloot == 0
	end
	--开始下一关
	self:delay(1.3)
	self:levelstart(curlevelid+1)

end



--re0
function academy:restart()
	return self:createrole()
end

--角色行为展示
function academy:actlist()
	--将攻击、技能存在一个表里面
	local skill = self.role.skill
	local skillnum = #skill
	local skillinfo = {}
	for i = 1,skillnum do
		--将可用技能信息存进一个info_n*skillnum的表里面(当前是4个)
		skillinfo[(i-1)*4+1] = string.format(STR_COLOR_FORMAT,STR_COLOR_GREEN,SERIAL[i])
		if skill[i]  then 
			skillinfo[(i-1)*4+2] = string.format(STR_COLOR_FORMAT,STR_COLOR_YELLOW,skill[i].name) 
			if self.role.mp >= skill[i].cost then 
				skillinfo[(i-1)*4+3] = string.format(STR_COLOR_FORMAT,STR_COLOR_DGREEN,"[" .. skill[i].cost .. "]")  
			else
				skillinfo[(i-1)*4+3] = string.format(STR_COLOR_FORMAT,STR_COLOR_RED,"[" .. skill[i].cost .. "]")
			end
			skillinfo[(i-1)*4+4] = string.format(STR_COLOR_FORMAT,STR_COLOR_WHITE,skill[i].desc)
		else
			skillinfo[(i-1)*4+2] = ""
			skillinfo[(i-1)*4+3] = "" 
			skillinfo[(i-1)*4+4] = "" 
		end
	end 
	local output =string.rep([[
%s %s%s  %s
]],skillnum)
	print(string.format(output,table.unpack(skillinfo)))
end

--游戏
function academy:startgame()
	print(ANSI_RESET_CLEAR)
	print(WELCOME)
	self.level = self:getconfig("academy")
	self:delay(5)
	self:createrole()
end

academy:startgame()
