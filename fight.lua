--这个是战斗相关控制
local fight={}
function fight:battlespeed(role,monster)
	if role.bpos>= BLENGTH then 
		role.bpos = role.bpos - BLENGTH
		return true
	elseif monster.bpos >=BLENGTH then 
		monster.bpos = monster.bpos -BLENGTH
		return false
	end	
	role.bpos = role.bpos + role.bspd
	monster.bpos = monster.bpos + monster.bspd
	return self:battlespeed(role,monster)
end

return fight