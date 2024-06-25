extends MarginContainer

@onready var masterVolumeSlider = $HBoxContainer/GridContainer/MasterVolumeSlider
@onready var musicVolumeSlider = $HBoxContainer/GridContainer/MusicVolumeSlider
@onready var sfxVolumeSlider = $HBoxContainer/GridContainer/SfxVolumeSlider

@onready var masterVolumeVal = $HBoxContainer/GridContainer/MasterVolumeVal
@onready var musicVolumeVal = $HBoxContainer/GridContainer/MusicVolumeVal
@onready var sfxVolumeVal = $HBoxContainer/GridContainer/SfxVolumeVal

func _ready():
	_update_sliders()

func _update_sliders():
	var settings = AudioSettings.load_settings()
	if settings != null:
		masterVolumeSlider.set_value_no_signal(settings["masterVolume"])
		musicVolumeSlider.set_value_no_signal(settings["musicVolume"])
		sfxVolumeSlider.set_value_no_signal(settings["sfxVolume"])
		
		masterVolumeVal.text = str(settings["masterVolume"])
		musicVolumeVal.text = str(settings["musicVolume"])
		sfxVolumeVal.text = str(settings["sfxVolume"])

func _on_master_volume_slider_value_changed(value):
	AudioSettings.set_master_volume(value)
	_update_sliders()

func _on_music_volume_slider_value_changed(value):
	AudioSettings.set_music_volume(value)
	_update_sliders()

func _on_sfx_volume_slider_value_changed(value):
	AudioSettings.set_sfx_volume(value)
	_update_sliders()

func _on_default_button_pressed():
	AudioSettings.apply_default_settings()
	_update_sliders()
