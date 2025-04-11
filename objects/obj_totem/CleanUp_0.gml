// No objeto: obj_shop_base
// Clean Up Event

// Limpar recursos para evitar memory leaks
part_type_destroy(particle_glow);
part_emitter_destroy(particle_system, emitter);
part_system_destroy(particle_system);

// Destruir o item associado se ainda existir
if (shop_item != noone && instance_exists(shop_item)) {
    instance_destroy(shop_item);
}