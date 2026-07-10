@tool
extends EditorPlugin

const SETTING_PATH: String = "addons/Controls Remap/Remappable Actions"
const SETTING_VALUE: Array[StringName] = []
const EVENTS_TEXT_DICTIONARY_PATH: String = "addons/Controls Remap/Events Dictionary"
const EVENTS_DICTIONARY_VALUE: Dictionary[String, String] = {}


func _enable_plugin() -> void:
	if not ProjectSettings.has_setting(SETTING_PATH):
		ProjectSettings.set_setting(SETTING_PATH, SETTING_VALUE)
	
	if not ProjectSettings.has_setting(EVENTS_TEXT_DICTIONARY_PATH):
		ProjectSettings.set_setting(EVENTS_TEXT_DICTIONARY_PATH, EVENTS_DICTIONARY_VALUE)
	
	add_autoload_singleton("ControlsRemap", "res://addons/runtime_controls_remap/controls_remap.gd")


func _disable_plugin() -> void:
	if ProjectSettings.has_setting(SETTING_PATH):
		ProjectSettings.set_setting(SETTING_PATH, null)
	
	if ProjectSettings.has_setting(EVENTS_TEXT_DICTIONARY_PATH):
		ProjectSettings.set_setting(EVENTS_TEXT_DICTIONARY_PATH, null)
	
	remove_autoload_singleton("ControlsRemap")
