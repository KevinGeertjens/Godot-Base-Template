extends Node

class InputEventKeyConfig:
	var event = InputEventKey.new()
	func _init(params):
		event.keycode = params["keycode"]
	
	func serialize():
		return {"type": "KeyboardButton", "params": {"keycode": event.keycode}}

class InputEventJoypadButtonConfig:
	var event = InputEventJoypadButton.new()
	func _init(params):
		event.button_index = params["button_index"]
	
	func serialize():
		return {"type": "JoypadButton", "params": {"button_index": event.button_index}}

class InputEventJoypadMotionConfig:
	var event = InputEventJoypadMotion.new()
	func _init(params):
		event.axis = params["axis"]
		event.axis_value = params["value"]
	
	func serialize():
		return {"type": "JoypadMotion", "params": {"axis": event.axis, "value": event.axis_value}}

func deserialize_input_event(input_event):
	var mapping = {
		"KeyboardButton": InputEventKeyConfig,
		"JoypadButton": InputEventJoypadButtonConfig,
		"JoypadMotion": InputEventJoypadMotionConfig
	}
	
	var new_input_event = mapping[input_event["type"]].new(input_event["params"])
	return new_input_event

const PATH = "user://controls_settings.json" # Path to settings file
var DEFAULT_SETTINGS = {
	"move_left": [
		InputEventKeyConfig.new({"keycode": KEY_A}), 
		InputEventJoypadMotionConfig.new({"axis": JOY_AXIS_LEFT_X, "value": -1.0})],
	"move_right": [
		InputEventKeyConfig.new({"keycode": KEY_D}), 
		InputEventJoypadMotionConfig.new({"axis": JOY_AXIS_LEFT_X, "value": 1.0})],
	"move_up": [
		InputEventKeyConfig.new({"keycode": KEY_W}), 
		InputEventJoypadMotionConfig.new({"axis": JOY_AXIS_LEFT_Y, "value": 1.0})],
	"move_down": [
		InputEventKeyConfig.new({"keycode": KEY_S}), 
		InputEventJoypadMotionConfig.new({"axis": JOY_AXIS_LEFT_Y, "value": -1.0})],
		
	"ui_left": [
		InputEventKeyConfig.new({"keycode": KEY_LEFT}), 
		InputEventJoypadMotionConfig.new({"axis": JOY_AXIS_LEFT_X, "value": -1.0})],
	"ui_right": [
		InputEventKeyConfig.new({"keycode": KEY_RIGHT}), 
		InputEventJoypadMotionConfig.new({"axis": JOY_AXIS_LEFT_X, "value": 1.0})],
	"ui_up": [
		InputEventKeyConfig.new({"keycode": KEY_UP}), 
		InputEventJoypadMotionConfig.new({"axis": JOY_AXIS_LEFT_Y, "value": 1.0})],
	"ui_down": [
		InputEventKeyConfig.new({"keycode": KEY_DOWN}), 
		InputEventJoypadMotionConfig.new({"axis": JOY_AXIS_LEFT_Y, "value": -1.0})],
	"ui_accept": [
		InputEventKeyConfig.new({"keycode": KEY_ENTER}), 
		InputEventJoypadButtonConfig.new({"button_index": JOY_BUTTON_A})],
	"ui_cancel": [
		InputEventKeyConfig.new({"keycode": KEY_ESCAPE}), 
		InputEventJoypadButtonConfig.new({"button_index": JOY_BUTTON_B})],
	"ui_game_menu": [
		InputEventKeyConfig.new({"keycode": KEY_ESCAPE}), 
		InputEventJoypadButtonConfig.new({"button_index": JOY_BUTTON_START})],
}

var _currentSettings = DEFAULT_SETTINGS.duplicate()

func _ready():
	# Try to load settings from file and apply them, otherwise set to default
	var loadedSettings = load_settings()
	if loadedSettings == null:
		apply_default_settings()
	else:
		apply_settings(loadedSettings)

func load_settings():
	# Returns settings saved in .json file, or null if an error occurred
	if !FileAccess.file_exists(PATH):
		return
		
	var file = FileAccess.open(PATH, FileAccess.READ)
	if file != null:
		var json_string = file.get_as_text()
		var loaded_settings = JSON.parse_string(json_string)
		for action in loaded_settings:
			for idx in range(len(loaded_settings[action])):
				loaded_settings[action][idx] = deserialize_input_event(loaded_settings[action][idx])
		
		#print(InputMap.action_get_events("walk_left"))
		#print(InputMap.action_get_events("walk_right"))
		#print(InputMap.action_get_events("walk_up"))
		#print(InputMap.action_get_events("walk_down"))
		return loaded_settings
		
	return null

func _save_settings(newSettings: Dictionary = _currentSettings):
	#Saves the given settings to the .json file
	var serialized_settings = newSettings
	for action in serialized_settings:
		for idx in range(len(serialized_settings[action])):
			serialized_settings[action][idx] = serialized_settings[action][idx].serialize()
	
	var json_string = JSON.stringify(serialized_settings)
	var file = FileAccess.open(PATH, FileAccess.WRITE)
	file.store_string(json_string)
	file.close()

func apply_settings(newSettings: Dictionary):
	for action in newSettings:
		InputMap.action_erase_events(action)
		for input in newSettings[action]:
			InputMap.action_add_event(action, input.event)
	
	_save_settings(newSettings)

func apply_default_settings():
	apply_settings(DEFAULT_SETTINGS)
