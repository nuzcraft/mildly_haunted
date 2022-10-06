extends Spatial

onready var bedroom_door := $doors/bedroom_door
onready var animationPlayer := $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("bedroom_door_open", self, "_on_bedroom_door_open")


func _on_bedroom_door_open():
	print("signal found")
	animationPlayer.play("bedroom_door_open")
