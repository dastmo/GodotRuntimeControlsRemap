extends Button
class_name RemapButton


static var current_awaiting_button: RemapButton = null


@export var action: StringName
@export var is_joypad: bool = false


var _is_button_valid: bool = false


func _ready() -> void:
	if ControlsRemap.is_action_remappable(action):
		_is_button_valid = true
		_init_button()
	else:
		printerr("Action with name '%s' is not remappable." % action)


func _init_button() -> void:
	pressed.connect(_on_button_pressed)
	ControlsRemap.control_remapped.connect(_on_control_remapped)
	set_button_text()


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_pressed() or not current_awaiting_button == self:
		return
	
	ControlsRemap.remap_input(action, event)


func _on_button_pressed() -> void:
	if not current_awaiting_button == null:
		current_awaiting_button.set_button_text()
		current_awaiting_button = null
	
	text = "..."
	release_focus()
	current_awaiting_button = self


func set_button_text() -> void:
	for event in InputMap.action_get_events(action):
		if (event is InputEventJoypadButton or event is InputEventJoypadMotion) == is_joypad:
			text = ControlsRemap.get_button_text(event)


func _on_control_remapped(remapped_action: StringName) -> void:
	if remapped_action == action or remapped_action == &"":
		set_button_text()
		current_awaiting_button = null


func _exit_tree() -> void:
	if pressed.is_connected(_on_button_pressed):
		pressed.disconnect(_on_button_pressed)
	
	if ControlsRemap.control_remapped.is_connected(_on_control_remapped):
		ControlsRemap.control_remapped.disconnect(_on_control_remapped)
