/// @description Insert description here
// You can write your code in this editor
x += velh;
y += velv;

// Desaceleração
if (!estou_movendo) {
    velh = abs(velh) <= 0.2 ? 0 : lerp(velh, 0, aceleracao * 2);
    velv = abs(velv) <= 0.2 ? 0 : lerp(velv, 0, aceleracao * 2);
}
