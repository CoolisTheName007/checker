---Type checking utilities in pure Lua, inspired by the Sierra scheduler checker module.
-- @module checker
-- @usage local checker = require 'checker'
--function foo(int,optional_string)
--	check('number|table,?string',int,optional_string)
--	stuff
--end
--
--foo(1) -> no problem
--foo({},'') -> no problem either
--(line l) foo(1,1) -> (filename):(l): arg number 2:1 of type number is not of type ?string
local M = {_TYPE='module', _NAME='checker', _VERSION='0'}

M.checkers={}
checkers=M.checkers

function M.conforms(t,a)
	return t == "?"
	or (t:sub(1, 1) == "?" and (a==nil or conforms(t:sub(2, -1),a)))
	or type(a) == t
	or (pcall(getmetatable,a) and getmetatable(a) and getmetatable(a).__type == t)
	or (checkers[t] and checkers[t](a))
end
conforms=M.conforms

function M.check(s,...)
	local i=0
	local b
	for d in s:gmatch(',?([^,]*),?') do
		--print(t)
		i=i+1
		b=false
		for t in d:gmatch('|?([^|]*)|?') do
			--print(t)
			if conforms(t,select(i,...)) then b=true break end
		end
		--print('passed')
		if not b then
			error('arg number '..i..':'..tostring(select(i,...)==nil and 'nil' or select(i,...))..' of type '..tostring(type(select(i,...) or nil))..' is not of type '..d,3)
		end
	end
end
return M