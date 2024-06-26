extends MarginContainer

@onready var tabContainer = $HBoxContainer/Tabs

func _ready():
	tabContainer.get_tab_bar().z_index = 10 # Fixes border of tabs displaying underneath its child panel

func _process(delta):
	pass
