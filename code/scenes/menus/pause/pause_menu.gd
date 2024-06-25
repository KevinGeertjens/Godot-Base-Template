extends PanelContainer

@onready var settingsMenu = $SettingsMenu
@onready var continueButton = $Center/PanelContainer/MarginContainer/Buttons/ContinueButton

func _on_continue_button_pressed():
	get_tree().paused = false
	self.visible = false

func _on_settings_button_pressed():
	settingsMenu.visible = !settingsMenu.visible

func _on_quit_main_menu_button_pressed():
	get_tree().paused = false
	var mainMenuScene = load("res://scenes/menus/main/main_menu.tscn")
	ChangeScene.change_scene(mainMenuScene)

func _on_quit_desktop_button_pressed():
	get_tree().quit()

func _on_visibility_changed():
	if visible:
		continueButton.grab_focus()

func _on_settings_menu_visibility_changed():
	if !settingsMenu.visible:
		continueButton.grab_focus()
