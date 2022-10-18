extends Node

func _input(event):
	if event is InputEventMouseButton:
		get_tree().change_scene("res://house_scenes/House_01.tscn")
