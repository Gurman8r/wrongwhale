# pack_data.gd
class_name PackData
extends Resource

@export var guid: String           = "Pack"
@export var name: String           = "Pack"
@export var tagline: String        = "Tagline"
@export var description: String    = "Description"
@export var version: String        = "0.0.0.0"
@export var path: String           = Packs.PACKS_PATH
@export var depends: Array[String] = []
