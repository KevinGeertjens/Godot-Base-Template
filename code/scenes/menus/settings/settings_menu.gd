extends PanelContainer

func _process(_delta):
	if self.visible && Input.is_action_pressed("ui_cancel"):
		self.visible = false
