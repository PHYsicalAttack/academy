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

function fight:getrounds(id)
	local id =id or 1
	local ans = 0
	if 1==id then 
		ans = academy.battlerounds
	elseif 2 ==id then 
		ans = academy.rolerounds
	elseif 3 ==id then
		ans = academy.monsterrounds
	end
	return ans
end

return fight