class_name DeathState

extends State

var animation_name = "death"

func enter():
    # TODO: Spawn something to play a death animation
    subject.queue_free()
    
func next_state():
    return null
