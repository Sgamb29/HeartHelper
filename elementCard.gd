extends HBoxContainer

var num = 0
@export var stat = ""
@onready var add_btn = $"addBtn"
var negative_detected = false
var one_to_add = false


func is_valid(txt):
	var valid = "-1234567890"
	negative_detected = false
	var dash_count = 0
	if len(txt) < 1:
		return false
	if txt[0] == '-':
		negative_detected = true
	for x in txt:
		if x == '-':
			dash_count += 1
		if x not in valid or dash_count > 1:
			return false
			
		if not negative_detected and dash_count > 0:
			return false
			
	return true


func _on_add_btn_pressed():
	var input_text = $"InputSubject".text
	if is_valid(input_text):
		num = int(input_text)
	if input_text == "":
		one_to_add = true
	$"InputSubject".clear()


func update_label():
	$"LabelName".text = stat
	$"LabelOutput".text = str(num)
	
	$"InputSubject".clear()


func update_output_value(num):
	$"LabelOutput".text = str(num)
