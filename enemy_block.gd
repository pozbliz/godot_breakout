extends StaticBody2D


func _ready() -> void:
	add_to_group("blocks")
	$ColorRect.color = Color.from_hsv(randf(), 0.8, 0.9)
	
func set_block_size(size: Vector2) -> void:
	$ColorRect.size = size
	$CollisionShape2D.shape.size = size
	$CollisionShape2D.position = size / 2

func _process(delta: float) -> void:
	pass

func kill_block():
	queue_free()
