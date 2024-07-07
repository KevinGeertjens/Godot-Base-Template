extends Node

class InputEventKeyConfig:
	var event = InputEventKey.new()
	func _init(params):
		event.keycode = params["keycode"]
	
	func serialize():
		return {"type": "KeyboardButton", "params": {"keycode": event.keycode}}
	
	func as_text():
		return event.as_text()

class InputEventMouseButtonConfig:
	var event = InputEventMouseButton.new()
	func _init(params):
		event.button_index = params["button_index"]
	
	func serialize():
		return {"type": "MouseButton", "params": {"button_index": event.button_index}}
	
	func as_text():
		return event.as_text()

class InputEventJoypadButtonConfig:
	var event = InputEventJoypadButton.new()
	func _init(params):
		event.button_index = params["button_index"]
	
	func serialize():
		return {"type": "JoypadButton", "params": {"button_index": event.button_index}}
	
	func as_text():
		var event_text = event.as_text()
		var return_text = ""
		
		return_text = event_text.split("(")[0].strip_edges()
		return return_text

class InputEventJoypadMotionConfig:
	var event = InputEventJoypadMotion.new()
	func _init(params):
		event.axis = params["axis"]
		event.axis_value = params["axis_value"]
	
	func serialize():
		return {"type": "JoypadMotion", "params": {"axis": event.axis, "axis_value": event.axis_value}}
	
	func as_text():
		var event_text = event.as_text().to_lower()
		var return_text = ""
		
		if "left stick" in event_text:
			return_text += "Left Stick "
		else:
			return_text += "Right Stick "
		
		var axis = event_text.findn("axis", event_text.find("axis") + 1) # Find second occurence of "axis"
		var val = float(event_text.substr(len(event_text) - 5, len(event_text)))
		var direction = "undefined"
		if event_text[axis - 2] == "x":
			direction = "Left"
			if val > 0:
				direction = "Right"
		if event_text[axis - 2] == "y":
			direction = "Up"
			if val > 0:
				direction = "Down"
		
		return_text += direction
		return return_text

var mapping = {
		"KeyboardButton": InputEventKeyConfig,
		"MouseButton": InputEventMouseButtonConfig,
		"JoypadButton": InputEventJoypadButtonConfig,
		"JoypadMotion": InputEventJoypadMotionConfig
	}

var DEFAULT_SETTINGS = {
	"move_left": [
		InputEventKeyConfig.new({"keycode": KEY_A}), 
		InputEventJoypadMotionConfig.new({"axis": JOY_AXIS_LEFT_X, "axis_value": -1.0})],
	"move_right": [
		InputEventKeyConfig.new({"keycode": KEY_D}), 
		InputEventJoypadMotionConfig.new({"axis": JOY_AXIS_LEFT_X, "axis_value": 1.0})],
	"move_up": [
		InputEventKeyConfig.new({"keycode": KEY_W}), 
		InputEventJoypadMotionConfig.new({"axis": JOY_AXIS_LEFT_Y, "axis_value": -1.0})],
	"move_down": [
		InputEventKeyConfig.new({"keycode": KEY_S}), 
		InputEventJoypadMotionConfig.new({"axis": JOY_AXIS_LEFT_Y, "axis_value": 1.0})],
		
	"ui_left": [
		InputEventKeyConfig.new({"keycode": KEY_LEFT}), 
		InputEventJoypadMotionConfig.new({"axis": JOY_AXIS_LEFT_X, "axis_value": -1.0})],
	"ui_right": [
		InputEventKeyConfig.new({"keycode": KEY_RIGHT}), 
		InputEventJoypadMotionConfig.new({"axis": JOY_AXIS_LEFT_X, "axis_value": 1.0})],
	"ui_up": [
		InputEventKeyConfig.new({"keycode": KEY_UP}), 
		InputEventJoypadMotionConfig.new({"axis": JOY_AXIS_LEFT_Y, "axis_value": -1.0})],
	"ui_down": [
		InputEventKeyConfig.new({"keycode": KEY_DOWN}), 
		InputEventJoypadMotionConfig.new({"axis": JOY_AXIS_LEFT_Y, "axis_value": 1.0})],
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

func deserialize(input_event):	
	var new_input_event = mapping[input_event["type"]].new(input_event["params"])
	return new_input_event

func event_to_config(event):	
	var config = null
	
	if event is InputEventKey:
		config = InputEventKeyConfig.new({"keycode": event.keycode})
	if event is InputEventMouseButton:
		config = InputEventMouseButtonConfig.new({"button_index": event.button_index})
	if event is InputEventJoypadButton:
		config = InputEventJoypadButtonConfig.new({"button_index": event.button_index})
	if event is InputEventJoypadMotion:
		config = InputEventJoypadMotionConfig.new({"axis": event.axis, "axis_value": event.axis_value})
	
	return config

func is_same_config(config1, config2):
	var same = false
	
	if config1 is InputEventKeyConfig && config2 is InputEventKeyConfig:
		same = (config1.event.keycode == config2.event.keycode)
	if config1 is InputEventMouseButtonConfig && config2 is InputEventMouseButtonConfig:
		same = (config1.event.button_index == config2.event.button_index)
	if config1 is InputEventJoypadButtonConfig && config2 is InputEventJoypadButtonConfig:
		same = (config1.event.button_index == config2.event.button_index)
	if config1 is InputEventJoypadMotionConfig && config2 is InputEventJoypadMotionConfig:
		same = (config1.event.axis == config2.event.axis && 
				config1.event.axis_value == config2.axis_value)
	
	return same
