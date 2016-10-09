
extends KinematicBody
var target;
func _ready():
	set_fixed_process(true);
	
func setTarget(t):
	target = t;
	
func _fixed_process(delta):
	if (target != null):
		translate((target.get_global_transform().origin - get_global_transform().origin) * .1);
		pass;


