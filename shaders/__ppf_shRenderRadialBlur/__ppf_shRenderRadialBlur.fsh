
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
#define ITERATIONS 32.0 // windows
#else
#define ITERATIONS 16.0 // others (android, operagx...)
#endif

uniform float u_radius;
uniform vec2 u_center;
uniform float u_inner;
uniform sampler2D u_noiseTexture;
uniform vec2 u_noiseSize;
uniform vec4 u_noiseUVs;

void main() {
	vec2 uv = v_vTexcoord;
	float offset = pow(length(uv-u_center), u_inner) * u_radius;
	vec2 center = u_center-uv;
	float noise = texture2D(u_noiseTexture, mix(u_noiseUVs.xy, u_noiseUVs.zw, fract(v_vPosition/u_noiseSize))).r;
	vec4 blur = vec4(0.0);
	for(float i = 0.0; i < ITERATIONS; i+=1.0) {
		float percent = (i + noise) / ITERATIONS;
		blur += texture2D(gm_BaseTexture, uv + center * percent * offset);
	}
	gl_FragColor = blur / ITERATIONS;
}
