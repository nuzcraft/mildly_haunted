extends Spatial

onready var animationPlayer := $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("bedroom_door_open", self, "_on_bedroom_door_open")
	Events.connect("bedroom_door_close", self, "_on_bedroom_door_close")
	Events.connect("bathroom_door_open", self, "_on_bathroom_door_open")
	Events.connect("bathroom_door_close", self, "_on_bathroom_door_close")
	Events.connect("front_door_open", self, "_on_front_door_open")
	Events.connect("front_door_close", self, "_on_front_door_close")

func _on_bedroom_door_open():
	animationPlayer.play("bedroom_door_open")

func _on_bedroom_door_close():
	animationPlayer.play("bedroom_door_close")

func _on_bathroom_door_open():
	animationPlayer.play("bathroom_door_open")

func _on_bathroom_door_close():
	animationPlayer.play("bathroom_door_close")
	
func _on_front_door_open():
	animationPlayer.play("front_door_open")

func _on_front_door_close():
	animationPlayer.play("front_door_close")
