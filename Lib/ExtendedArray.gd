class_name ExtendedArray

static func filter(array:Array,function:FuncRef) -> Array:
	var new_array = []
	for item in array:
		if function.call_funcv([item]):
			new_array.append(item)
	return new_array

static func map(array,function:FuncRef,vargs:Array =[]) -> Array:
	var new_array = []
	for item in array:
		var item_vargs = vargs.duplicate(true)
		item_vargs.push_front(item)
		new_array.append(function.call_funcv(item_vargs))
	return new_array
