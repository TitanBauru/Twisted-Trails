// No objeto: obj_item
// Step Event

// Animação de flutuação
float_height = sin(current_time * float_speed) * 5;

// Se não estiver em uma loja, flutua livremente
if (shop_base == noone) {
    y = ystart;
} else {
    // Se estiver em uma loja, a posição Y é controlada pela base
    y = shop_base.y - 32;
}


// Verificar proximidade do jogador (se não estiver em uma loja)
if (shop_base == noone) {
    var _player = instance_nearest(x, y, obj_player);
    if (_player != noone && distance_to_object(_player) < 40 && !collected) {
        // Efeito de atração
        if (variable_instance_exists(id, "destroy_on_contact") && destroy_on_contact) {
            // Para itens que são coletados instantaneamente
            move_towards_point(_player.x, _player.y, 3);
            
            // Coletar ao tocar
            if (distance_to_object(_player) < 10) {
                collect_item();
            }
        }
    }
}