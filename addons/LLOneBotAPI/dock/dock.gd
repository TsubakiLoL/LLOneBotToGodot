extends Control
@onready var http_request: HTTPRequest = $HTTPRequest

func _ready() -> void:
	var data={
		"group_id":"392470456",
		"message":[{
			"type":"text",
			"data":{
				"text":"测试"
			}
		}]
	}
	http_request.request("http://localhost:3000/send_group_msg",[],HTTPClient.METHOD_POST,JSON.stringify(data))
	
	pass
