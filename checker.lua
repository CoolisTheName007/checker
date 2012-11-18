checkers={}

function conforms(t,a)
	return t == "?"
	or (t:sub(1, 1) == "?" and (a==nil or conforms(t:sub(2, -1),a)))
	or type(a) == t
	or (pcall(getmetatable,a) and getmetatable(a) and getmetatable(a).__type == t)
	or (checkers[t] and checkers[t](a))
end

function check(s,...)
	local i=0
	local b
	for d in s:gmatch(',?([^,]*),?') do
		i=i+1
		b=true
		for t in d:gmatch('.?([^.]*).?') do
			b=conforms(t,select(i,...))
		end
		if not b then
			error('arg number '..i..':'..tostring(select(i,...),nil)..'of type '..tostring(type(select(i,...)))..' is not of type '..d,3)
		end
	end
end