extends Control


var save_dict = {}
var total_entries = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	# Save dict will either have data or be an empty {}
	save_dict = load_save()
	if save_dict != {}:
		total_entries = len(save_dict.keys())
		add_from_log()
		
	var saved_theme = Globals.get_theme("panel")
	$"Base".add_theme_stylebox_override("panel", load(saved_theme))
	




func _on_submit_btn_pressed():
	var data_dict = $"Base/marginBase/mainRows/BpInputCard".data_dict
	total_entries += 1
	save_dict[str(total_entries)] = data_dict
	save()
	save_dict = load_save()
	
	remove_log_children_for_refresh()
	add_from_log()
	$"Base/marginBase/mainRows/BpInputCard/TopNumInput/sysEdit".clear()
	$"Base/marginBase/mainRows/BpInputCard/BtmNumInput2/diaEdit".clear()
	

func save():
	var save_file = FileAccess.open("user://bp-log.save", FileAccess.WRITE)
	var json_string = JSON.stringify(save_dict)
	save_file.store_line(json_string)
	
	

func load_save():
	if not FileAccess.file_exists("user://bp-log.save"):
		return {}
	
	var save_file = FileAccess.open("user://bp-log.save", FileAccess.READ)
	var json_string = save_file.get_as_text()
	var data = JSON.parse_string(json_string)
	return data
	

func add_from_log():
	# Probably should uses dict.keys() instead of indexing to avoid errors
	# Get a list of valid keys
	var save_keys = save_dict.keys()
	# Go through the list in reverse for proper display
	save_keys.reverse()
	for x in save_keys:
		var log_scene = load("res://mainLabel.tscn")
		var instance = log_scene.instantiate()
		var format_data_str = "Date: %s\nTime: %s\nSys: %s\nDia: %s"
		var data_dict = save_dict[x]
		var actual_data_str = format_data_str % [data_dict["date"], data_dict["time"], data_dict["top"], data_dict["bottom"]]
		if "heart-rate" in data_dict.keys():
			actual_data_str = actual_data_str + "\nHeart-Rate: " + str(data_dict["heart-rate"])
		instance.text = actual_data_str
		$"Base/marginBase/mainRows/ScrollContainer/VBoxContainer".add_child(instance)
		
	#var temp_num_entries = total_entries
	#for x in range(temp_num_entries, 0, -1):
	#	var log_scene = load("res://mainLabel.tscn")
	#	var instance = log_scene.instantiate()
	#	var format_data_str = "Date: %s\nTime: %s\nSys: %s\nDia: %s"
	#	var data_dict = save_dict[str(x)]
	#	var actual_data_str = format_data_str % [data_dict["date"], data_dict["time"], data_dict["top"], data_dict["bottom"]]
	#	instance.text = actual_data_str
	#	$"Base/marginBase/mainRows/ScrollContainer/VBoxContainer".add_child(instance)
		

func remove_log_children_for_refresh():
	var entries = $"Base/marginBase/mainRows/ScrollContainer/VBoxContainer".get_children()
	for x in entries:
		$"Base/marginBase/mainRows/ScrollContainer/VBoxContainer".remove_child(x)

		
		


func _on_home_btn_pressed():
	get_tree().change_scene_to_file("res://appMain.tscn")




func _on_export_btn_pressed():
	remove_log_children_for_refresh()
	var export_scene = load("res://csv_export_edit_2.tscn")
	var instance = export_scene.instantiate()
	instance.save_dict = save_dict
	$"Base/marginBase/mainRows/ScrollContainer/VBoxContainer".add_child(instance)


func _on_clear_log_btn_pressed():
	$"Base/marginBase/mainRows/OptBtnRow/ClearLogBtn".text = "Erase All?"
	$"Base/marginBase/mainRows/OptBtnRow/AcceptBtn".visible = true
	$"Base/marginBase/mainRows/OptBtnRow/CancelBtn".visible = true


func revert_button_changes():
	$"Base/marginBase/mainRows/OptBtnRow/ClearLogBtn".text = "Clear Log"
	$"Base/marginBase/mainRows/OptBtnRow/AcceptBtn".visible = false
	$"Base/marginBase/mainRows/OptBtnRow/CancelBtn".visible = false
	$"Base/marginBase/mainRows/OptBtnRow/AcceptBtn".text = "Yes"
	

var confirm_count = 0

func _on_accept_btn_pressed():
	confirm_count += 1
	if confirm_count == 1:
		$"Base/marginBase/mainRows/OptBtnRow/AcceptBtn".text = "Confirm"
	elif confirm_count > 1:
		save_dict = {}
		total_entries = 0
		save()
		remove_log_children_for_refresh()
		revert_button_changes()
		$"Base/marginBase/mainRows/OptBtnRow/ClearLogBtn".text = "Log Cleared"
		confirm_count = 0


func _on_cancel_btn_pressed():
	revert_button_changes()
	confirm_count = 0
