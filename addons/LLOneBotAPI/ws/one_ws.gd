extends Node
##当前ws使用的端口
@export var port:int=3002
##当前ws作为客户端去连接的NTqq的one bot地址
@export var connect_address:String="127.0.0.1"
##是否开启心跳包验证超时
@export var heart_beat_open:bool=true
##连接过期心跳包时间间隔
@export var heart_beat_time:float=70
var ws_client:WebSocketPeer
var connection_list:Array[WebSocketPeer]=[]

var before_ws_state:WebSocketPeer.State=WebSocketPeer.STATE_CLOSED
@onready var heart_beat_timer: Timer = $heart_beat_timer

signal connected
signal closed
signal message_get(mes:String)
func _ready() -> void:
	
	set_process(false)
	pass
func _process(delta: float) -> void:
	
	
	
	if ws_client:
		ws_client.poll()
		var state = ws_client.get_ready_state()
		
		if state == WebSocketPeer.STATE_OPEN:
			if before_ws_state!=WebSocketPeer.STATE_OPEN:
				if heart_beat_open:
					heart_beat_timer.start(heart_beat_time)
				connected.emit()
				pass
			while ws_client.get_available_packet_count():
				var packet=ws_client.get_packet()
				var str=packet.get_string_from_utf8()
				
				if str!="":
					if not is_str_heart_beat(str):
						message_get.emit(str)
					if heart_beat_open:
						heart_beat_timer.stop()
						heart_beat_timer.start(heart_beat_time)
		elif state == WebSocketPeer.STATE_CLOSING:
			# 继续轮询才能正确关闭。
			pass
		elif state == WebSocketPeer.STATE_CLOSED:
			var code = ws_client.get_close_code()
			var reason = ws_client.get_close_reason()
			print("WebSocket 已关闭，代码：%d，原因 %s。干净得体：%s" % [code, reason, code != -1])
			set_process(false) # 停止处理
			ws_client.connect_to_url(connect_address+":"+str(port))

		before_ws_state=state
		pass

func open_as_client():
	heart_beat_timer.wait_time=heart_beat_time
	ws_client=WebSocketPeer.new()
	ws_client.connect_to_url(connect_address+":"+str(port))
	set_process(true)
	pass
	
func is_str_heart_beat(str:String)->bool:
	var json=JSON.parse_string(str)
	if not json is Dictionary:
		
		return false
	if json.has("meta_event_type") and json["meta_event_type"]=="heartbeat":
		return true
	else:
		return false
	pass

func _on_heart_beat_timer_timeout() -> void:
	if ws_client:
		ws_client.close(-1)
	pass # Replace with function body.
