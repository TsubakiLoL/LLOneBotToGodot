extends Node
const REQUEST = preload("res://addons/LLOneBotAPI/http/request.tscn")

@onready var one_ws: Node = $OneWs
@export var url:String="http://localhost"
@export var port:int=3000
@export var ws_url:String="http://localhost":
	set(val):
		ws_url=val
		one_ws.connect_address=val
@export var ws_port:int=3002:
	set(val):
		ws_port=val
		one_ws.port=ws_port
		
signal ws_connected

signal  ws_closed

##异步request
func request(url:String,data):
	print(url)
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
			print(str)
			return JSON.parse_string(str)
		else:
			return null
	pass
#通过API发送原始消息
func send_origin_msg(api:String,data:Dictionary):
	return await request(url+":"+str(port)+"/"+api,data)
	pass
#发送群组消息
#响应数据:
#message_id	int32	消息 ID
func send_group_msg(group_id:String,message:LLOneBotMsg):
	var mes={
	"group_id":group_id,
	"message":message.contain_data
	}
	return await send_origin_msg("send_group_msg",mes)
#发送私聊消息
#响应数据:
#message_id	int32	消息 ID
func send_private_msg(user_id:String,message:LLOneBotMsg):
	var mes={
	"user_id":user_id,
	"message":message.contain_data
	}
	return await send_origin_msg("send_private_msg",mes)
	pass
#发送消息
#响应数据:
#message_id	int32	消息 ID
func send_msg(data:Dictionary):
	send_origin_msg("send_msg",data)
#获取消息
#响应数据:
#group	bool	是否是群消息
#group_id	int64	是群消息时的群号(否则不存在此字段)
#message_id	int32	消息id
#real_id	int32	消息真实id
#message_type	string	群消息时为group, 私聊消息为private
#sender	object	发送者
#time	int32	发送时间
#message	message	消息内容
#raw_message	message	原始消息内容
#其中sender：
#	nickname	string	发送者昵称
#	user_id	int64	发送者 QQ 号
func get_msg(msg_id:int):
	return await send_origin_msg("get_msg",{
		"message_id":msg_id
	})

#撤回消息
func delete_msg(msg_id:int):
	return await send_origin_msg("delete_msg",{
		"message_id":msg_id
	})
#获取合并转发消息
#响应示例：
#{
	#"data": {
		#"messages": [
			#{
				#"content": "合并转发1",
				#"sender": {
					#"nickname": "发送者A",
					#"user_id": 10086
				#},
				#"time": 1595694374
			#},
			#{
				#"content": "合并转发2[CQ:image,file=xxxx,url=xxxx]",
				#"sender": {
					#"nickname": "发送者B",
					#"user_id": 10087
				#},
				#"time": 1595694393
			#}
		#]
	#},
	#"retcode": 0,
	#"status": "ok"
#}
func get_forward_msg(msg_id:int):
	return await send_origin_msg("get_forward_msg",{
		"message_id":msg_id
	})
#标记消息已读
func mark_msg_as_read(msg_id:int):
	return await send_origin_msg("mark_msg_as_read",{
		"message_id":msg_id
	})
#发送合并转发(群聊)
#响应数据:
#message_id	int64	消息 ID
#forward_id	string	转发消息 ID
func send_group_forward_msg(group_id:String,messages):
	var mes={
		
		"group_id":group_id,
		"messages":messages
	}
	return await send_origin_msg("send_group_forward_msg",mes)
#发送合并转发(私聊)
#响应数据:
#message_id	int64	消息 ID
#forward_id	string	转发消息 ID
func send_private_forward_msg(user_id:String,messages):
	var mes={
		
		"user_id":user_id,
		"messages":messages
	}
	return await send_origin_msg("send_private_forward_msg",mes)
#获取群历史消息，缺省开始ID则获取最新
#响应数据：
#messages	Message[]	从起始序号开始的前19条消息
func get_group_msg_history(group_id:String,message_seq:String=""):
	
	var mes={
		
		"group_id":group_id
	}
	if message_seq!="":
		mes["message_seq"]=message_seq
	return await send_origin_msg("get_group_msg_history",mes)
	pass

const CONFIG = preload("res://addons/LLOneBotAPI/config/config.json")
func _ready() -> void:
	url=CONFIG.data["HTTP地址"]
	port=CONFIG.data["HTTP端口"]
	ws_url=CONFIG.data["正向Websocket地址"]
	ws_port=CONFIG.data["正向Websocket端口"]
	print(port)
	open()
	pass
func open():
	one_ws.open()
func post_mes(mes:String):
	var json=JSON.parse_string(mes)
	if json==null:
		return
		
	if json is Dictionary and json.has("type") and json.has("message"):
		
		
		var type=json["type"]
		var message_arr=[]
		if json["message"] is Dictionary:
			message_arr.append(json["message"])
		elif json["message"] is Array:
			for i in json["message"]:
				
				
				pass
			
			pass
		match type:
				
				
			_:
				
				pass
				
				pass
		
		pass
	pass
func _on_one_ws_message_get(mes: String) -> void:
	print("get_mes:\n"+mes)
	
	
	pass # Replace with function body.


func _on_one_ws_connected() -> void:
	print("connected")
	ws_connected.emit()
	#send_private_msg("3572790646",{
		#"type":"text",
		#"data":{
			#"text":"这是一条来自Godot发送的消息"
		#}
	#})
	await get_tree().create_timer(1).timeout
	send_group_msg("392470456",LLOneBotMsg.create_text_msg("这是一条测试消息"))
	pass # Replace with function body.


func _on_one_ws_closed() -> void:
	print("closed")
	ws_closed.emit()
	pass # Replace with function body.
