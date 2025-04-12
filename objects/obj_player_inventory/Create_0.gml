// No objeto: obj_player_inventory
// Create Event

// Array para armazenar IDs dos itens coletados
items_collected = [];

// Contadores para sistemas baseados em contagem
kill_count = 0;
shot_count = 0;
dash_count = 0;
dungeon_count = 0;

// Fazer o objeto persistir entre salas
persistent = true;

/// @function collect_item(item_id)
/// @description Adiciona um item ao inventário e aplica seus efeitos
function collect_item(item_id) {
    // Verificar se o item existe no banco de dados
    if (item_id < 0 || item_id >= global.total_items) {
        show_debug_message("Erro: ID de item inválido: " + string(item_id));
        return false;
    }
    
    // Adicionar ao inventário
    array_push(items_collected, item_id);
    
    // Obter o item do banco de dados
    var _item = global.items[item_id];
    
    // Aplicar efeitos não contínuos (de uso único) ao jogador
    if (instance_exists(obj_player)) {
        var _effect_names = variable_struct_get_names(_item.effects);
        
        for (var i = 0; i < array_length(_effect_names); i++) {
            var _effect_name = _effect_names[i];
            var _effect = _item.effects[$ _effect_name];
            
            // Aplicar apenas efeitos de uso único
            if (_effect.active && !_effect.is_continuous) {
                // Chamar a função do item_database para aplicar o efeito
                _item.apply_one_time_effect(obj_player, _effect_name, _effect.power_fx);
            }
        }
    }
    
    //// Atualizar interface do usuário (se necessário)
    //if (instance_exists(obj_ui_controller)) {
    //    with (obj_ui_controller) {
    //        update_items_display();
    //    }
    //}
    
    // Tocar som de coleta
    //audio_play_sound(snd_item_pickup, 5, false);
    
    return true;
}

/// @function has_item_effect(effect_name)
/// @description Verifica se o jogador tem algum item com o efeito especificado
function has_item_effect(effect_name) {
    for (var i = 0; i < array_length(items_collected); i++) {
        var _item = global.items[items_collected[i]];
        if (variable_struct_exists(_item.effects, effect_name) && _item.effects[$ effect_name].active) {
            return true;
        }
    }
    return false;
}

/// @function get_item_effect_power_fx(effect_name)
/// @description Retorna o poder de um efeito específico
function get_item_effect_power_fx(effect_name) {
    for (var i = 0; i < array_length(items_collected); i++) {
        var _item = global.items[items_collected[i]];
        if (variable_struct_exists(_item.effects, effect_name) && _item.effects[$ effect_name].active) {
            return _item.effects[$ effect_name].power_fx;
        }
    }
    return 0;
}

/// @function process_continuous_effects()
/// @description Processa todos os efeitos contínuos dos itens coletados
function process_continuous_effects() {
    if (!instance_exists(obj_player)) return;
    
    // Iterar pelos itens coletados
    for (var i = 0; i < array_length(items_collected); i++) {
        var _item = global.items[items_collected[i]];
        
        // Iterar pelos efeitos de cada item
        var _effect_names = variable_struct_get_names(_item.effects);
        for (var j = 0; j < array_length(_effect_names); j++) {
            var _effect_name = _effect_names[j];
            var _effect = _item.effects[$ _effect_name];
            
            // Processar apenas efeitos contínuos
            if (_effect.active && _effect.is_continuous) {
                // O objecto item_database saberá como processar cada efeito contínuo
                _item.process_continuous_effect(obj_player, _effect_name, _effect.power_fx, self);
            }
        }
    }
}

/// @function increment_kill_count()
/// @description Incrementa o contador de kills
function increment_kill_count() {
    kill_count++;
}

/// @function increment_shot_count()
/// @description Incrementa o contador de tiros
function increment_shot_count() {
    shot_count++;
}

/// @function reset_shot_count()
/// @description Reseta o contador de tiros (após um crítico garantido, por exemplo)
function reset_shot_count() {
    shot_count = 0;
}

/// @function increment_dash_count()
/// @description Incrementa o contador de dashes
function increment_dash_count() {
    dash_count++;
}

/// @function increment_dungeon_count()
/// @description Incrementa o contador de dungeons (ao entrar em uma nova dungeon)
function increment_dungeon_count() {
    dungeon_count++;
}

/// @function get_all_collected_items()
/// @description Retorna uma array com todos os itens coletados
function get_all_collected_items() {
    var items_info = [];
    
    for (var i = 0; i < array_length(items_collected); i++) {
        var _item = global.items[items_collected[i]];
        array_push(items_info, {
            id: items_collected[i],
            name: _item.name,
            description: _item.description,
            sprite: _item.sprite_index,
            rarity: _item.rarity
        });
    }
    
    return items_info;
}
