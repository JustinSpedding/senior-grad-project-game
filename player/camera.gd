extends Camera

func _ready() -> void:
	set_physics_process(true)

export var look_at_player: bool = false

func _physics_process(_delta: float) -> void:
	if look_at_player:
		look_at(get_parent().get_node("player").get_global_transform().origin, Vector3(0.0, 1.0, 0.0))
