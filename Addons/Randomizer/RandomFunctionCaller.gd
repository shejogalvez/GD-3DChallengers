extends Object
class_name RandomFunctionCaller

var rng := RandomNumberGenerator.new()
var total_weight := 0
var weights := []
var functions := []
var arguments := []

# Does nothing.
func do_nothing() -> void:
	return

# Puts a void function on the functions list.
func put_void_func(weight : int) -> void:
	total_weight += weight
	weights.append(weight)
	functions.append(funcref(self, "do_nothing"))
	arguments.append([])

# Puts a certain function reference in the functions list with its
# weight and object asociated.
func put_func(weight : int, object : Object, function_name : String, argument : Array = []) -> void:
	var function := funcref(object, function_name)
	if not function.is_valid():
		push_warning("Tried to put non-valid function on RandomFunctionCaller, ignored")
		return
	total_weight += weight
	weights.append(weight)
	functions.append(function)
	arguments.append(argument)

func update_weight(index : int, new_weight : int):
	weights[index] = new_weight

# Calls a random function from the functions list.
# [0                                                   ]
func call_func() -> void:
	rng.randomize()
	var outcome := rng.randi_range(0, total_weight - 1)
	var current_weight := 0
	for i in weights.size():
		current_weight += weights[i]
		if outcome < current_weight:
			if not functions[i].is_valid():
				push_warning("Non-valid function called from RandomFunctionCaller")
				return
			functions[i].call_funcv(arguments[i])
			return
