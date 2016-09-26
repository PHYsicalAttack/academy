--debug函数，调试的时候用require加载

function dump(t)
	for k,v in pairs(t) do 
		print(k,v)
	end 
end