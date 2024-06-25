extends PanelContainer

@onready var tabContainer = $Margin/PanelContainer/Margin/VBoxContainer/Tabs
@onready var graphicsMenu = $Margin/PanelContainer/Margin/VBoxContainer/Tabs/Graphics
@onready var exitButton = $Margin/PanelContainer/Margin/VBoxContainer/Header/ExitButton

func _process(_delta):
	if self.visible && Input.is_action_pressed("ui_cancel"):
		self.visible = false
		
	# Switch focus from exit button to selected tab (can't be done via regular focus editor)
	if (exitButton.has_focus() && 
	( Input.is_action_just_pressed("ui_down") || Input.is_action_just_pressed("ui_left")) ):
		tabContainer.get_tab_bar().grab_focus()

func _on_exit_button_pressed():
	self.visible = false

func _on_visibility_changed():
	if visible:
		tabContainer.get_tab_bar().grab_focus()
		#graphicsMenu.windowSizeButton.grab_focus()
