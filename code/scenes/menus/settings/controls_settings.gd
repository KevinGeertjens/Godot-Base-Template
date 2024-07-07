extends MarginContainer

@onready var gameplayOptions = $HBoxContainer/ScrollContainer/MarginContainer/Options/GridContainer
@onready var menuOptions = $HBoxContainer/ScrollContainer/MarginContainer/Options/GridContainer2
@onready var bindingChangePopup = $BindingChangePopup
@onready var scrollContainer = $HBoxContainer/ScrollContainer

var actionMappings = {}
var actions = ["move_left", "move_right", "move_up", "move_down",
			   "ui_left", "ui_right", "ui_up", "ui_down", "ui_accept", "ui_cancel", "ui_game_menu"]
var mappingInitialized = false

# N frames to disable input for to prevent bouncing from the bindingChangePopup
var inputDebounce = 0 

func _snake_to_camel_case(snake_str):
	var parts = snake_str.split("_")
	var camel_case_str = parts[0].to_lower()
	for i in range(1, parts.size()):
		camel_case_str += parts[i].capitalize()
	
	return camel_case_str

func _ready():	
	for action in actions:
		actionMappings[action] = []
		var base_name = _snake_to_camel_case(action)
		var parentControl = gameplayOptions
		if "ui" in action:
			parentControl = menuOptions
		
		for i in range(2):
			var control_name = base_name + "Binding" + str(i+1)
			var node = parentControl.get_node(control_name)
			actionMappings[action].append(node)
	
	mappingInitialized = true
	
	_update_bindings()
	_connect_buttons_to_popup()

func _process(delta):
	if inputDebounce > 0:
		inputDebounce -= 1

func _update_bindings():
	var settings = ControlsSettings.load_settings()
	if settings != null:
		for action in settings:
			if action in actionMappings:
				for i in range(len(settings[action])):
					var input = settings[action][i]
					actionMappings[action][i].text = input.as_text()

func _connect_buttons_to_popup():
	# Connect all binding buttons to the BindingChangePopup
	for action in actions:
		for i in range(2):
			actionMappings[action][i].connect("pressed", _on_binding_button_pressed.bind(action, i))

func _on_binding_button_pressed(action, index):
	if inputDebounce <= 0:
		bindingChangePopup.selectedAction = action
		bindingChangePopup.index = index
		bindingChangePopup.visible = true

func _on_binding_change_popup_visibility_changed():
	_update_bindings()
	
	for action in actions:
		for i in range(2):
			if action in actionMappings:
				actionMappings[action][i].disabled = bindingChangePopup.visible
	
	if !bindingChangePopup.visible:
		inputDebounce = 10

func _on_move_up_binding_1_focus_entered():
	scrollContainer.scroll_vertical = 0

func _on_move_up_binding_2_focus_entered():
	scrollContainer.scroll_vertical = 0
