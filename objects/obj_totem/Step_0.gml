// No objeto: obj_shop_base
// Step Event

// Verificar proximidade do jogador
var _player = instance_nearest(x, y, obj_player);
if (_player != noone && distance_to_object(_player) < 100) {
    // Ativar quando o jogador está próximo
    active = true;
    glow_intensity = lerp(glow_intensity, 0.7, 0.05);
    
    // Ligeiro tremor quando ativo
    shake_amount = 0
    
    // Aumentar taxa de emissão de partículas
    part_emitter_stream(particle_system, emitter, particle_glow, -4); // ~1 partícula a cada 2 steps
    
    
} else {
    // Desativar quando o jogador está longe
    if (active) active_changed = true;
    active = false;
    glow_intensity = lerp(glow_intensity, 0.2, 0.05);
    shake_amount = 0
    
    // Reduzir taxa de emissão de partículas
    part_emitter_stream(particle_system, emitter, particle_glow, -7);
}

// Efeito de flutuação
float_offset = 0;

// Ajustar posição do emitter de partículas
part_emitter_region(particle_system, emitter, 
                   x-20, x+20, 
                   y-20 + float_offset, y+5 + float_offset, 
                   ps_shape_ellipse, ps_distr_gaussian);

// Se o item está associado, atualizar sua posição para acompanhar o totem
if (shop_item != noone && instance_exists(shop_item)) {
    shop_item.y = y - 32 + float_offset;
}