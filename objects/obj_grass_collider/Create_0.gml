/// @description Inserir descrição aqui
// Você pode escrever seu código neste editor
visible = false; // Não desenha (é apenas para colisão)
shadow = new Crystal_Shadow(id, CRYSTAL_SHADOW.STATIC);
shadow.AddMesh(new Crystal_ShadowMesh().FromSpriteRect(sprite_index));
//shadow.shadowLength = 10
shadow.Apply();
shadow.depth = -y