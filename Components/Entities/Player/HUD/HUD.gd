extends Node


onready var PlayerPanel = preload('PlayerPanel.tscn')
onready var TeamPanels = $TeamPanels
var team_panels = {}


func _process(_delta):
	if Server.active : _process_team_panels()


func _process_team_panels():
	var me_id = get_tree().get_network_unique_id()
	var team_ids = Server.get_player_ids()
	
	for id in team_panels:
		if !id in team_ids:
			team_panels[id].queue_free()
			team_panels.erase(id)
	
	for id in Server.get_player_ids():
		if me_id == id : continue
		
		if !team_panels.has(id):
			var panel = PlayerPanel.instance()
			panel.id = id
			panel.name = 'TeamPanel' + str(id)
			panel.is_current = false
			panel.rect_position = Vector2(8, -32)
			panel.rect_scale = Vector2(0.75, 0.75)
			team_panels[id] = panel
			TeamPanels.add_child(panel)
		
		team_panels[id].player_health = Server.players[id].health
		team_panels[id].player_name = Server.players[id].name
	
	
	_set_team_panel_positions()


func _set_team_panel_positions():
	var nodes = team_panels.values()
	for i in team_panels.size():
		nodes[i].rect_position.y = 64 + (i * 32)
