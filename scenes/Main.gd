extends Node2D

@export var game_scene: PackedScene

var game: Node2D

func _on_main_menu_start_game():
    $MainMenu.visible = false
    $MainMenu.active = false
    
    $Intro.visible = true
    await get_tree().process_frame
    $Intro.active = true

func _on_intro_complete():
    $Intro.visible = false
    $Intro.active = false
    
    game = game_scene.instantiate()
    game.starting_room_override = '' # 'res://levels/test/objects.txt'
    add_child(game)
    game.connect("game_over", _on_game_over)
    game.connect("exit_reached", _on_exit_reached)

func _on_game_over():
    await get_tree().create_timer(3).timeout
    $GameOver.visible = true
    $GameOver.active = true
    game.visible = false

func _on_game_over_restart_game():
    get_tree().reload_current_scene()
    
func _on_exit_reached():
    game.hide()
    game.ui.hide()
    $WinScreen.visible = true
    $WinScreen.active = true
    
func _on_win_screen_restart_game():
    get_tree().reload_current_scene()
