
extends KinematicBody

const STATE = {
	Homing = 0,
	Attacking = 1
}

var target;
var state = STATE.Homing;

func _ready():
	set_fixed_process(true);
	
func setTarget(t):
	target = t;
	
func _fixed_process(delta):
	if (target != null):
		if (state == STATE.Homing):
			home();
		elif (state == STATE.Attacking):
			attack();

func home():
	# Move closer to target
	translate((target.get_global_transform().origin + Vector3(0, 0, -2) - get_global_transform().origin) * 0.1);
	
	# Switch to attacking state if the rambot is already close enough to the target
	if (isCloseEnough(target.get_global_transform().origin + Vector3(0, 0, -2), get_global_transform().origin, 0.7)):
		state = STATE.Attacking;

func attack():
	# Attack in straight line
	translate(Vector3(0, 0, 0.2));
	
	# Switch to homing if the target passed the rambot
	if (target.get_global_transform().origin.z < get_global_transform().origin.z):
		state = STATE.Homing;

func isCloseEnough(point1, point2, distance):
	var diff = (point1 - point2).abs();
	return diff.x <= distance && diff.y <= distance && diff.z <= distance