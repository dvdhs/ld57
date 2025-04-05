extends CharacterBody2D

@export var speed: float = 100.0
@export var detection_radius: float = 300.0
@export var path_update_interval: float = 0.5

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var detection_area: CollisionShape2D = $CollisionShape2D

# State variables
var player: Node2D = null
var player_detected: bool = false
var path_update_timer: float = 0.0

func _ready() -> void:

	# Configure the navigation agent
	navigation_agent.path_desired_distance = 10.0
	navigation_agent.target_desired_distance = 10.0

	# Find the player in the scene
	player = get_node("../Player")
	if not player:
		print("Warning: Player node not found. Make sure the player is in the 'player' group.")

func _physics_process(delta: float) -> void:
	if not player:
		return

	# Update the path to the player periodically
	path_update_timer += delta
	if path_update_timer >= path_update_interval:
		update_path_to_player()
		path_update_timer = 0.0

	# Move along the path
	if not navigation_agent.is_navigation_finished():
		var next_position = navigation_agent.get_next_path_position()
		var direction = global_position.direction_to(next_position)
		velocity = direction.normalized() * speed
		#print(velocity)

		# Update position
		# global_position += direction * delta

		# Update sprite facing direction
		#update_sprite_direction(direction)
		move_and_slide()

func update_path_to_player() -> void:
	if player:
		navigation_agent.target_position = player.global_position

#func update_sprite_direction(direction: Vector2) -> void:
	## Flip the sprite based on movement direction
	#if direction.x < 0:
		#sprite.flip_h = true
	#elif direction.x > 0:
		#sprite.flip_h = false

	# You can add more sophisticated animation here
	# For example, changing animation based on direction
#
#func _on_body_entered(body: Node2D) -> void:
	#if body.is_in_group("player"):
		#player = body
		#player_detected = true
		#update_path_to_player()
#
#func _on_body_exited(body: Node2D) -> void:
	#if body.is_in_group("player"):
		#player_detected = false
		#velocity = Vector2.ZERO

# Optional: Add a method to handle damage to the player
func damage_player() -> void:
	if player and player.has_method("take_damage"):
		player.take_damage(1)  # Assuming the player has a take_damage method
