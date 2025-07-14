extends StaticBody2D


const block_size := Vector2(64, 32)


func _ready() -> void:
	$ColorRect.size = block_size
	$ColorRect.color = Color.from_hsv(randf(), 0.8, 0.9)

func _process(delta: float) -> void:
	pass

func kill_block():
	queue_free()
