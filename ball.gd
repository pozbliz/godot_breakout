extends CharacterBody2D


@onready var direction: Vector2 = Vector2.ZERO
@onready var speed := 250.0
var game_started := false

const SPEED_INCREASE := 5.0  # in %
const MAX_SPEED := 500
const BALL_RADIUS := 12
const BALL_COLOR := Color.WHITE

signal enemy_hit


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE

func _physics_process(delta):
	if not game_started:
		return

	var velocity = direction.normalized() * speed
	var collision = move_and_collide(velocity * delta)
	var increase_factor: float = 1 + SPEED_INCREASE / 100
	
	if collision:
		var normal = collision.get_normal()
		direction = direction.bounce(normal).normalized()
		
		if collision.get_collider() and collision.get_collider().name == "Block":
			speed = min(speed * increase_factor, MAX_SPEED)
			collision.enemy_hit.emit()
			if collision.has_method("kill_block"):
				collision.kill_block()
	
func _draw():
	draw_circle(Vector2.ZERO, BALL_RADIUS, BALL_COLOR)

func start(pos):
	position = pos
	speed = 250
	game_started = true
	direction.y = 1
	direction.x = randf_range(-0.7, 0.7)
	
	await get_tree().create_timer(1).timeout
