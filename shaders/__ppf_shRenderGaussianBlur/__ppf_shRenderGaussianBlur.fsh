
/*------------------------------------------------------------------
You cannot redistribute this pixel shader source code anywhere.
Only compiled binary executables. Don't remove this notice, please.
Copyright (C) 2025 Mozart Junior (FoxyOfJungle), Tobias Fleischer.
Website: https://foxyofjungle.itch.io/ | Discord: @foxyofjungle
-------------------------------------------------------------------*/

precision highp float;

varying vec2 v_vPosition;
varying vec2 v_vTexcoord;

uniform vec2 u_resolution;
uniform float u_gaussianAmount;
uniform vec2 u_gaussianDirection;

const float radius = 20.0;
const float dev = 7.0;
const float mean = 0.398942280401 / dev;

float coeff(float x) {
	return mean * exp(-x * x * 0.5 / (dev * dev));
}

void main() {
	vec2 offset = u_gaussianDirection * u_gaussianAmount;
	offset /= (u_resolution / min(u_resolution.x, u_resolution.y));
	vec4 sum = vec4(0.0);
	for (float i = -radius; i <= radius; i++) {
		sum += coeff(i) * texture2D(gm_BaseTexture, v_vTexcoord + offset * i);
	}
	gl_FragColor = sum;
}
