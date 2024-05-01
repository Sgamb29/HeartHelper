extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	var saved_theme = Globals.get_theme("normal")
	if saved_theme != "0":
		self.add_theme_stylebox_override("normal", load(saved_theme))
