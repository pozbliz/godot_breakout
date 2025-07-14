extends CanvasLayer


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func update_player_score(score: int):
	$HBoxContainer/PlayerScore.text = str(score)
	
func update_enemy_score(score: int):
	$HBoxContainer/EnemyScore.text = str(score)
