
/*------------------------------------------------------------------
You cannot redistribute this pixel shader source code anywhere.
Only compiled binary executables. Don't remove this notice, please.
Copyright (C) 2025 Mozart Junior (FoxyOfJungle). Kazan Games Ltd.
Website: https://foxyofjungle.itch.io/ | Discord: @foxyofjungle
-------------------------------------------------------------------*/

varying vec2 v_vPosition;
varying vec2 v_vTexcoord;

// quality (low number = more performance)
#ifdef _YY_HLSL11_
#define ITERATIONS 12.0 // windows
#else
#define ITERATIONS 8.0 // others (android, operagx...)
#endif

uniform vec2 u_texelSize;
uniform float u_intensity;
uniform float u_radius;
uniform float u_limiar;

#define Tau 6.283185307179586
const float KERNEL_RECIPROCAL = Tau / ITERATIONS;

void main() {
	vec4 colTex = texture2D(gm_BaseTexture, v_vTexcoord);
	vec4 sharpen = vec4(0.0);
	vec2 offset = u_texelSize * u_radius;
	for (float i = 0.0; i < Tau; i+=KERNEL_RECIPROCAL) {
		sharpen += texture2D(gm_BaseTexture, v_vTexcoord + offset * vec2(cos(i), sin(i)), u_limiar);
	}
	sharpen /= ITERATIONS;
	gl_FragColor = colTex + u_intensity * (colTex-sharpen);
}
