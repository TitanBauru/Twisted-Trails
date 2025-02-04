///@ignore
/*
+========================================================
||
||	Script de adicao dos atores.
||
||	Cada ator possui propriedades que sao aplicadas
||	no momento do diálogo.
||
+========================================================	
*/


// Exemplo de macro pra usar no nome dos atores
#macro ACTOR_SYSTEM		"system"
#macro ACTOR_mauricio	"rapha"
#macro ACTOR_PLAYER		"player"
#macro ACTOR_SIGN		"wood_sign"
#macro ACTOR_SENSEI		"sensei"


global.actors = {	
	system:		new TextboxActor("", undefined, snd_dialog_1, 1),
	rapha:	new TextboxActor("Dev. Titan", undefined,snd_dialog_1,1)
	
};

return global.actors;