class_name IdleDownState

extends IdleState

func _init(subject):
    super(subject, "face_down")
    
func facing_direction():
    return Vector2.DOWN
    
func next_state():
    var next_state = super()
    
    if next_state:
        return next_state
        
    if inputs.get("attack"):
        return AttackDownState.new(subject)
