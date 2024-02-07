extends MarginContainer

@onready var windowSizeButton = $HBoxContainer/GridContainer/WindowSizeButton
@onready var windowModeButton = $HBoxContainer/GridContainer/WindowModeButton
@onready var monitorButton = $HBoxContainer/GridContainer/MonitorButton
@onready var vsyncButton = $HBoxContainer/GridContainer/VsyncButton

const windowModeMap = {
	GraphicsSettings.window_modes.FULLSCREEN: "Fullscreen",
	GraphicsSettings.window_modes.BORDERLESS_WINDOW: "Borderless Window",
	GraphicsSettings.window_modes.WINDOWED: "Windowed"
}

func _ready():
	# Populate monitor button with number of monitors
	var monitorCount = DisplayServer.get_screen_count()
	for x in monitorCount:
		monitorButton.add_item(str(x))
	
	# Populate window mode button with modes
	for mode in windowModeMap:
		windowModeButton.add_item(windowModeMap[mode])
	
	_update_buttons()

func _update_buttons():
	#Updates all buttons' values
	_update_window_size_button()
	_update_window_mode_button()
	_update_vsync_button()
	_update_monitor_button()

func _update_window_size_button():
	var window_size = GraphicsSettings.currentSettings['window_size']
	var string = str(window_size.x) + "x" + str(window_size.y)
	for i in windowSizeButton.item_count:
		if windowSizeButton.get_item_text(i) == string:
			windowSizeButton.select(i)
			
	if GraphicsSettings.currentSettings['window_mode'] == GraphicsSettings.window_modes.FULLSCREEN:
		windowSizeButton.disabled = true
	else:
		windowSizeButton.disabled = false

func _update_window_mode_button():
	var value = windowModeMap[GraphicsSettings.currentSettings['window_mode']]
	for i in windowModeButton.item_count:
		if windowModeButton.get_item_text(i) == value:
			windowModeButton.select(i)

func _update_vsync_button():
	var vsyncEnabled = DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_ENABLED
	vsyncButton.set_pressed_no_signal(vsyncEnabled)

func _update_monitor_button():
	var currentMonitor = DisplayServer.window_get_current_screen()
	for i in monitorButton.item_count:
		if monitorButton.get_item_text(i) == str(currentMonitor):
			monitorButton.select(i)


func _on_window_size_button_item_selected(index):
	var splitWindowSize = windowSizeButton.get_item_text(index).split("x")
	var newWindowSize = Vector2(int(splitWindowSize[0]), int(splitWindowSize[1]))
	GraphicsSettings.set_window_size(newWindowSize)
	_update_buttons()

func _on_fullscreen_button_toggled(toggled_on):
	GraphicsSettings.set_fullscreen(toggled_on)
	_update_buttons()

func _on_window_mode_button_item_selected(index):
	var buttonValue = windowModeButton.get_item_text(index)
	var windowMode = GraphicsSettings.window_modes.FULLSCREEN # Default to fullscreen
	
	for mode in windowModeMap:
		if windowModeMap[mode] == buttonValue:
			windowMode = mode
	
	GraphicsSettings.set_window_mode(windowMode)
	_update_buttons()

func _on_monitor_button_item_selected(index):
	GraphicsSettings.set_monitor(index)
	_update_buttons()

func _on_vsync_button_toggled(toggled_on):
	GraphicsSettings.set_vsync(toggled_on)
	_update_buttons()

func _on_default_button_pressed():
	GraphicsSettings.apply_default_settings()
	_update_buttons()
