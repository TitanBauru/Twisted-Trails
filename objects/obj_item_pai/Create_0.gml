// No objeto: obj_item
// Create Event

// Propriedades básicas do item
item_id = -1;              // ID do item no banco de dados
sprite_index = spr_dokrl;  // Sprite do item
item_name = "";            // Nome do item
item_description = "";     // Descrição do item
price = 0;                 // Preço (para loja)
rarity = "";               // Raridade do item
collected = false;         // Item foi coletado?
effects = {};              // Efeitos do item (referência à struct)

// Propriedades de animação
float_height = 0;
float_speed = 0.05;
rotation = 0;
scale = 1;
glow_alpha = 0;

// Referências
shop_base = noone;         // Referência à base da loja (se estiver em uma loja)

// Função para configurar o item com base no ID
function setup_item(_item_id) {
    if (_item_id < 0 || _item_id >= global.total_items) {
        show_debug_message("Erro: ID de item inválido: " + string(_item_id));
        return false;
    }
    
    var _item_data = global.items[_item_id];
    if (_item_data == undefined) {
        show_debug_message("Erro: Item não existe no banco de dados: " + string(_item_id));
        return false;
    }
    
    // Configurar propriedades básicas
    item_id = _item_id;
    //sprite_index = _item_data.sprite_index;
    item_name = _item_data.name;
    item_description = _item_data.description;
    price = _item_data.price;
    rarity = _item_data.rarity;
    effects = _item_data.effects;
    
    // Configurar propriedades específicas com base no tipo de item
    switch (item_id) {
        // ITENS DE CURA
        case 0: // "Medkit"
            sprite_index = spr_capsula;  // Adicionei ponto e vírgula
            glow_color = c_lime;
            break;
            
        case 1: // "Tênis Supersônico"
            // Configurações específicas para o tênis
            float_speed = 0.06; // Flutua um pouco mais rápido
            glow_color = c_aqua;
            break;
            
        case 2: // "Luvas de Poder"
            glow_color = c_red;
            rotation_speed = 0.2;
            break;
            
        case 3: // "Coração de Cristal"
            glow_color = c_fuchsia;
            pulse_intensity = 1.5;
            break;
            
        case 4: // "Poção de Cura"
            // Este é um item de uso único
            glow_color = c_lime;
            destroy_on_contact = true;
            break;
            
        // Continue adicionando casos para cada item no seu jogo
        // ...
            
        default:
            // Configurações padrão para qualquer outro item
            glow_color = c_white;
            break;
    }
    
    return true;
}

// Função para ser chamada quando o jogador coleta o item
function collect_item() {
    
    // Tocar som
    
    // Aplicar efeitos ao jogador
    if (instance_exists(obj_player) && instance_exists(obj_player_inventory)) {
        obj_player_inventory.collect_item(item_id);
    }
    
    // Iniciar animação de coleta
    // Sua lógica de animação aqui
    
    // Destruir após um delay (se necessário)
    alarm[0] = 1;
}