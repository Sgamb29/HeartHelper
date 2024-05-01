extends TextEdit

var save_dict = {}

var total_entries = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	total_entries = len(save_dict.keys())
	if total_entries >= 1:
		add_from_log()


func add_from_log():
	var complete_data_str = ""
	complete_data_str = complete_data_str + "date,time,hr,sys,dia\n"
	var save_dict_keys = save_dict.keys()
	for x in save_dict_keys:
		var format_data_str = "%s,%s,%s,%s,%s\n"
		var data_dict = save_dict[x]
		var actual_data_str = format_data_str % [data_dict["date"], data_dict["time"], data_dict["heart-rate"], data_dict["top"], data_dict["bottom"]]
		complete_data_str = complete_data_str + actual_data_str
		
	$".".text = complete_data_str
	


func _on_copy_btn_pressed():
	$".".select_all()
	$".".copy()
	$"copyBtn".text = "Copied"
