class_name MoveLeftState

extends MoveState

func _init(subject):
    super(subject, "step_left", Vector2(-subject.STEP_SIZE, 0))
    
func _next_state():
    if inputs.get("left"):
        return MoveLeftState.new(subject)
    else:
        return IdleLeftState.new(subject)
