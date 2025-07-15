extends CanvasLayer


@export var score_label: Label
@export var lives_label: Label


func _ready() -> void:
	$MessageTimer.timeout.connect(_on_message_timer_timeout)

func _process(delta: float) -> void:
	pass
	
func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	await $MessageTimer.timeout

func update_player_score(score: int):
	score_label.text = str(score)
	
func update_lives(lives: int):
	lives_label.text = str(lives)
	
func _on_message_timer_timeout():
	$Message.hide()
