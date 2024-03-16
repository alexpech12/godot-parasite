extends Node2D

@export var game_scene: PackedScene

var game: Node2D

func _on_main_menu_start_game():
    $MainMenu.visible = false
        
    game = game_scene.instantiate()
    add_child(game)
    game.connect("game_over", _on_game_over)
    
func _on_game_over():
    await get_tree().create_timer(3).timeout
    $GameOver.visible = true
    $GameOver.active = true
    game.visible = false

func _on_game_over_restart_game():
    get_tree().reload_current_scene()
