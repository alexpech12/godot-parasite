class_name MoveUpState

extends MoveState

func _init(subject):
    super(subject, "step_up", Vector2(0, -subject.STEP_SIZE))

func facing_direction():
    return Vector2.UP
     
func _next_state():
    if inputs.get("up"):
        return MoveUpState.new(subject)
    else:
        return IdleUpState.new(subject)
