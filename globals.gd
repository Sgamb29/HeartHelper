extends Node


var enabled_options = []
var current_theme = "dark"

var node_dict = {"active": enabled_options}

func save_options():
	var save_file = FileAccess.open("user://savedoptions.save", FileAccess.WRITE)
	var json_string = JSON.stringify(node_dict)
	save_file.store_line(json_string)
	

func load_options():
	if not FileAccess.file_exists("user://savedoptions.save"):
		return false
	
	var save_file = FileAccess.open("user://savedoptions.save", FileAccess.READ)
	var json_string = save_file.get_as_text()
	var data = JSON.parse_string(json_string)
	return data

func _ready():
	var save_data = load_options()
	if save_data:
		node_dict = save_data
		enabled_options = node_dict["active"]
		
	var theme_data = load_theme()
	if theme_data:
		current_theme = theme_data["theme"]
		
	
	stats_dict = load_stats()
		
		
		


var themes = ["dark", "blue"]



func get_theme(type):
	if current_theme == "blue":
		return "0"
	if current_theme == "dark":
		if type == "panel":
			return "res://grey-theme.tres"
		elif type == "normal":
			return "res://grey-theme-button.tres"
		elif type == "normal-line-edit":
			return "res://grey-theme-line-edit.tres"
	elif current_theme == "light":
		if type == "panel":
			return "res://light-theme.tres"
		elif type == "normal":
			return "res://light-theme-button.tres"
		elif type == "normal-line-edit":
			return "res://light-theme-line-edit.tres"
		
			
func save_theme():
	var theme_dict = {"theme": current_theme}
	var save_file = FileAccess.open("user://savedtheme.save", FileAccess.WRITE)
	var json_string = JSON.stringify(theme_dict)
	save_file.store_line(json_string)
	
func load_theme():
	if not FileAccess.file_exists("user://savedtheme.save"):
		return false
	
	var save_file = FileAccess.open("user://savedtheme.save", FileAccess.READ)
	var json_string = save_file.get_as_text()
	var data = JSON.parse_string(json_string)
	return data
	


var stats_dict = {
	"vegServings" : [],
	"fruitServings": [],
	"grainsServings": [],
	"weight": 0,
	"startWeight": 0,
	"calorieGoal": 0,
	"currentCalories": 0,
}

func save_stats():
	var save_file = FileAccess.open("user://savedstats.save", FileAccess.WRITE)
	var json_string = JSON.stringify(stats_dict)
	save_file.store_line(json_string)
	
func load_stats():
	if not FileAccess.file_exists("user://savedstats.save"):
		return {
	"vegServings" : [],
	"fruitServings": [],
	"grainsServings": [],
	"weight": 0,
	"startWeight": 0,
	"calorieGoal": 0,
	"currentCalories": 0,
}
	
	var save_file = FileAccess.open("user://savedstats.save", FileAccess.READ)
	var json_string = save_file.get_as_text()
	var data = JSON.parse_string(json_string)
	
	return data

