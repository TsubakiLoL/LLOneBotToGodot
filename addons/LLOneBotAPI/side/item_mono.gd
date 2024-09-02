@tool
extends HBoxContainer

var n:String
var t:type=type.STRING
var v=null
signal value_changed(n:String,value)
enum type{
	STRING=0,
	NUM=1
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func set_item(n:String,v):
	if v is String:
		t=type.STRING
	else:
		t=type.NUM
	%n.text=n
	self.n=n
	self.v=v
	%v.text=str(v)
	
	pass


func _on_v_text_submitted(new_text: String) -> void:
	match t:
		type.STRING:
			%v.text=new_text
			v=new_text
			value_changed.emit(n,new_text)
		type.NUM:
			if new_text.is_valid_float():
				v=float(new_text)
				%v.text=str(v)
				value_changed.emit(n,v)
				pass
			else:
				%v.text=str(v)
			
			pass
		
		
	pass # Replace with function body.


func _on_v_focus_exited() -> void:
	_on_v_text_submitted(%v.text)
	pass # Replace with function body.
