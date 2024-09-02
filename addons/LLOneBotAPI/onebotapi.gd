@tool
extends EditorPlugin
var dock:Control
const SIDE = preload("./side/side.tscn")
func _enter_tree() -> void:
	main_panel_instance = MainPanel.instantiate()
	# Add the main panel to the editor's main viewport.
	EditorInterface.get_editor_main_screen().add_child(main_panel_instance)
	# Hide the main panel. Very much required.
	_make_visible(false)
	side_instance=SIDE.instantiate()
	add_control_to_dock(DOCK_SLOT_RIGHT_BL,side_instance)
	
	# Initialization of the plugin goes here.
	pass

const MainPanel = preload("./dock/dock.tscn")

var main_panel_instance
var side_instance
func _exit_tree() -> void:
	if main_panel_instance:
		main_panel_instance.queue_free()
	if side_instance:
		remove_control_from_docks(side_instance)
		side_instance.queue_free()
	# Clean-up of the plugin goes here.
	pass
func _has_main_screen():
	return true


func _make_visible(visible):
	if main_panel_instance:
		main_panel_instance.visible = visible


func _get_plugin_name():
	return "LLOneBotAPI插件文档"


func _get_plugin_icon():
	return EditorInterface.get_editor_theme().get_icon("Node", "EditorIcons")
