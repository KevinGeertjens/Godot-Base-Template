extends CanvasLayer

@onready var pauseMenu = $PauseMenu

func _process(_delta):
	if !pauseMenu.visible && Input.is_action_just_released("ui_game_menu"):
		get_tree().paused = true
		pauseMenu.visible = true
