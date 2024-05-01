extends HBoxContainer


@export var stat = ""
var enabled = false
var btnTextNotAdded = "+ Add +"
var btnTextAdded = "+ Remove +"
var btnText = "+ Add +"

func update_stat():
	$"LabelName".text = stat
	$"addOptionBtn".text = btnText


func _on_add_option_btn_pressed():
	enabled = true
	if len(stat) > 0 and stat not in Globals.enabled_options:
		Globals.enabled_options.append(stat)
		$"addOptionBtn".text = btnTextAdded
	else:
		enabled = false
		Globals.enabled_options.erase(stat)
		$"addOptionBtn".text = btnTextNotAdded


func _on_remove_btn_pressed():
	enabled = false
	if len(stat) > 0:
		Globals.enabled_options.erase(stat)
		$"addOptionBtn".text = btnTextNotAdded
	
