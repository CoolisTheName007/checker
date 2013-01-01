Type checking utilities in pure Lua, for sandboxes without debug library, inspired by the Sierra scheduler checker module.

You can define custom types:

+ setting checker.checkers['mytype'] to function(object) ... end.
	
	Must return a boolean.

+ setting the __type field in the object metatable.


#Example
	check=require'packages.checker'.check

	function foo(int,optional_string)
		check('number|table,?string',int,optional_string)
		stuff
	end
	
	foo(1) -> no problem
	foo({},'') -> no problem either
	(line l) foo(1,1) -(the caller is blamed, not the function)
	->>(filename):(l): arg number 2: 1 of type number is not of type ?string