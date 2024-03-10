class_name DeathState

extends State

var animation_name = "death"

func enter():
    if subject.has_method("on_death_entered"):
        subject.on_death_entered()
    
    subject.queue_free()
    
func next_state():
    return null
