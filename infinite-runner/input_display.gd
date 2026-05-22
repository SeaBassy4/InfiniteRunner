extends CanvasLayer

# 1. Export the 5 textures
@export_group("D-Pad Textures")
@export var none_tex : Texture2D
@export var up_tex : Texture2D
@export var down_tex : Texture2D
@export var left_tex : Texture2D
@export var right_tex : Texture2D

# 2. Grab the reference to our single TextureRect
@onready var display_rect = $MarginContainer/DPadDisplay

func _ready() -> void:
	# Set the default "none" texture when the game starts
	display_rect.texture = none_tex

func _process(_delta: float) -> void:
	# Check inputs and swap the whole texture. 
	# Using elif ensures only one direction highlights at a time.
	if Input.is_action_pressed("ui_up"):
		display_rect.texture = up_tex
	elif Input.is_action_pressed("ui_down"):
		display_rect.texture = down_tex
	elif Input.is_action_pressed("ui_left"):
		display_rect.texture = left_tex
	elif Input.is_action_pressed("ui_right"):
		display_rect.texture = right_tex
	else:
		# If nothing is pressed, go back to default
		display_rect.texture = none_tex
