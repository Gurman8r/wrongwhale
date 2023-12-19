# prefabs_.gd
# Prefabs
extends Node

const GODOT_ICON := preload("res://icon.svg")

const DEFAULT_ENVIRONMENT := preload("res://assets/data/default_environment.tres")
const DEFAULT_PLAYER := preload("res://assets/data/default_player.tres")
const DEFAULT_REGISTRY := preload("res://assets/data/default_registry.tres")
const DEFAULT_SETTINGS := preload("res://assets/data/default_settings.tres")

const DEBUG_OVERLAY := preload("res://assets/scenes/debug_overlay.tscn") 
const DEBUG_INTERFACE := preload("res://assets/scenes/debug_interface.tscn")
const PLAYER_OVERLAY := preload("res://assets/scenes/player_overlay.tscn") 
const PLAYER_INTERFACE := preload("res://assets/scenes/player_interface.tscn")
const TITLE_INTERFACE := preload("res://assets/scenes/title_interface.tscn") 
const SPLASH_OVERLAY := preload("res://assets/scenes/splash_overlay.tscn") 
const TRANSITION_OVERLAY := preload("res://assets/scenes/transition_overlay.tscn") 

const WORLD_LOADER_PREVIEW := preload("res://assets/scenes/world_loader_preview.tscn")
const INVENTORY_SLOT := preload("res://assets/scenes/inventory_slot.tscn")

const WORLD_CELLS := preload("res://assets/scenes/world_cells.tscn")
const ITEM_DROP := preload("res://assets/scenes/item_drop.tscn")
const ACTOR_CHARACTER := preload("res://assets/scenes/actor_character.tscn")
const PLAYER_CHARACTER := preload("res://assets/scenes/player_character.tscn")
