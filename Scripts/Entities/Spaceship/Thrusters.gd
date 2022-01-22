extends Node2D

onready var forward = $Forward
onready var reverse_left = $ReverseLeft
onready var reverse_right = $ReverseRight
onready var left_front = $LeftFront
onready var left_rear = $LeftRear
onready var right_front = $RightFront
onready var right_rear = $RightRear

func _ready():
	off()

func off():
	forward.visible = false
	reverse_left.visible = false
	reverse_right.visible = false
	left_front.visible = false
	left_rear.visible = false
	right_front.visible = false
	right_rear.visible = false

func forward():
	forward.visible = true

func reverse():
	reverse_left.visible = true
	reverse_right.visible = true

func rotate_left():
	left_rear.visible = true
	right_front.visible = true

func rotate_right():
	left_front.visible = true
	right_rear.visible = true

func strafe_left():
	right_front.visible = true
	right_rear.visible = true

func strafe_right():
	left_front.visible = true
	left_rear.visible = true
