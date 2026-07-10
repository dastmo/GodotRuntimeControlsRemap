extends Node


const SETTING_PATH: String = "addons/Controls Remap/Remappable Actions"
const EVENTS_TEXT_DICTIONARY_PATH: String = "addons/Controls Remap/Events Dictionary"
const ACTIONS_TEXT_DICTIONARY_PATH: String = "addons/Controls Remap/Action Names Dictionary"


var _action_remap_requested: StringName = &""


var _default_controls: Dictionary[StringName, Array] = {}
var _customized_controls: Dictionary[StringName, Array] = {}
var _file_path: String = "user://custom_controls.dat"


signal control_remapped(action: StringName)


func _enter_tree() -> void:
	_record_default_controls()
	_load_customized_controls()
	_validate_customized_controls()
	
	for action in _customized_controls:
		InputMap.action_erase_events(action)
		for event in _customized_controls[action]:
			InputMap.action_add_event(action, event)


func _record_default_controls() -> void:
	for action in InputMap.get_actions():
		if not ProjectSettings.get_setting(SETTING_PATH).has(action):
			continue
		
		if OS.has_feature("editor"):
			_default_controls[action] = ProjectSettings.get_setting("input/%s" % action)["events"]
		else:
			_default_controls[action] = InputMap.action_get_events(action)


func _load_customized_controls() -> void:
	if not FileAccess.file_exists(_file_path):
		return
	
	var file = FileAccess.open(_file_path, FileAccess.READ)
	
	if file == null:
		printerr(file.get_open_error())
		return
	
	_customized_controls = file.get_var(true)
	file.close()
	
	control_remapped.emit(&"")


func _validate_customized_controls() -> void:
	for action in _customized_controls:
		if not InputMap.has_action(action):
			_customized_controls.clear()
			return


func _save_cutomized_controls() -> void:
	var file = FileAccess.open(_file_path, FileAccess.WRITE)
	file.store_var(_customized_controls, true)
	file.close()


func remap_input(action: StringName, event: InputEvent) -> void:
	if (event is InputEventKey) or (event is InputEventMouseButton):
		_remap_keyboard_input(action, event)
	elif (event is InputEventJoypadButton) or (event is InputEventJoypadMotion):
		_remap_joypad_input(action, event)
	
	control_remapped.emit(action)
	_action_remap_requested = &""


func _remap_keyboard_input(action: StringName, event: InputEvent) -> void:
	for old_event in InputMap.action_get_events(action):
		if (old_event is InputEventKey) or (old_event is InputEventMouseButton):
			InputMap.action_erase_event(action, old_event)
			InputMap.action_add_event(action, event)
			
			if _customized_controls.has(action):
				_customized_controls[action].erase(old_event)
				_customized_controls[action].append(event)
			else:
				_customized_controls[action] = [event]
			
			break
	_save_cutomized_controls()


func _remap_joypad_input(action: StringName, event: InputEvent) -> void:
	for old_event in InputMap.action_get_events(action):
		if (old_event is InputEventJoypadButton) or (old_event is InputEventJoypadMotion):
			InputMap.action_erase_event(action, old_event)
			InputMap.action_add_event(action, event)
			
			if _customized_controls.has(action):
				_customized_controls[action].erase(old_event)
				_customized_controls[action].append(event)
			else:
				_customized_controls[action] = [event]
			
			break
	_save_cutomized_controls()


func _restore_all_default_inputs() -> void:
	for action in ProjectSettings.get_setting(SETTING_PATH):
		_restore_default_input(action, false)
	
	_save_cutomized_controls()


func _restore_default_input(action: StringName, save_controls: bool = true) -> void:
	if _customized_controls.has(action):
		_customized_controls.erase(action)
	
	for event in InputMap.action_get_events(action):
		InputMap.action_erase_event(action, event)
	
	for event in _default_controls[action]:
		InputMap.action_add_event(action, event)
	
	if save_controls:
		_save_cutomized_controls()


func is_action_remappable(action: StringName) -> bool:
	return ProjectSettings.get_setting(SETTING_PATH).has(action)


func get_button_text(event: InputEvent) -> String:
	var dict: Dictionary = ProjectSettings.get_setting(EVENTS_TEXT_DICTIONARY_PATH)
	if dict.has(event.as_text()):
		return dict[event.as_text()]
	else:
		return event.as_text()


func get_action_text(action: StringName) -> String:
	var dict: Dictionary = ProjectSettings.get_setting(ACTIONS_TEXT_DICTIONARY_PATH)
	if dict.has(action):
		return dict[action]
	else:
		return action


func get_remappable_actions() -> Array:
	return ProjectSettings.get_setting(SETTING_PATH)
