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
		event.axis_value = params["value"]
	
	func serialize():
		return {"type": "JoypadMotion", "params": {"axis": event.axis, "value": event.axis_value}}
	
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
			direction = "Down"
			if val > 0:
				direction = "Up"
		
		return_text += direction
		return return_text

func deserialize(input_event):
	var mapping = {
		"KeyboardButton": InputEventKeyConfig,
		"MouseButton": InputEventMouseButtonConfig,
		"JoypadButton": InputEventJoypadButtonConfig,
		"JoypadMotion": InputEventJoypadMotionConfig
	}
	
	var new_input_event = mapping[input_event["type"]].new(input_event["params"])
	return new_input_event

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
