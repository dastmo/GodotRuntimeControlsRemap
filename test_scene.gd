extends Node2D


@onready var v_box_container: VBoxContainer = $UILayer/MarginContainer/VBoxContainer


func _ready() -> void:
	for action in ControlsRemap.get_remappable_actions():
		var hbox: HBoxContainer = HBoxContainer.new()
		
		var label: Label = Label.new()
		label.text = ControlsRemap.get_action_text(action)
		hbox.call_deferred("add_child", label)
		
		var keyboard_button: InputRemapButton = InputRemapButton.new()
		keyboard_button.action = action
		keyboard_button.is_joypad = false
		hbox.call_deferred("add_child", keyboard_button)
		
		var joypad_button: InputRemapButton = InputRemapButton.new()
		joypad_button.action = action
		joypad_button.is_joypad = true
		hbox.call_deferred("add_child", joypad_button)
		
		v_box_container.call_deferred("add_child", hbox)
