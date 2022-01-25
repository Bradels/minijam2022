extends KinematicBody2D

signal entity_transform(transformed_values)
signal entity_prop_updated(id,prop,value)

var id = 0
var is_active = false
class_name Entity

func _process(_delta):
	if is_active:
		_emit_transform()

func _update_entity_prop(prop,value):
	self[prop] = value
	emit_signal("entity_prop_updated",id,prop,value)
	pass

func _emit_transform():
	emit_signal('entity_transform', {
		'id': id,
		'position': position,
		'rotation': rotation,
	})

func _apply_remote_prop_update(prop,value):
	self[prop] = value
