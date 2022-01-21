extends Control


func _ready():
	Server.connect("player_connected", self, "_on_player_connected")
	Server.connect("player_disconnected", self, "_on_player_disconnected")
	Server.connect("connection_successful", self, "_on_connection_successful")
	
	change_menu("MainMenu")
	
func change_menu(menu_name):
	$MainMenu.visible = false
	$HostMenu.visible = false
	$JoinMenu.visible = false
	$LobbyMenu.visible = false
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
	pass # Replace with function body.


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
