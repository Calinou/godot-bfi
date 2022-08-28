extends CanvasLayer

## If `true`, enables black frame insertion (BFI).
var bfi_enabled := true

## The opacity of each black frame.
## Higher values result in less ghosting at the cost of more flickering.
var bfi_intensity := 0.5

## The number of black frames to display.
## Higher values result in less ghosting at the cost of more flickering.
var bfi_frames := 1



func _ready() -> void:
	update_label()


func _process(_delta: float):
	if bfi_enabled:
		%BlackFrame.modulate.a = bfi_intensity if Engine.get_process_frames() % (bfi_frames + 1) >= 1 else 0.0
	else:
		%BlackFrame.modulate.a = 0.0


func _input(event: InputEvent):
	if event.is_action_pressed("bfi_toggle"):
		bfi_enabled = not bfi_enabled
		update_label()

	if event.is_action_pressed("bfi_increase_intensity"):
		bfi_intensity = clamp(bfi_intensity + 0.1, 0.0, 1.0)
		update_label()

	if event.is_action_pressed("bfi_decrease_intensity"):
		bfi_intensity = clamp(bfi_intensity - 0.1, 0.0, 1.0)
		update_label()
	
	if event.is_action_pressed("bfi_increase_frames"):
		bfi_frames = clamp(bfi_frames + 1, 1, 2)
		update_label()

	if event.is_action_pressed("bfi_decrease_frames"):
		bfi_frames = clamp(bfi_frames - 1, 1, 2)
		update_label()


func update_label() -> void:
	%Label.text = "Black Frame Insertion: %s" % ("Enabled" if bfi_enabled else "Disabled")
	if bfi_enabled:
		%Label.text += \
"""
BFI Strength: %d%%
BFI Frame Interval: %d/%d""" % [round(bfi_intensity * 100), bfi_frames, bfi_frames + 1]
