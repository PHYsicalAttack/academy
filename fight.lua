--这个是战斗相关控制
local fight={}
function fight:battlespeed(role,monster)
	while role.bpos<BLENGTH and monster.bpos <BLENGTH do 
		role.bpos = role.bpos + role.bspd
		monster.bpos = monster.bpos + monster.bspd
	end

	if role.bpos>= BLENGTH then 
		role.bpos = role.bpos - BLENGTH
		return true
	elseif monster.bpos >=BLENGTH then 
		monster.bpos = monster.bpos -BLENGTH
		return false
	end
end

return fight