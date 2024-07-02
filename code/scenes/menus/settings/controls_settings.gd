extends MarginContainer

@onready var gameplayOptions = $HBoxContainer/ScrollContainer/MarginContainer/Options/GridContainer
@onready var menuOptions = $HBoxContainer/ScrollContainer/MarginContainer/Options/GridContainer2
var actionMappings = {}

func snake_to_camel_case(snake_str):
	var parts = snake_str.split("_")
	var camel_case_str = parts[0].to_lower()
	for i in range(1, parts.size()):
		camel_case_str += parts[i].capitalize()
	
	return camel_case_str

func _ready():
	var actions = ["move_left", "move_right", "move_up", "move_down",
				   "ui_left", "ui_right", "ui_up", "ui_down", "ui_accept", "ui_cancel", "ui_game_menu"]
	
	for action in actions:
		actionMappings[action] = []
		var base_name = snake_to_camel_case(action)
		var parentControl = gameplayOptions
		if "ui" in action:
			parentControl = menuOptions
		
		for i in range(2):
			var control_name = base_name + "Binding" + str(i+1)
			var node = parentControl.get_node(control_name)
			actionMappings[action].append(node)
	
	_update_bindings()

func _update_bindings():
	var settings = ControlsSettings.load_settings()
	if settings != null:
		for action in settings:
			print(action)
			for i in range(len(settings[action])):
				var input = settings[action][i]
				actionMappings[action][i].text = input.event.as_text()

