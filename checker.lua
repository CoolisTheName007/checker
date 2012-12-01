---Type checking utilities in pure Lua, for sandboxes without debug library, inspired by the Sierra scheduler checker module.
--You can define custom types by
--	functions by setting checker.checkers['mytype']=function(object) ... end that return a boolean
--	setting the __type field in the object metatable
--Check out @conform for the order on which these are checked
-- @module checker
-- @usage local checker = require 'checker'
--function foo(int,optional_string)
--	check('number|table,?string',int,optional_string)
--	stuff
--end
--
--foo(1) -> no problem
--foo({},'') -> no problem either
--(line l) foo(1,1) -(the caller is blamed, not the function)
--->>(filename):(l): arg number 2: 1 of type number is not of type ?string
local M = {_TYPE='module', _NAME='checker', _VERSION='0'}

M.checkers={}
local checkers=M.checkers

function M.conforms(t,a)
	return t == "?"
	or (t:sub(1, 1) == "?" and (a==nil or conforms(t:sub(2, -1),a)))
	or type(a) == t
	or (type(a)=='table' and getmetatable(a) and getmetatable(a).__type == t)
	or (checkers[t] and checkers[t](a))
end
local conforms=M.conforms

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