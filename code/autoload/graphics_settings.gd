extends Node

enum window_modes {FULLSCREEN, BORDERLESS_WINDOW, WINDOWED}

const PATH = "user://graphics_settings.ini"
const DEFAULT_SETTINGS = {
	"window_mode": window_modes.FULLSCREEN,
	"vsync" : true,
	"window_size" : Vector2(1920, 1080),
	"monitor": 0
}

var currentSettings = DEFAULT_SETTINGS.duplicate()

func _ready():
	var loadedSettings = _load_settings() # Attempt to load settings from file
	if loadedSettings == null:
		apply_default_settings()
	else:
		apply_settings(loadedSettings)

func _load_settings():
	# Return loaded settings, or null if non-existent or corrupt
	var file = ConfigFile.new()
	var err = file.load(PATH) # Returns OK if file loaded correctly
	
	if err == OK:
		var newSettings = {}
		newSettings['window_size'] = file.get_value('graphics', 'window_size', DEFAULT_SETTINGS['window_size'])
		newSettings['window_mode'] = file.get_value('graphics', 'window_mode', DEFAULT_SETTINGS['window_mode'])
		newSettings['monitor'] = file.get_value('graphics', 'monitor', DEFAULT_SETTINGS['monitor'])
		newSettings['vsync'] = file.get_value('graphics', 'vsync', DEFAULT_SETTINGS['vsync'])
		return newSettings
		
	return null

func _save_settings(newSettings: Dictionary = currentSettings):
	var validatedSettings = _validate_settings(newSettings)
	
	var file = ConfigFile.new()
	file.set_value("graphics", "window_size", validatedSettings["window_size"])
	file.set_value("graphics", "window_mode", validatedSettings["window_mode"])
	file.set_value("graphics", "vsync", validatedSettings["vsync"])
	file.set_value("graphics", "monitor", validatedSettings["monitor"])
	file.save(PATH)

func _validate_settings(settings: Dictionary):
	#Validate parameters, substitute with defaults if not the correct type
	var newSettings = settings.duplicate()
	var expectedTypes = {
		"window_mode": TYPE_INT,
		"vsync": TYPE_BOOL,
		"window_size": TYPE_VECTOR2,
		"monitor": TYPE_INT
	}
	
	for key in expectedTypes.keys():
		if typeof(newSettings[key]) != expectedTypes[key]:
			newSettings[key] = DEFAULT_SETTINGS[key]
	
	return newSettings

func apply_settings(newSettings: Dictionary):
	var validatedSettings = _validate_settings(newSettings)
	set_window_size(validatedSettings['window_size'])
	set_window_mode(validatedSettings['window_mode'])
	set_monitor(validatedSettings['monitor'])
	set_vsync(validatedSettings['vsync'])
	
func apply_default_settings():
	apply_settings(DEFAULT_SETTINGS)
	
func set_window_mode(window_mode: int):
	var fullscreenValue
	var borderlessValue
	
	match window_mode:
		window_modes.FULLSCREEN:
			fullscreenValue = DisplayServer.WINDOW_MODE_FULLSCREEN
			borderlessValue = false
		window_modes.BORDERLESS_WINDOW:
			fullscreenValue = DisplayServer.WINDOW_MODE_WINDOWED
			borderlessValue = true
		window_modes.WINDOWED:
			fullscreenValue = DisplayServer.WINDOW_MODE_WINDOWED
			borderlessValue = false
			
	DisplayServer.window_set_mode(fullscreenValue)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, borderlessValue)

	currentSettings["window_mode"] = window_mode
	_save_settings()
	DisplayServer.window_set_current_screen(currentSettings["monitor"])

func set_vsync(vsync: bool):
	var vsyncValue = {
		false: DisplayServer.VSYNC_DISABLED,
		true: DisplayServer.VSYNC_ENABLED
	}[vsync]
	DisplayServer.window_set_vsync_mode(vsyncValue)
	currentSettings["vsync"] = vsync
	_save_settings()

func set_window_size(window_size: Vector2):
	DisplayServer.window_set_size(window_size)
	currentSettings["window_size"] = window_size
	_save_settings()
	
	#Center window after size change
	var offset = (DisplayServer.screen_get_size() - DisplayServer.window_get_size()) / 2
	DisplayServer.window_set_position(offset)
	DisplayServer.window_set_current_screen(currentSettings["monitor"])

func set_monitor(index: int):
	DisplayServer.window_set_current_screen(index)
	currentSettings["monitor"] = index
	_save_settings()
