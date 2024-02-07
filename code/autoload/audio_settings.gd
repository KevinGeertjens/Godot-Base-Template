extends Node

var masterBus = AudioServer.get_bus_index("Master")
var musicBus = AudioServer.get_bus_index("Music")
var sfxBus = AudioServer.get_bus_index("SFX")

const PATH = "user://audio_settings.ini" #Path to settings file
const DEFAULT_SETTINGS = {
	"masterVolume" : 100,
	"musicVolume" : 100,
	"sfxVolume" : 100
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
	# Returns settings saved in .ini file, or null if an error occurred
	var file = ConfigFile.new()
	var err = file.load(PATH) #Returns OK if file could load
	
	if err == OK:
		var newSettings = {}
		newSettings["masterVolume"] = file.get_value("audio", "masterVolume", DEFAULT_SETTINGS["masterVolume"])
		newSettings["musicVolume"] = file.get_value("audio", "musicVolume", DEFAULT_SETTINGS["musicVolume"])
		newSettings["sfxVolume"] = file.get_value("audio", "sfxVolume", DEFAULT_SETTINGS["sfxVolume"])
		return newSettings
		
	return null

func _save_settings(newSettings: Dictionary = _currentSettings):
	#Saves the given settings to the .ini file
	var validatedSettings = _validate_settings(newSettings)
	
	var file = ConfigFile.new()
	file.set_value("audio", "masterVolume", validatedSettings["masterVolume"])
	file.set_value("audio", "musicVolume", validatedSettings["musicVolume"])
	file.set_value("audio", "sfxVolume", validatedSettings["sfxVolume"])
	file.save(PATH)

func _validate_settings(settings: Dictionary):
	#Validate parameters, substitute with defaults if not the correct type
	var newSettings = settings.duplicate()
	var expectedTypes = {
		"masterVolume": TYPE_FLOAT,
		"musicVolume": TYPE_FLOAT,
		"sfxVolume": TYPE_FLOAT
	}
	
	for key in expectedTypes.keys():
		if typeof(newSettings[key]) != expectedTypes[key]:
			newSettings[key] = DEFAULT_SETTINGS[key]
	
	return newSettings

func _value_to_db(value: float):
	#Converts value of 0-100 to the corresponding decibel value
	var X = value/100.0
	var Y = pow(X, 1.0/3.0)
	
	var db = remap(Y, 0, 1, -80, 0)
	return db

func apply_settings(newSettings: Dictionary):
	var validatedSettings = _validate_settings(newSettings)
	set_master_volume(validatedSettings["masterVolume"])
	set_music_volume(validatedSettings["musicVolume"])
	set_sfx_volume(validatedSettings["sfxVolume"])

func apply_default_settings():
	apply_settings(DEFAULT_SETTINGS)

func set_master_volume(volume: float):
	AudioServer.set_bus_volume_db(masterBus, _value_to_db(volume))
	_currentSettings["masterVolume"] = volume
	_save_settings()

func set_music_volume(volume: float):
	AudioServer.set_bus_volume_db(musicBus, _value_to_db(volume))
	_currentSettings["musicVolume"] = volume
	_save_settings()

func set_sfx_volume(volume: float):
	AudioServer.set_bus_volume_db(sfxBus, _value_to_db(volume))
	_currentSettings["sfxVolume"] = volume
	_save_settings()
