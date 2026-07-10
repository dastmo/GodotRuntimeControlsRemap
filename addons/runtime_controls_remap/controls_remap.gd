extends Node


var _default_controls: Dictionary[StringName, Array] = {}
var _customized_controls: Dictionary[StringName, Array] = {}
var _file_path: String = "user://custom_controls.dat"


func _enter_tree() -> void:
	_record_default_controls()
	_load_customized_controls()


func _record_default_controls() -> void:
	for action in InputMap.get_actions():
		if OS.has_feature("editor"):
			_default_controls[action] = ProjectSettings.get_setting("input/%s" % action)["events"]
		else:
			_default_controls[action] = InputMap.action_get_events(action)


func _load_customized_controls() -> void:
	if not FileAccess.file_exists(_file_path):
		return
	
	var file = FileAccess.open(_file_path, FileAccess.READ)
	
	if file == null:
		print(file.get_open_error())
		return
	
	_customized_controls = file.get_var(true)
	file.close()


func _save_cutomized_controls() -> void:
	var file = FileAccess.open(_file_path, FileAccess.WRITE)
	file.store_var(_customized_controls, true)
	file.close()


func remap_input(action: StringName, event: InputEvent) -> void:
	if (event is InputEventKey) or (event is InputEventMouseButton):
		remap_keyboard_input(action, event)
	elif event is InputEventJoypadButton:
		remap_joypad_input(action, event)


func remap_keyboard_input(action: StringName, event: InputEvent) -> void:
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


func remap_joypad_input(action: StringName, event: InputEvent) -> void:
	for old_event in InputMap.action_get_events(action):
		if old_event is InputEventJoypadButton:
			InputMap.action_erase_event(action, old_event)
			InputMap.action_add_event(action, event)
			
			if _customized_controls.has(action):
				_customized_controls[action].erase(old_event)
				_customized_controls[action].append(event)
			else:
				_customized_controls[action] = [event]
			
			break
	_save_cutomized_controls()
