class_name NetWorkedNode

var _owner

func _init(owner:Node):
	_owner = owner

func update_prop(prop,value):
	if _owner.has_method("update_prop"):
		_owner.update_prop(prop,value)
	else:
		_owner[prop] = value

puppet func remote_update_prop(prop,id):
	emit_signal("node_remote_updated",prop,id)
