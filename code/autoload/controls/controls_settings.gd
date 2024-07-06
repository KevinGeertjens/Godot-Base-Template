extends Node

const PATH = "user://controls_settings.json" # Path to settings file
var _currentSettings = InputEventConfigs.DEFAULT_SETTINGS.duplicate()

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
				loaded_settings[action][idx] = InputEventConfigs.deserialize(loaded_settings[action][idx])
		
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
	apply_settings(InputEventConfigs.DEFAULT_SETTINGS)
