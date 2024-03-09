class_name IdleLeftState

extends IdleState

func _init(subject):
    super(subject, "face_left")
    
func facing_direction():
    print_debug("Returning Vector2.LEFT - " + str(Vector2.LEFT))
    return Vector2.LEFT
    
func next_state():
    var next_state = super()
    
    if next_state:
        return next_state
        
    if inputs.get("attack"):
        return AttackLeftState.new(subject)
