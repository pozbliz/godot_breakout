extends Node

@export var ball_scene: PackedScene
@export var block_scene: PackedScene
var player_score := 0
var player_life := 3
var scoring = false


func _ready() -> void:
	$PlayerGoal.body_entered.connect(_on_player_goal_body_entered)
	$MainMenu/VBoxContainer/StartGameButton.pressed.connect(_on_start_game_button_pressed)
	$MainMenu/VBoxContainer/ExitGameButton.pressed.connect(_on_exit_game_button_pressed)
	$MainMenu/VBoxContainer/ResetGameButton.pressed.connect(_on_reset_game_button_pressed)
	$MainMenu/VBoxContainer/ResumeGameButton.pressed.connect(_on_resume_game_button_pressed)
	
	$MainMenu.process_mode = Node.PROCESS_MODE_ALWAYS

	$HUD.hide()
	
func spawn_blocks():
	var rows: int = 5
	var columns: int = 8
	var start_position: Vector2 = Vector2(32, 32)
	var block_size: Vector2 = Vector2(50, 50)
	
	for row in range(rows):
		for column in range(columns):
			var block = block_scene.instantiate()
			block.position = start_position + Vector2(column * block_size.x, row * block_size.y)
			add_child(block)
			block.set_block_size(block_size)
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("open_menu"):
		toggle_pause()

func toggle_pause():
	if get_tree().paused:
		# Resume game
		get_tree().paused = false
		$MainMenu.hide()
		$HUD.show()
	else:
		# Pause game
		get_tree().paused = true
		$HUD.hide()
		$MainMenu.show()

func _process(delta: float) -> void:
	pass

func new_game():
	$MainMenu.hide()
	$HUD.show()
	get_tree().paused = false
	player_score = 0
	player_life = 3
	$HUD.update_player_score(player_score)
	$HUD.update_lives(player_life)
	var ball = ball_scene.instantiate()
	add_child(ball)
	ball.add_to_group("ball")
	$Ball.enemy_hit.connect(_on_block_enemy_hit)
	new_round()
	spawn_blocks()

func new_round():
	reset_positions()

func reset_positions():
	$PlayerBar.start($PlayerStartPosition.position)
	$Ball.start($BallStartPosition.position)

func _on_player_goal_body_entered(body: Node):
	player_life -= 1
	$HUD.update_lives(player_life)
	if player_life <= 0:
		await $HUD.show_game_over()
		get_tree().paused = true
		delete_all_blocks()
		$MainMenu.show()
		$HUD.hide()
	else:
		new_round()
		
func delete_all_blocks():
	for block in get_tree().get_nodes_in_group("blocks"):
		block.queue_free()
	for ball in get_tree().get_nodes_in_group("ball"):
		ball.queue_free()
		
func _on_block_enemy_hit():
	if scoring:
		return
		
	scoring = true
	player_score += 1
	$HUD.update_player_score(player_score)
	scoring = false
	
func _on_start_game_button_pressed():
	new_game()
	
func _on_reset_game_button_pressed():
	get_tree().paused = false 
	new_game()
	
func _on_resume_game_button_pressed():
	get_tree().paused = false
	$MainMenu.hide()
	$HUD.show()
	
func _on_exit_game_button_pressed():
	get_tree().quit()
