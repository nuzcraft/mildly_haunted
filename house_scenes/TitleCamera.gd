extends Camera


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var cameraAnimation := $CameraAnimation


# Called when the node enters the scene tree for the first time.
func _ready():
	var sway = cameraAnimation.get_animation("sway")
	sway.set_loop(true)
	cameraAnimation.play("sway")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
