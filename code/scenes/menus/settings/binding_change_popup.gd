extends Panel

@onready var selectedActionLabel = $Margin/CenterContainer/VBoxContainer/SelectedAction
var selectedAction = "undefined"
var index = 0

var acceptedEvents = [InputEventKey.new(), InputEventMouseButton.new(), 
					  InputEventJoypadButton.new(), InputEventJoypadMotion.new()]

func _on_visibility_changed():
	var actionText = selectedAction.replace("_", " ")
	var words = actionText.split(" ")
	for i in range(words.size()):
		words[i] = words[i].capitalize()
	
	actionText = " ".join(words)
	selectedActionLabel.text = "Change binding for:  " + actionText

func _input(event):
	if visible:
		var event_string = event.to_string().split(":")[0]
		for acceptedEvent in acceptedEvents:
			var check_string = acceptedEvent.to_string().split(":")[0]
			if event_string == check_string:
				var eventConfig = InputEventConfigs.event_to_config(event)
				var newSettings = ControlsSettings.currentSettings
				newSettings[selectedAction][index] = eventConfig
				ControlsSettings.apply_settings(newSettings)
				hide()
