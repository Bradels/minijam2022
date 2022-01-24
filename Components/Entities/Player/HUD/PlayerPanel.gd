extends Panel


onready var Player = get_node('../..')
onready var PlayerLabel = $PlayerLabel
onready var HeartNodes = [ $Heart1, $Heart2, $Heart3, $Heart4, $Heart5, $Heart6, $Heart7, $Heart8 ]

var id = 1
var is_current = true
var player_name = 'Player'
var player_health = 0


func _ready():
	if is_current && Server.active:
		id = get_tree().get_network_unique_id()


func _process(_delta):
	if is_current : _set_health()
	_set_hearts()
	_set_label()


func _set_hearts():
	var heart = -1
	
	for node in HeartNodes:
		node.frame = 0
	
	for i in player_health:
		if i % 4 == 0:
			heart += 1
		
		HeartNodes[heart].frame += 1


func _set_health():
	if Server.active:
		player_health = Server.players[id].health
	else:
		player_health = Player.health


func _set_label():
	if Server.active:
		player_name = Server.players[id].name
		
	PlayerLabel.text = player_name
