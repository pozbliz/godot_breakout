extends Node2D

const SPEED := 250
@onready var screen_size = get_viewport_rect().size

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	var velocity := Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1 * SPEED
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1 * SPEED
		
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x - $ColorRect.size.x)
	
func start(pos):
	position = pos
