class_name MoveRightState

extends MoveState

func _init(subject):
    super(subject, "step_right", Vector2(subject.STEP_SIZE, 0))
 
func facing_direction():
    return Vector2.RIGHT
   
func _next_state():
    if inputs.get("right"):
        return MoveRightState.new(subject)
    else:
        return IdleRightState.new(subject)
