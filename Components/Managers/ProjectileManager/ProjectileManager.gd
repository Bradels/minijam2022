extends Node

class_name ProjectileManager

onready var level = get_tree().root.find_node("Level",true,false)
var projectile_node

enum PROJECTILE_TYPE {SHIP_PRIMARY,SHIP_SECONDARY,PAWN_PRIMARY}

onready var is_multiplayer = get_tree().has_network_peer()
var ship_primary_projectile = preload("res://Components/Entities/Projectiles/Phaser.tscn")
var ship_secondary_projectile = preload("res://Components/Entities/Projectiles/Phaser.tscn")
var pawn_primary_projectile = preload("res://Components/Entities/Projectiles/Bullet.tscn")

var projectiles = {}

var projectile_type_map = {
	"PAWN_PRIMARY" : PROJECTILE_TYPE.PAWN_PRIMARY,
	"ship_prime" : PROJECTILE_TYPE.SHIP_PRIMARY,
	"ship_secondary": PROJECTILE_TYPE.SHIP_SECONDARY
}

func _on_projectile_fired(props) -> void:
	var type = projectile_type_map[props["type"]]
	var position = props["position"]
	var rotation = props["rotation"]
	var velocity = props["velocity"]
	var ownerid = props["owner_id"]
	
	
	spawn_projectile(
		type,
		position,
		rotation,
		velocity,
		str(ownerid))
		
	if is_multiplayer: rpc(
		"spawn_projectile",
		type,
		position,
		rotation,
		velocity,
		str(ownerid)
		)

remote func spawn_projectile(
	type:int,
	posistion:Vector2,
	rotation:float,
	velocity:Vector2 = Vector2.ZERO,
	id:String = "",
	ownerid:String = "") -> String:
		var scene = _look_up_projectile(type)
		var instance = scene.instance()
		level.add_child(instance)
		instance.position = posistion
		instance.rotation = rotation
		instance.velocity = velocity
		if id == "": id = ownerid+instance.get_instance_id()
		projectiles[id] = instance
		return id
	

func _look_up_projectile(projectile_type:int) -> PackedScene:
	if projectile_type == PROJECTILE_TYPE.SHIP_PRIMARY:
		return ship_primary_projectile
	if projectile_type == PROJECTILE_TYPE.SHIP_SECONDARY:
		return ship_secondary_projectile
	if projectile_type == PROJECTILE_TYPE.PAWN_PRIMARY:
		return pawn_primary_projectile
	return null

func _ready():
	call_deferred('_setup')

func _setup():
	projectile_node = Node2D.new()
	projectile_node.name = 'Projectile'
	level.add_child(projectile_node)
