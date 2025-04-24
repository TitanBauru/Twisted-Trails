
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

// >> uniforms
uniform vec2 u_resolution;
uniform vec2 u_vectorDir;
uniform float u_radius;
uniform vec2 u_center;
uniform float u_maskPower;
uniform float u_maskScale;
uniform float u_maskSmoothness;
uniform sampler2D u_noiseTexture;
uniform vec4 u_noiseUVs;
uniform vec2 u_noiseSize;

float MaskRadial(vec2 uv, vec2 center, float power, float scale, float smoothness) {
	float smoothh = mix(scale, 0.0, smoothness);
	float sc = scale / 2.0;
	float mask = pow(1.0-clamp((length(uv-center)-sc) / ((smoothh-0.001)-sc), 0.0, 1.0), power);
	return mask;
}

void main() {
	float mask = MaskRadial(v_vTexcoord, u_center, u_maskPower, u_maskScale, u_maskSmoothness);
	vec2 offset = u_vectorDir * mask * u_radius;
	offset /= (u_resolution / min(u_resolution.x, u_resolution.y));
	float noise = texture2D(u_noiseTexture, mix(u_noiseUVs.xy, u_noiseUVs.zw, fract(v_vPosition/u_noiseSize))).r;
	vec4 blur = vec4(0.0);
	for(float i = 0.0; i < ITERATIONS; i+=1.0) {
		float percent = (i + noise) / ITERATIONS;
		blur += texture2D(gm_BaseTexture, v_vTexcoord + (percent*2.0-1.0) * offset);
	}
	gl_FragColor = blur / ITERATIONS;
}
