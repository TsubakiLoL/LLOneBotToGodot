extends HTTPRequest
class_name LLOneBotRequest
var result:int
var response_code:int
var headers:PackedStringArray
var body:PackedByteArray
signal request_finish
func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	self.result=result
	self.response_code=response_code
	self.headers=headers
	self.body=body
	request_finish.emit()
