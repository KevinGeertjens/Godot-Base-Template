extends PanelContainer

@onready var settingsMenu = $SettingsMenu
@onready var playButton = $Margin/VBoxContainer/Buttons/PlayButton

func _ready():
	playButton.grab_focus()

func _on_play_button_pressed():
	var gameplayScene = load("res://scenes/gameplay/gameplay.tscn")
	ChangeScene.change_scene(gameplayScene)

func _on_settings_button_pressed():
	settingsMenu.visible = !settingsMenu.visible

func _on_quit_button_pressed():
	get_tree().quit()

func _on_settings_menu_visibility_changed():
	if !settingsMenu.visible:
		playButton.grab_focus()
