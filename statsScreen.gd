extends Control

var averages = {"vegServings": 0, "fruitServings": 0, "grainsServings": 0}
# Called when the node enters the scene tree for the first time.
func _ready():
	averages = get_averages()
	$"Base/marginBase/mainRows/ScrollContainer/VBoxContainer/fruitAvgLbl".text = "%.2f" % averages["fruitServings"]
	$"Base/marginBase/mainRows/ScrollContainer/VBoxContainer/vegAvgLbl".text = "%.2f" % averages["vegServings"]
	$"Base/marginBase/mainRows/ScrollContainer/VBoxContainer/grainsAvgLbl".text = "%.2f" % averages["grainsServings"]
	$"Base/marginBase/mainRows/ScrollContainer/VBoxContainer/weightOutput".text = "Current Weight: " + str(Globals.stats_dict["weight"])

	get_weight_change()
	$"Base/marginBase/mainRows/ScrollContainer/VBoxContainer/calorieGoalbl".text = "Calorie Goal: " + str(Globals.stats_dict["calorieGoal"])
	var caloires_left = Globals.stats_dict["calorieGoal"] - Globals.stats_dict["currentCalories"]
	$"Base/marginBase/mainRows/ScrollContainer/VBoxContainer/caloriesLeftLbl".text = "Calories Left: " + str(caloires_left)


func get_averages():
	var averages_temp = {"vegServings": 0, "fruitServings": 0, "grainsServings": 0}
	for x in averages_temp.keys():
		var count = 0
		var sum = 0
		for y in Globals.stats_dict[x]:
			sum += y
			count += 1
		if count > 0:
			averages_temp[x] = sum / count
	
	return averages_temp
		


func _on_home_btn_pressed():
	get_tree().change_scene_to_file("res://appMain.tscn")


func _on_weight_input_text_submitted(new_text):
	var valid = "0123456789"
	if new_text == "rst":
		Globals.stats_dict["startWeight"] = 0
		Globals.save_stats()
		get_weight_change()
		$"Base/marginBase/mainRows/ScrollContainer/VBoxContainer/weightInput".clear()
		return
	for x in new_text:
		if x not in valid:
			$"Base/marginBase/mainRows/ScrollContainer/VBoxContainer/weightInput".clear()
			return
	
	if Globals.stats_dict["startWeight"] == 0:
		Globals.stats_dict["startWeight"] = int(new_text)
	else:
		var weight_change = int(new_text) - Globals.stats_dict["startWeight"]
		var op = "+"
		if weight_change <= 0:
			op = ""
		$"Base/marginBase/mainRows/ScrollContainer/VBoxContainer/weightChangeLbl".text = "Change in Weight: " + op + str(weight_change)
		
	Globals.stats_dict["weight"] = int(new_text)
	Globals.save_stats()
	$"Base/marginBase/mainRows/ScrollContainer/VBoxContainer/weightOutput".text = "Current Weight: " + new_text
	
	$"Base/marginBase/mainRows/ScrollContainer/VBoxContainer/weightInput".clear()


func get_weight_change():
	var change_in_weight = 0
	var op = "+"
	if Globals.stats_dict["startWeight"] == 0 or Globals.stats_dict["weight"] == 0:
		change_in_weight = 0
	else:
		change_in_weight = Globals.stats_dict["weight"] - Globals.stats_dict["startWeight"]
	if change_in_weight <= 0:
		op = ""
	$"Base/marginBase/mainRows/ScrollContainer/VBoxContainer/weightChangeLbl".text = "Change in Weight: " + op + str(change_in_weight)
		


func _on_calorie_goal_input_text_submitted(new_text):
	var valid = "0123456789"
	for x in new_text:
		if x not in valid:
			$"Base/marginBase/mainRows/ScrollContainer/VBoxContainer/calorieGoalInput".clear()
			return
			
	Globals.stats_dict["calorieGoal"] = int(new_text)
	$"Base/marginBase/mainRows/ScrollContainer/VBoxContainer/calorieGoalbl".text = "Calorie Goal: " + new_text
	var caloires_left = int(new_text) - Globals.stats_dict["currentCalories"]
	$"Base/marginBase/mainRows/ScrollContainer/VBoxContainer/caloriesLeftLbl".text = "Calories Left: " + str(caloires_left)
	$"Base/marginBase/mainRows/ScrollContainer/VBoxContainer/calorieGoalInput".clear()
	Globals.save_stats()
