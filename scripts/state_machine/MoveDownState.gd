class_name MoveDownState

extends MoveState

func _init(subject):
    super(subject, "step_down", Vector2(0, subject.STEP_SIZE))
 
func facing_direction():
    return Vector2.DOWN   
    
func _next_state():
    if inputs.get("down"):
        return MoveDownState.new(subject)
    else:
        return IdleDownState.new(subject)
