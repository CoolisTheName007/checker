os.loadAPI('packages/pureLuaChecks/checkerAPI')
check=checkerAPI.check
function foo(int_or_table,optional_string)
	check('number|table,?string',int_or_table,optional_string)
	print('All is well')
end

foo(1)
foo({},'')
foo(1,1)