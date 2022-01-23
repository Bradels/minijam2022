extends Control


onready var root = get_node('/root/Main')
var title_scale_speed = 0.01
var title_scale_dir = 1
var is_in_game = false


func _ready():
	var options_save = SaveManager.load_options()
	if !options_save.empty():
		$OptionsMenu/Panel/MasterVolume.value = options_save["v"]
		
	Server.connect("player_connected", self, "_on_player_connected")
	Server.connect("player_disconnected", self, "_on_player_disconnected")
	Server.connect("connection_successful", self, "_on_connection_successful")
	
	change_menu("MainMenu")


func _process(delta):
	$Background/Planet.position.x += 6 * delta
	$Background/Planet.position.y += 4 * delta
	var scale_speed = title_scale_speed * title_scale_dir * delta
	$Background/Title.rect_scale += Vector2(scale_speed, scale_speed)
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
	$OptionsMenu.visible = false
	$PauseMenu.visible = false
	if menu_name == "":
		$Background.visible = false
		return
	get_node(menu_name).visible = true


 # Main Menu functions
func _on_MainMenu_HostButton_pressed():
	play_button_press_audio()
	change_menu("HostMenu")


func _on_MainMenu_JoinButton_pressed():
	play_button_press_audio()
	change_menu("JoinMenu")


func _on_MainMenu_OptionsButton_pressed():
	play_button_press_audio()
	change_menu("OptionsMenu")


func _on_MainMenu_ExitButton_pressed():
	play_button_press_audio()
	get_tree().quit()


# Host Menu functions
func _on_HostMenu_HostButton_pressed():
	play_button_press_audio()
	var player_name = $HostMenu/Panel/PlayerName.text
	var port = int($HostMenu/Panel/Port.text)
	var max_players = int($HostMenu/Panel/MaxPlayers.text)
	Server.start_server(port, max_players)
	Server.set_player_static_data({"n": player_name})
	update_lobby_player_list()
	change_menu("LobbyMenu")


func _on_HostMenu_BackButton_pressed():
	play_button_press_audio()
	change_menu("MainMenu")


# Join Menu functions
func _on_JoinMenu_JoinButton_pressed():
	play_button_press_audio()
	var player_name = $JoinMenu/Panel/PlayerName.text
	var ip = $JoinMenu/Panel/Ip.text
	var port = int($JoinMenu/Panel/Port.text)
	Server.join_server(ip, port)
	change_menu("LobbyMenu")


func _on_JoinMenu_BackButton_pressed():
	play_button_press_audio()
	change_menu("MainMenu")


# Lobby Menu functions
func _on_LobbyMenu_ReadyButton_pressed():
	play_button_press_audio()
	$MenuMusic.stop()
	var scene = load("res://Levels/MultiplayerTest.tscn")
	root.change_scene(scene.instance())
	change_menu("")
	$MenuMusic.stop()
	is_in_game = true


func _on_LobbyMenu_LeaveButton_pressed():
	play_button_press_audio()
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
	play_button_press_audio()
	$PauseMenu.visible = false


func _on_PauseMenu_MenuButton_pressed():
	play_button_press_audio()
	root._reset_scene()
	is_in_game = false
	$MenuMusic.play(0.0)
	change_menu("MainMenu")


func _on_PauseMenu_ExitButton_pressed():
	play_button_press_audio()
	get_tree().quit()
	


func _on_OptionsMenu_ApplyButton_pressed():
	play_button_press_audio()
	apply_volume($OptionsMenu/Panel/MasterVolume.value)


func _on_OptionsMenu_BackButton_pressed():
	play_button_press_audio()
	change_menu("MainMenu")


func _on_OptionsMenu_MasterVolume_value_changed(value):
	apply_volume($OptionsMenu/Panel/MasterVolume.value)
	

func apply_volume(volume):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(volume * 0.01))
	SaveManager.save_options({"v": volume})
	
func play_button_press_audio():
	$ButtonPress.play(0.0)
