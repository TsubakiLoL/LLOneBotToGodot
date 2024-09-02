@tool
extends VBoxContainer
const ITEM_MONO = preload("./item_mono.tscn")
var data:Dictionary={}
var default_data:Dictionary={
	"HTTP地址":"127.0.0.1",
	"HTTP端口":3000,
	"正向Websocket地址":"127.0.0.1",
	"正向Websocket端口":3002,
}
@onready var add_pos: VBoxContainer =$add

var config_json_file_path:String
const CONFIG = preload("../config/config.json")

func _ready() -> void:
	config_json_file_path=CONFIG.resource_path
	load_json(config_json_file_path)
	
func load_json(path:String):
	var file=FileAccess.open(path,FileAccess.READ)
	if file!=null:
		data=JSON.parse_string(file.get_as_text())
		file.close()
		pass
	else:
		data=default_data
		save_data(config_json_file_path)
		pass
	for i in add_pos.get_children():
		i.queue_free()
	for i in data.keys():
		var new_item=ITEM_MONO.instantiate()
		
		add_pos.add_child(new_item)
		new_item.value_changed.connect(value_changed)
		new_item.set_item(i,data[i])
	pass
func save_data(path:String):
	var file=FileAccess.open(path,FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()
	
	pass
func create_item_by_data():
	for i in add_pos.get_children():
		i.queue_free()
	for i in data.keys():
		var new_item=ITEM_MONO.instantiate()
		
		add_pos.add_child(new_item)
		new_item.value_changed.connect(value_changed)
		new_item.set_item(i,data[i])
func value_changed(n:String,v):
	
	data[n]=v
	save_data(config_json_file_path)
	
	pass


func _on_refresh_pressed() -> void:
	load_json(config_json_file_path)
	pass # Replace with function body.


func _on_default_pressed() -> void:
	data=default_data
	save_data(config_json_file_path)
	create_item_by_data()
	pass # Replace with function body.
