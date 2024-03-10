class_name MoveState

extends State

var start
var target
var t = 0 # t for the state
var at = 0 # t for the animation
var aborting = false

var animation_name = "step"

func _init(subject, movement: Vector2):
    super(subject)
    self.start = subject.position
    target = subject.position + movement
    subject.facing_direction = Vector2i(movement.normalized().x, movement.normalized().y)
    
    # Prevent the subject from walking into a wall
    # TODO: In future, this could became a 'bump into wall' animation
    #if subject.collision_test(target):
        #self.target = subject.position
    
func process(delta):
    t += 1
    at += 1
    if at <= subject.move_frames:
        subject.position = start.lerp(target, (at as float) / subject.move_frames)
        
    if !aborting && (subject.has_overlapping_areas() || subject.has_overlapping_bodies()):
        # Abort the movement
        aborting = true
        var tmp = start
        start = target
        target = tmp
        at = subject.move_frames - at
    elif movement_complete():
        snap_position()

func next_state():
    if not movement_complete():
        return null
        
    var next_state = IdleState.new(subject)
    
    # Allow the idle state to transitioning straight back to a moving state
    # without waiting for an update cycle if the inputs are still asserted
    next_state.set_inputs(inputs)
    var next_next_state = next_state.next_state()
    if next_next_state:
        return next_next_state
    else:
        return next_state
    
func movement_complete():
    return t >= subject.move_frames

func snap_position():
    subject.position = Vector2i(
        ((target.x as int) / subject.STEP_SIZE) * subject.STEP_SIZE + subject.STEP_SIZE / 2,
        ((target.y as int) / subject.STEP_SIZE) * subject.STEP_SIZE + subject.STEP_SIZE / 2
    )
