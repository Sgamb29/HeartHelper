extends Control


var stats = {"sodium": 0,
			"fruits": 0,
			"veggies": 0,
			"grains": 0,
			"exercise": 0,
			"Calories": 0,
			"Water": 0,
			"Sugar": 0,
			"Protein": 0,
			"Carbs": 0,
			"Fibre": 0,
			"Fat": 0,
			"Meals": 0,
			"Snacks": 0,
			}

# This is just for generating options, putting these into stats dict for saving / loading
var optional_stats = {"Calories": 0,
					"Water": 0,
					"Sugar": 0,
					"Protein": 0,
					"Carbs": 0,
					"Fibre": 0,
					"Fat": 0,
					"Meals": 0,
					"Snacks": 0,
					}
					

var temp_node_group_name = ""
var is_options_displayed = false
			
var info_accessed = false
# Called when the node enters the scene tree for the first time.
func _ready():
	# Want to load the values for all the stats, if no save data savedata will equal False
	var save_data = load_data()
	if save_data:
		# After updating stats dict need to make sure all keys are transfered to json before loading
		if not "Meals" in save_data.keys():
			update_json_with_no_data_loss(save_data)
		stats = load_data()
	# Adding default trackers to globals enabled options
	for x in get_tree().get_nodes_in_group("trackers"):
		if x.stat not in Globals.enabled_options:
			Globals.enabled_options.append(x.stat)
	
	$"Base/marginBase/mainRows/footerCols/SaveBtn".text = "Saved"
	
	# Loading extra trackers
	add_options()
	update_values(stats)
	
	# Want to get the saved theme or the default theme if none saved
	update_theme()

	


func update_theme():
	var saved_theme = Globals.get_theme("panel")
	if saved_theme != "0":
		$"Base".add_theme_stylebox_override("panel", load(saved_theme))

func update_json_with_no_data_loss(previous_dict):
	for x in previous_dict.keys():
		if x not in stats.keys():
			continue
		stats[x] += previous_dict[x]
	save(stats)

func update_values(data):
	#$"Base/marginBase/mainRows/ScrollContainer/VBoxContainer/sodiumCard/LabelOutput".text = str(data["sodium"])
	#$"Base/marginBase/mainRows/ScrollContainer/VBoxContainer/fruitCard/LabelOutput".text = str(data["fruits"])
	#$"Base/marginBase/mainRows/ScrollContainer/VBoxContainer/veggieCard/LabelOutput".text = str(data["veggies"])
	#$"Base/marginBase/mainRows/ScrollContainer/VBoxContainer/grainsCard/LabelOutput".text = str(data["grains"])
	#$"Base/marginBase/mainRows/ScrollContainer/VBoxContainer/exerciseCard/LabelOutput".text = str(data["exercise"])
	for x in get_tree().get_nodes_in_group("trackers"):
		x.update_output_value(str(data[x.stat]))

func update_optional_labels():
	for x in Globals.enabled_options:
		pass
	

func save(data):
	var save_file = FileAccess.open("user://savedata.save", FileAccess.WRITE)
	var json_string = JSON.stringify(data)
	save_file.store_line(json_string)
	Globals.save_options()
	

func load_data():
	if not FileAccess.file_exists("user://savedata.save"):
		return false
	
	var save_file = FileAccess.open("user://savedata.save", FileAccess.READ)
	var json_string = save_file.get_as_text()
	var data = JSON.parse_string(json_string)
	return data


func update_vars():
	
	#$"Base/marginBase/mainRows/ScrollContainer/VBoxContainer/sodiumCard".num = 0
	#$"Base/marginBase/mainRows/ScrollContainer/VBoxContainer/fruitCard".num = 0
	#$"Base/marginBase/mainRows/ScrollContainer/VBoxContainer/veggieCard".num = 0
	#$"Base/marginBase/mainRows/ScrollContainer/VBoxContainer/grainsCard".num = 0
	#$"Base/marginBase/mainRows/ScrollContainer/VBoxContainer/exerciseCard".num = 0
	
	# Trying with group code instead :: And it works!
	var trackers = get_tree().get_nodes_in_group("trackers")
	for x in trackers:
		x.num = 0


func _on_add_btn_pressed():
	#stats["sodium"] += $"Base/marginBase/mainRows/ScrollContainer/VBoxContainer/sodiumCard".num
	#stats["fruits"] += $"Base/marginBase/mainRows/ScrollContainer/VBoxContainer/fruitCard".num
	#stats["veggies"] += $"Base/marginBase/mainRows/ScrollContainer/VBoxContainer/veggieCard".num
	#stats["grains"] += $"Base/marginBase/mainRows/ScrollContainer/VBoxContainer/grainsCard".num
	#stats["exercise"] += $"Base/marginBase/mainRows/ScrollContainer/VBoxContainer/exerciseCard".num
	# Trying same thing with the trackers "group" :: And it works!
	var trackers = get_tree().get_nodes_in_group("trackers")
	for x in trackers:
		stats[x.stat] += x.num
		if x.one_to_add:
			stats[x.stat] += 1
			x.one_to_add = false
			
	if stats["Calories"] != 0:
		Globals.stats_dict["currentCalories"] = stats["Calories"]
		Globals.save_stats()

	update_values(stats)
	update_vars()
	
	$"Base/marginBase/mainRows/footerCols/SaveBtn".text = "Save"


func _on_save_btn_pressed():
	save(stats)
	$"Base/marginBase/mainRows/footerCols/SaveBtn".text = "Saved"


func _on_reset_btn_pressed():
	var keys = ["vegServings", "fruitServings", "grainsServings"]
	for x in keys:
		if len(Globals.stats_dict[x]) == 7:
			Globals.stats_dict[x].pop_front()

	Globals.stats_dict["vegServings"].append(stats["veggies"])
	Globals.stats_dict["fruitServings"].append(stats["fruits"])
	Globals.stats_dict["grainsServings"].append(stats["grains"])
	Globals.stats_dict["currentCalories"] = 0
	Globals.save_stats()
	
	for x in stats.keys():
		stats[x] = 0
	update_values(stats)
	$"Base/marginBase/mainRows/footerCols/SaveBtn".text = "Save"
	
	


func _on_button_info_pressed():
	$"Base/marginBase/mainRows/HBoxContainer/ButtonInfo".visible = false
	#if not info_accessed:
	#	var info_scene = load("res://infoLabel.tscn")
	#	var instance = info_scene.instantiate()
	#	$"Base/marginBase/mainRows/ScrollContainer/VBoxContainer".add_child(instance)
	#	info_accessed = true
	$"Base/marginBase/mainRows/HBoxContainer/darkBtn".visible = true
	$"Base/marginBase/mainRows/HBoxContainer/blueBtn".visible = true
	$"Base/marginBase/mainRows/HBoxContainer/lightBtn".visible = true
	$"Base/marginBase/mainRows/tipsLabel".visible = true
	
		
func hide_trackers():
	var trackers = get_tree().get_nodes_in_group("trackers")
	# This if statement is for removing the options from the scene, making trackers visible again or hiding them
	if not trackers[0].visible:
		add_options()
		# Updated temp_node_group_name in func display_options()
		# Also filled the temp group in display_options()
		for x in get_tree().get_nodes_in_group(temp_node_group_name):
			$"Base/marginBase/mainRows/ScrollContainer/VBoxContainer".remove_child(x)
		for x in trackers:
			x.visible = true
		remove_disabled_trackers()
	else:
		for x in trackers:
			x.visible = false
	


# Function for instantiating the options to choose from
func display_options():
	temp_node_group_name = "options"
	if not is_options_displayed:
		$"Base/marginBase/mainRows/OptionBtn".text = "Back"
		for x in optional_stats.keys():
			var option = load("res://optionCard.tscn")
			var instance = option.instantiate()
			instance.stat = x
			if instance.stat in Globals.enabled_options:
				instance.btnText = instance.btnTextAdded
			else:
				instance.btnText = instance.btnTextNotAdded
			$"Base/marginBase/mainRows/ScrollContainer/VBoxContainer".add_child(instance)
			instance.update_stat()
			instance.add_to_group(temp_node_group_name)
			is_options_displayed = true
			$"Base/marginBase/mainRows/footerCols/SaveBtn".text = "Save"
	else:
		$"Base/marginBase/mainRows/OptionBtn".text = "Customize Trackers"
		is_options_displayed = false


func add_options():
	# Checking if tracker is already enabled so don't add it twice, adding it if it isn't
	var trackers = get_tree().get_nodes_in_group("trackers")
	var already_enabled = []
	for x in trackers:
		already_enabled.append(x.stat)
	for x in Globals.enabled_options:
		if x in already_enabled:
			continue
		var extra_tracker = load("res://elementCard.tscn")
		var instance = extra_tracker.instantiate()
		instance.stat = x
		instance.add_to_group("trackers")
		instance.update_label()
		$"Base/marginBase/mainRows/ScrollContainer/VBoxContainer".add_child(instance)
		instance.add_btn.pressed.connect(_on_add_btn_pressed)


func remove_disabled_trackers():
	for x in get_tree().get_nodes_in_group("trackers"):
		if x.stat not in Globals.enabled_options:
			var xparent = x.get_parent()
			xparent.remove_child(x)

	
	
func _on_option_btn_pressed():
	hide_trackers()
	display_options()


func _on_go_to_log_btn_pressed():
	get_tree().change_scene_to_file("res://bpLog.tscn")


func _on_blue_btn_pressed():
	Globals.current_theme = "blue"
	Globals.save_theme()
	get_tree().reload_current_scene()



func _on_dark_btn_pressed():
	Globals.current_theme = "dark"
	Globals.save_theme()
	get_tree().reload_current_scene()


func _on_light_btn_pressed():
	Globals.current_theme = "light"
	Globals.save_theme()
	get_tree().reload_current_scene()


func _on_stats_page_btn_pressed():
	get_tree().change_scene_to_file("res://statsScreen.tscn")
