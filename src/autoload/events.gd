@icon("uid://cgk0r18gd4nq8")
extends Node


@warning_ignore("unused_signal")
signal entity_spawned(entity: Entity3D)
@warning_ignore("unused_signal")
signal entity_destroyed(entity: Entity3D, killer_signature: int)
@warning_ignore("unused_signal")
signal player_spawned(player: Player3D)
@warning_ignore("unused_signal")
signal player_destroyed(player: Player3D, killer_signature: int)
@warning_ignore("unused_signal")
signal wave_spawned(wave: Wave)
