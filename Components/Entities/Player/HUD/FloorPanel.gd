extends Panel


onready var Player = get_node('../..')
onready var RoomLabel = $RoomLabel

func _ready():
	Player.connect("entity_prop_updated",self,"_on_player_prop_updated")


func _on_player_prop_updated(_id,prop,value):
	if prop == "current_room":
		RoomLabel.text = "Room: " + str(value)
