extends Node

@export var mob_scene: PackedScene


func _ready() -> void:
	var mob = mob_scene.instantiate()
	
	mob.position = $Player.position - Vector2(10, 10)
	
	add_child(mob)
