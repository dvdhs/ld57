extends Control

class_name InventoryUI

@export var inventory_path: NodePath
@onready var inventory: Inventory = get_node(inventory_path)

@onready var slots_container = $SlotsContainer
@onready var item_description = $ItemDescription

var slot_scene = preload("res://inventory_slot.tscn")  # Create this scene with the InventorySlot script
var selected_slot = -1

func _ready():
	# Connect signals
	inventory.connect("inventory_changed", _on_inventory_changed)

	# Create inventory slots
	for i in range(inventory.max_slots):
		var slot = slot_scene.instantiate()
		slot.slot_index = i
		slot.connect("item_clicked", _on_slot_clicked)
		slots_container.add_child(slot)

	# Initial update
	update_inventory_display()

func update_inventory_display():
	# Update all slots
	for i in range(inventory.max_slots):
		var slot = slots_container.get_child(i)
		var item = inventory.get_item(i)
		slot.update_slot(item)

func _on_inventory_changed():
	update_inventory_display()

func _on_slot_clicked(slot_index):
	selected_slot = slot_index

	# Show item description if there's an item in this slot
	var item = inventory.get_item(slot_index)
	if item:
		item_description.text = item.name + "\n" + item.description
	else:
		item_description.text = ""

func _on_use_button_pressed():
	if selected_slot >= 0:
		var item = inventory.get_item(selected_slot)
		if item:
			var player = get_tree().get_first_node_in_group("player")
			if player and item.use(player):
				# If item was consumed, remove it from inventory
				inventory.remove_item(selected_slot)
