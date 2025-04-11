// No objeto: obj_shop_base
// Alarm 0 Event
if (!item_spawned && item_id_to_spawn >= 0) {
    // Criar o item
    shop_item = instance_create_layer(x, y - 32, layer, obj_item_pai);
    
    // Configurar o item APÓS a criação
    with (shop_item) {
        setup_item(other.item_id_to_spawn);  // Chame aqui, uma única vez
        shop_base = other.id;
    }
    
    item_spawned = true;
}