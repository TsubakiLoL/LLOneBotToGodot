extends Node
@onready var http_request: HTTPRequest = $HTTPRequest
const REQUEST = preload("res://addons/LLOneBotAPI/http/request.tscn")
var data={
	"group_id":"392470456",
	"message":{
		"type":"text",
		"data":{
			"text":"这是一条测试消息"
		}
		
	}
}
@onready var one_ws: Node = $OneWs
@export var url:String="http://localhost":
	set(val):
		
		pass
@export var port:int=3000
##异步request
func request(url:String,data):
	var new_http:LLOneBotRequest=REQUEST.instantiate()
	add_child(new_http)
	new_http.request(url,[],HTTPClient.METHOD_POST,JSON.stringify(data))
	await new_http.request_finish
	if new_http.result!=HTTPRequest.RESULT_SUCCESS:
		new_http.queue_free()
		return null
	else:
		var str=new_http.body.get_string_from_utf8()
		new_http.queue_free()
		if str!="":
			
			return JSON.parse_string(str)
		else:
			return null
	pass
#通过API发送原始消息
func sent_origin_msg(api:String,data:Dictionary):
	return await request(url+":"+str(port)+"/"+api,data)
	pass
func sent_group_msg(group_id:String,message:Dictionary):
	var mes={
	"group_id":group_id,
	"message":message
	}
	return await sent_origin_msg("send_group_msg",mes)
func sent_private_msg(user_id:String,message:Dictionary):
	var mes={
	"user_id":user_id,
	"message":message
	}
	return await sent_origin_msg("send_private_msg",mes)
	pass
func sent_msg(data:Dictionary):
	sent_origin_msg("send_msg",data)

func get_msg(msg_id:int):
	return await sent_origin_msg("get_msg",{
		"message_id":msg_id
	})
	
	pass
func _ready() -> void:
	
	#http_request.request("http://localhost:3000/send_group_msg",[],HTTPClient.METHOD_POST,JSON.stringify(data))
	one_ws.open_as_client()
	pass
	

func _on_one_ws_message_get(mes: String) -> void:
	print("get_mes:\n"+mes)
	pass # Replace with function body.


func _on_one_ws_connected() -> void:
	print("connected")
	print(await sent_private_msg("3281972412",{
		"type":"text",
		"data":{
			"text":"这是一条测试消息"
		}
		
	}))
	pass # Replace with function body.


func _on_one_ws_closed() -> void:
	print("closed")
	pass # Replace with function body.
