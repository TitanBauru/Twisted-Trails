
if (!variable_instance_exists(id, "mapa_gerado")) {
    mapa_gerado = true; // Flag pra evitar repetir

    // Quantidade inicial de inimigos
    var _iniqtd = instance_number(obj_dummy);
    var _inimigo_qtd_max = inimigo_qtd_max; // Certifique-se que essa var existe globalmente ou passe como parâmetro
    
    // Só spawna se o jogador existe e a quantidade de inimigos está abaixo do limite
    if (instance_exists(obj_player) && _iniqtd < _inimigo_qtd_max) {
        var _tentativas = 0;
        var _max_tentativas = 50; // Limite pra evitar loop infinito
        var _inimigos_a_spawnar = min(_inimigo_qtd_max - _iniqtd, 10); // Limita quantos spawnar de uma vez (ajuste o 10 se precisar)
        
        repeat (_inimigos_a_spawnar) {
            _tentativas = 0;
            var _pos_valida = false;
            var _x, _y, _inst;
            
            // Tenta encontrar uma posição válida
            while (!_pos_valida && _tentativas < _max_tentativas) {
                _x = irandom_range(4 * 32, room_width - (4 * 32));
                _y = irandom_range(4 * 32, room_height - (4 * 32));
                
                // Verifica distância do jogador
                var _dist = point_distance(_x, _y, obj_player.x, obj_player.y);
                
                if (_dist > 128) {
                    // Cria o inimigo temporariamente
                    _inst = instance_create_layer(_x, _y, "Instances", obj_dummy);
                    
                    if (instance_exists(_inst)) {
                        // Checa colisão com obj_vacuo
                        var _col = collision_circle(_inst.x, _inst.y, 24, obj_vacuo, true, true);
                        
                        if (!_col) {
                            _pos_valida = true; // Posição válida, mantém o inimigo
                        } else {
                            instance_destroy(_inst); // Colidiu, destrói e tenta de novo
                        }
                    }
                }
                _tentativas++;
            }
            
            // Se não encontrou posição válida após várias tentativas, para o loop
            if (!_pos_valida) {
                break;
            }
        }
    }
}