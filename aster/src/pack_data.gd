# pack_data.gd
class_name PackData
extends Resource

@export var guid: String = "Pack"
@export var name: String = "Pack"
@export var version: String = "0.0.0.0"
@export var tagline: String = "Tagline"
@export var description: String = "Description"
@export var depends: Array[String] = []

@export var icon: Texture2D
@export var banner: Texture2D
@export var background: Texture2D
