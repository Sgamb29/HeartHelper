extends VBoxContainer

var data_dict = {"date": "",
				"time": "",
				"top": 0,
				"bottom": 0,
				"heart-rate": 0,
				}

# Called when the node enters the scene tree for the first time.
func _ready():
	update_time_vals()


func update_time_vals():
	var date = Time.get_datetime_dict_from_system()
	var format_string_date = "%s-%s-%s"
	var actual_string_date = format_string_date % [date["year"], date["month"], date["day"]]
	var format_string_time = "%s:%s"
	var temp_min = ""
	if date["minute"] < 10:
		temp_min = "0" + str(date["minute"])
	else:
		temp_min = str(date["minute"])
	var actual_string_time = format_string_time % [date["hour"], temp_min]

	$"DateInp/dateLineEdit".text = actual_string_date
	$"timeInp/timeLineEdit".text = actual_string_time
	data_dict["date"] = actual_string_date
	data_dict["time"] = actual_string_time


func is_valid(txt):
	var valid = "1234567890"
	for x in txt:
		if x not in valid:
			return false
	return true

func _on_sys_edit_text_changed(new_text):
	if not is_valid(new_text):
		$"TopNumInput/sysEdit".clear()
	else:
		data_dict["top"] = int(new_text)


func _on_dia_edit_text_changed(new_text):
	if not is_valid(new_text):
		$"BtmNumInput2/diaEdit".clear()
	else:
		data_dict["bottom"] = int(new_text)


func _on_time_line_edit_text_changed(new_text):
	data_dict["time"] = new_text


func _on_date_line_edit_text_changed(new_text):
	data_dict["date"] = new_text




func _on_hr_edit_text_changed(new_text):
	if not is_valid(new_text):
		$"heartRateInput/hrEdit".clear()
	else:
		data_dict["heart-rate"] = int(new_text)
