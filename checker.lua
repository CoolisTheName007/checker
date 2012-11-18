checkers={}
function newchecker(name,f)
	checkers[name]=f
end
function conforms(t,a)
	return t == "?"
	or (t:sub(1, 1) == "?" and (a==nil or conforms(t:sub(2, -1),a)))
	or type(a) == t
	or (pcall(getmetatable,a) and getmetatable(a) and getmetatable(a).__type == t)
	or (checkers[t] and checkers[t](a))
end

function check_one(d,a)
	for t in d:gmatch('|?([^|]*)|?') do
		if conforms(t,a) then return true end
	end
	return false
end

function checka(...)
	for i=1,select('#',...),2 do
		if not check_one(select(i,...)) then
			error('arg number '..i..':'..tostring(select(i+1,...),nil)..'of type '..tostring(type(select(i+1,...)))..' is not of type '..tostring(select(i,...),nil),3)
		end
	end
end
function checkb(...)
	local n=select('#',...)
	for i=1,n/2 do
		if not check_one(select(i,...),select(n/2+i,...)) then
			error('arg number '..i..':'..tostring(select(n/2+1,...),nil)..' of type '..tostring(type(select(n/2+1,...)))..' is not of type '..tostring(select(i,...),nil),3)
		end
	end
end

check=checkb