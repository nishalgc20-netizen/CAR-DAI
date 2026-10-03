extends CanvasLayer

@onready var speed_label: Label = $SpeedLabel
@onready var gear_label: Label = $GearLabel
@onready var rpm_label: Label = $RPMLabel
@onready var nitro_label: Label = $NitroLabel
@onready var mission_label: Label = $MissionLabel

func _process(_delta: float) -> void:
    var player := get_tree().get_first_node_in_group("player_car")
    if player == null:
        return

    var speed_kmh := int(abs(player.linear_velocity.length() * 3.6))
    speed_label.text = str(speed_kmh) + " KM/H"
    gear_label.text = "D"
    rpm_label.text = "RPM %d" % int(speed_kmh * 24.0)
    nitro_label.text = "NITRO %d%%" % int(clamp(player.get("nitro_meter", 100.0), 0.0, 100.0))
    mission_label.text = "Checkpoint - City loop"
