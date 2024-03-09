class_name MoveState

extends State

var start
var target
var t = 0 # t for the state
var at = 0 # t for the animation
var aborting = false

func _init(subject, animation, movement):
    super(subject, animation)
    self.start = subject.position
    target = subject.position + movement
    
    # Prevent the subject from walking into a wall
    # TODO: In future, this could became a 'bump into wall' animation
    #if subject.collision_test(target):
        #self.target = subject.position
    
func process(delta):
    t += 1
    at += 1
    if at <= subject.move_frames:
        subject.position = start.lerp(target, (at as float) / subject.move_frames)
    
    if subject.has_overlapping_bodies():
        print_debug("Overlap")
        
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
    if movement_complete():
        return _next_state()
    
func _next_state():
    assert(false, "_next_state must be implemented!")
    
func movement_complete():
    return t >= subject.move_frames

func snap_position():
    subject.position = Vector2i(
        ((target.x as int) / subject.STEP_SIZE) * subject.STEP_SIZE + subject.STEP_SIZE / 2,
        ((target.y as int) / subject.STEP_SIZE) * subject.STEP_SIZE + subject.STEP_SIZE / 2
    )
