extends Label

var info = """What is a serving:
				Fruits: 
					1 Medium Piece of fruit
					1/4 Cup Dried Fruit
					1/2 Cup Fresh, Frozen or Canned Fruit
					
				Veggies:
					1 Cup Raw Leafy Vegetables
					1/2 Cup Cooked Vegetables
					
				Grains:
					1 Slice Bread
					1 Cup Ready to Eat Cereal
					1/2 Cup Cooked Rice, Pasta or Cereal"""


# Called when the node enters the scene tree for the first time.
func _ready():
	$".".text = info


