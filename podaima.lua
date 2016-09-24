academy2 ={}
--角色方法表
local role_mt = {level=1,attr=15,justice=100,str=10,int=5,hp=100,mp=50,natt=10,ndef=0,sdef=0,miss=0,hitrate = 0,crt=0,skill={},buffround={},bpos=0,bspd=50}
--怪物方法表
local monster_mt ={hp=300,mp=0,natt=10,bpos=0,bspd=0}


function role_mt:getattr(attrname)
	return self.attrname
end

function role_mt:isdie()
	if self.hp<1 then 
		return true 
	else 
		return false
	end
end

function role_mt:attack(monster)
	print("普攻：" .. self.natt)
	monster:applydamage(self.natt)
end

function role_mt:applydamage(damage,isskill)
	if not isskill then
		self.hp = self.hp + self.ndef - damage
	else 
		self.hp = self.hp + self.sdef - damage
	end
	return self.hp
end

function role_mt:castskill(skill,monster)

end






local function roleborn(role)
	local role = role or {}
	role_mt.__index = role_mt
	setmetatable(role,role_mt)
	return role
end

local function monsterborn(monster)
	local monster = monster or {}
	monster_mt.__index = monster_mt
	setmetatable(monster,monster_mt)
	return monster
end

local function getconfig(filename)
	local filename = filename or ""
	local pwd = string.sub(io.popen("pwd"):read("*a"),1,-2)
	local codestr = io.open(pwd .. "/" .. filename ..".config"):read("*a")
	local code =""
	for p,c in utf8.codes(codestr) do
		code = code .. utf8.char(c-13)
	end
	return load(code)()
end

function getinput(isstr)
	local input
	if not isstr then
		input = io.read("*number")
	else 
		input = io.read()
	end
	if string.byte(input) == nil then
		return getinput(isstr)
	else 
		return input
	end
end


local function showact(role)
	local natt = role.natt
	local skill = role.skil
	print(string.format([[
普攻:%d
1.
2.
3.
4.
请选择行为
]],natt))
	local actiont={1,2,3,4}
	repeat 
		local action = getinput()
	until actiont[action]
	print(action)
	--if action == 1 then 
		role:attack(.monster)
	--else 
	--	role:castskill(skill,monster)
--	end
end

function academy:battlemain()
	self.round = (self.round or 0)+1
	print(string.format([[
第%d回合：
%-30sVS%30s
]],self.round,"角色","怪物"))
	local joy = self:battlespeed(self.role,self.monster)
	if type(joy) ~= "table" then 
		print("CAN'T GET SUCCESS ACT JOY.")
		--return nil
	end
	--展示目标行动
	showact(joy)
end

function academy:battlespeed(role,monster)
	while role.bpos<100 or monster.bpos <100 do 
		role.bpos = role.bpos + role.bspd
		monster.bpos = monster.bpos + monster.bspd
	end
	if role.bpos>= 100 then 
		role.bpos = role.bpos - 100
		return role
	elseif monster.bpos >=100 then 
		monster.bpos = monster.bpos -100
		return monster
	else
		return "UNKNOW ERROR"
	end
end

function academy:enteracademy(academyid)

	-- body
end

function academy:startgame()
	local welcome =[[

欢迎试玩【从零开始的学园都市大冒险】,嘿嘿嘿!
游戏须知:
1、加点和技能左右战斗的胜利！
2、行为选择尤其重要，左右故事结局~
3、同一时间只能获得一个有益和一个负面状态。

]]
	print(welcome)
	self.role = roleborn()
	self.monster = roleborn()
	self:battlemain()
end




academy:startgame()

return academy --方便调试
