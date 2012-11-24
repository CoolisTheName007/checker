os.loadAPI('checkerAPI')
check=checkerAPI.check
function foo(int_or_table,optional_string)
	check('number|table,?string',int_or_table,optional_string)
	print('All is well')
end

foo(1)
-->>All is well
foo({},'')
-->>All is well
foo(1,1)
-->>test.lua:12: arg number 2: 1 of type number is not of type ?string