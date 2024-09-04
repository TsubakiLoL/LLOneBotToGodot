##接口消息类
class_name LLOneBotMsg
##持有的消息本体数据队列
var contain_data=[]
##消息类型
enum MSG_TYPE{
	TEXT=0,
	IMAGE=1,
	FACE=2
}
##构造空的消息
static func create_empty_msg():
	return LLOneBotMsg.new()
##从文本构建消息
static func create_text_msg(text:String):
	var new_msg=LLOneBotMsg.new()
	new_msg.append_text(text)
	return new_msg
##从图片构建消息
static func create_image_msg(file_path:String):
	var new_msg=LLOneBotMsg.new()
	new_msg.append_image(file_path)
	return new_msg
##从表情构建消息
static func create_face_msg(id:String):
	var new_msg=LLOneBotMsg.new()
	new_msg.append_face(id)
	return new_msg
##向消息中追加文本
func append_text(text:String):
	contain_data.append({
		"type":"text",
		"data":{
			"text":text
		}
	})
##向消息中追加图片
func append_image(file_path:String):
	contain_data.append({
		"type":"image",
		"data":{
			"file":file_path
		}
	})
##向消息中追加表情
func append_face(id:String):
	contain_data.append({
		"type":"face",
		"data":{
			"id":id
		}
	})
##消息长度
func size()->int:
	return contain_data.size()


