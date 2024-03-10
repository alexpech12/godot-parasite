class_name IdleState

extends State

var animation_name = "face"

func next_state():
    var transitions = [
        {
            'input': "up",
            'movement': Vector2(0, -subject.STEP_SIZE)
        },{
            'input': "left",
            'movement': Vector2(-subject.STEP_SIZE, 0)
        },{
            'input': "down",
            'movement': Vector2(0, subject.STEP_SIZE)
        },{
            'input': "right",
            'movement': Vector2(subject.STEP_SIZE, 0)
        },
    ]
    for transition in transitions:
        if inputs.get(transition['input']):
            return MoveState.new(subject, transition['movement'])
