extends Node2D

@export var active = false
var active_page = 0

signal complete

var pages = []
func _ready():
    pages = [
        $Part1,
        $Part2,
        $Part3,
        $Part4,
        $Part5
    ]
    
    for page in pages:
        page.visible = false

    pages[active_page].visible = true

func _process(delta):
    if not active:
        return
        
    if Input.is_action_just_pressed("ui_accept"):
        next_page()
        
func next_page():
    if active_page >= pages.size() - 1:
        complete.emit()
    else:
        pages[active_page].visible = false
        active_page += 1
        pages[active_page].visible = true
