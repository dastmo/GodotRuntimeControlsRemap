@tool
extends EditorPlugin

const SETTING_PATH: String = "addons/Controls Remap/Remappable Actions"
const SETTING_VALUE: Array[StringName] = [&"ui_up", &"ui_down", &"ui_left", &"ui_right"]


func _enable_plugin() -> void:
	if not ProjectSettings.has_setting(SETTING_PATH):
		ProjectSettings.set_setting(SETTING_PATH, SETTING_VALUE)
	
	add_autoload_singleton("ControlsRemap", "res://addons/runtime_controls_remap/controls_remap.gd")


func _disable_plugin() -> void:
	if ProjectSettings.has_setting(SETTING_PATH):
		ProjectSettings.set_setting(SETTING_PATH, null)
	
	remove_autoload_singleton("ControlsRemap")


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	pass


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass
