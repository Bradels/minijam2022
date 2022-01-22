extends Control

var title_scale_speed = 0.0001
var title_scale_dir = 1
var is_in_game = false

func _ready():
	Server.connect("player_connected", self, "_on_player_connected")
	Server.connect("player_disconnected", self, "_on_player_disconnected")
	Server.connect("connection_successful", self, "_on_connection_successful")
	
	change_menu("MainMenu")
	

func _process(delta):
	$Background/Planet.rect_position.x += 0.06
	$Background/Planet.rect_position.y += 0.04
	$Background/Title.rect_scale += Vector2(title_scale_speed * title_scale_dir, title_scale_speed * title_scale_dir)
	if $Background/Title.rect_scale.x > 1.2:
		title_scale_dir = -1
		$Background/Title.rect_scale = Vector2(1.2, 1.2)
	
	if $Background/Title.rect_scale.x < 1.0:
		title_scale_dir = 1
		$Background/Title.rect_scale = Vector2(1.0, 1.0)
		
	if Input.is_action_just_pressed("ui_cancel"):
		if is_in_game:
			$PauseMenu.visible = !$PauseMenu.visible
	
func change_menu(menu_name):
	$Background.visible = true
	$MainMenu.visible = false
	$HostMenu.visible = false
	$JoinMenu.visible = false
	$LobbyMenu.visible = false
	$PauseMenu.visible = false
	if menu_name == "":
		$Background.visible = false
		return
	get_node(menu_name).visible = true
	
 # Main Menu functions
func _on_MainMenu_HostButton_pressed():
	change_menu("HostMenu")


func _on_MainMenu_JoinButton_pressed():
	change_menu("JoinMenu")


func _on_MainMenu_OptionsButton_pressed():
	pass # Replace with function body.


func _on_MainMenu_ExitButton_pressed():
	get_tree().quit()


# Host Menu functions
func _on_HostMenu_HostButton_pressed():
	var player_name = $HostMenu/Panel/PlayerName.text
	var port = int($HostMenu/Panel/Port.text)
	var max_players = int($HostMenu/Panel/MaxPlayers.text)
	Server.start_server(port, max_players)
	Server.set_player_static_data({"n": player_name})
	update_lobby_player_list()
	change_menu("LobbyMenu")


func _on_HostMenu_BackButton_pressed():
	change_menu("MainMenu")


# Join Menu functions
func _on_JoinMenu_JoinButton_pressed():
	var player_name = $JoinMenu/Panel/PlayerName.text
	var ip = $JoinMenu/Panel/Ip.text
	var port = int($JoinMenu/Panel/Port.text)
	Server.join_server(ip, port)
	change_menu("LobbyMenu")


func _on_JoinMenu_BackButton_pressed():
	change_menu("MainMenu")


# Lobby Menu functions
func _on_LobbyMenu_ReadyButton_pressed():
	var scene = load("res://Scenes/Locations/Location.tscn")
	get_node("/root/Main").add_child(scene.instance())
	change_menu("")
	$MenuMusic.stop()
	is_in_game = true


func _on_LobbyMenu_LeaveButton_pressed():
	Server.close_server()
	change_menu("MainMenu")

func update_lobby_player_list():
	$LobbyMenu/Panel/PlayerList.clear()
	for player in Server.player_static_data.values():
		$LobbyMenu/Panel/PlayerList.add_item(player["n"])


func _on_player_connected():
	update_lobby_player_list()
	
	
func _on_player_disconnected():
	update_lobby_player_list()
	

func _on_connection_successful():
	var player_name = $JoinMenu/Panel/PlayerName.text
	Server.set_player_static_data({"n": player_name})
	change_menu("LobbyMenu")


func _on_button_hover():
	$ButtonHover.play(0.0)


func _on_PauseMenu_ResumeButton_pressed():
	$PauseMenu.visible = false


func _on_PauseMenu_MenuButton_pressed():
	get_node("/root/Main/Location").queue_free()
	is_in_game = false
	change_menu("MainMenu")


func _on_PauseMenu_ExitButton_pressed():
	get_tree().quit()
