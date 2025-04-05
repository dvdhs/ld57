extends CharacterBody2D

var speed = 200
var screen_size;
var is_looking_up = false;
func _ready():
	screen_size = get_viewport_rect().size
	$AnimatedSprite2D.play('walk_down')
	velocity = Vector2.ZERO

func _physics_process(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction.normalized() * speed
	print(direction)
	if (velocity.length() > 0):
		if (direction.y < 0):
			$AnimatedSprite2D.play('walk_up')
		elif (direction.y > 0):
			$AnimatedSprite2D.play('walk_down')
		elif (direction.x < 0):
			$AnimatedSprite2D.flip_h = true;
			$AnimatedSprite2D.play("walk_down")
		else:
			$AnimatedSprite2D.flip_h = false;
			$AnimatedSprite2D.play("walk_down")
	move_and_slide()
