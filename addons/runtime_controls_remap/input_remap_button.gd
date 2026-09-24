extends Button
class_name InputRemapButton


static var current_awaiting_button: InputRemapButton = null


@export var action: StringName
@export var is_joypad: bool = false
@export var awaiting_input_text: String = "..."
@export var init_button_on_ready: bool = true


var _is_button_valid: bool = false


func _ready() -> void:
	if init_button_on_ready:
		_init_button()


func _init_button() -> void:
	if ControlsRemap.is_action_remappable(action):
		_is_button_valid = true
	else:
		printerr("Action with name '%s' is not remappable." % action)
		return
	
	pressed.connect(_on_button_pressed)
	ControlsRemap.control_remapped.connect(_on_control_remapped)
	set_button_text()


func _input(event: InputEvent) -> void:
	if not event.is_pressed() or not current_awaiting_button == self:
		return
	
	ControlsRemap.remap_input(action, event)


func _on_button_pressed() -> void:
	if not current_awaiting_button == null:
		current_awaiting_button.set_button_text()
		current_awaiting_button = null
	
	text = awaiting_input_text
	release_focus()
	disabled = true
	current_awaiting_button = self


func set_button_text() -> void:
	for event in InputMap.action_get_events(action):
		if (event is InputEventJoypadButton or event is InputEventJoypadMotion) == is_joypad:
			text = ControlsRemap.get_button_text(event)


func _on_control_remapped(remapped_action: StringName) -> void:
	if remapped_action == action or remapped_action == &"":
		set_button_text()
		current_awaiting_button = null
	
	if disabled:
		await get_tree().process_frame
		disabled = false


func _exit_tree() -> void:
	if pressed.is_connected(_on_button_pressed):
		pressed.disconnect(_on_button_pressed)
	
	if ControlsRemap.control_remapped.is_connected(_on_control_remapped):
		ControlsRemap.control_remapped.disconnect(_on_control_remapped)
