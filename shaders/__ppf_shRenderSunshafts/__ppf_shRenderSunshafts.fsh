
/*------------------------------------------------------------------
You cannot redistribute this pixel shader source code anywhere.
Only compiled binary executables. Don't remove this notice, please.
Copyright (C) 2025 Mozart Junior (FoxyOfJungle). Kazan Games Ltd.
Website: https://foxyofjungle.itch.io/ | Discord: @foxyofjungle
-------------------------------------------------------------------*/

#define IS_ADDITIVE // comment this if not

// quality (low number = more performance)
#ifdef _YY_HLSL11_
#define ITERATIONS 24.0 // windows
#else
#define ITERATIONS 16.0 // others (android, operagx...)
#endif

precision highp float;

varying vec2 v_vPosition;
varying vec2 v_vTexcoord;

uniform vec2 u_resolution;
uniform float u_time;
uniform sampler2D u_sunshaftsNoiseTexture;
uniform vec2 u_sunshaftsNoiseSize;
uniform vec4 u_sunshaftsNoiseUVs;
uniform vec2 u_position;
uniform float u_threshold;
uniform float u_intensity;
uniform float u_dimmer;
uniform float u_scattering;
uniform sampler2D u_raysNoiseTexture;
uniform vec4 u_raysNoiseUVs;
uniform float u_raysNoiseEnable;
uniform float u_raysOcclusionRadius;
uniform float u_raysOcclusionSmoothness;
uniform float u_raysIntensity;
uniform float u_raysTiling;
uniform float u_raysSpeed;

const float ITERATIONS_RECIPROCAL = 1.0/ITERATIONS;

const float Tau = 6.28318;

#region Common
vec2 GetAspectRatio(vec2 uv, vec2 res) {
	float aspectRatio = res.x / res.y;
	return (res.x > res.y)
	? vec2(uv.x * aspectRatio, uv.y)
	: vec2(uv.x, uv.y / aspectRatio);
}

const vec3 lum_weights = vec3(0.2126, 0.7152, 0.0722);
float GetLuminance(vec3 color) {
	return dot(color, lum_weights);
}
#endregion

#region Tone Mapping (for non-additive only)
vec3 TonemapJodieReinhard(vec3 c) {
	vec3 tc = c / (c + 1.0);
	return mix(c / (GetLuminance(c) + 1.0), tc, tc);
}

vec3 tonemap_reinhard(vec3 v) {
    return v / (1.0 + v);
}
#endregion

void main() {
	vec2 uv = v_vTexcoord;
	// rays mask
	float raysNoise = 1.0;
	if (u_raysNoiseEnable > 0.5) {
		vec2 polarCenterUV = GetAspectRatio(uv-u_position, u_resolution);
		float polarLen = length(polarCenterUV);
		float raysMask = smoothstep(u_raysOcclusionRadius-u_raysOcclusionSmoothness, u_raysOcclusionRadius, polarLen);
		vec2 uvNoiseRays = vec2((polarLen*0.01) - (u_time*u_raysSpeed), atan(polarCenterUV.y, polarCenterUV.x) * (1.0/Tau) * u_raysTiling);
		raysNoise = mix(raysNoise, min(texture2D(u_raysNoiseTexture, mix(u_raysNoiseUVs.xy, u_raysNoiseUVs.zw, fract(uvNoiseRays))).r, 1.0), raysMask*u_raysIntensity);
	}
	// godrays
	float offsetNoise = texture2D(u_sunshaftsNoiseTexture, mix(u_sunshaftsNoiseUVs.xy, u_sunshaftsNoiseUVs.zw, fract(v_vPosition/u_sunshaftsNoiseSize))).r;
	vec2 center = u_position - uv;
	float lumWeight = u_dimmer;
	float scattering = clamp(u_scattering, 0.0, 1.0);
	vec3 godrays = vec3(0.0);
	for(float i = 0.0; i < ITERATIONS; i++) {
		float reciprocal = (i + offsetNoise) / ITERATIONS;
		vec3 tex = texture2D(gm_BaseTexture, uv + (center * reciprocal * scattering)).rgb * raysNoise;
		godrays += max(tex-u_threshold, 0.0) * lumWeight;
		lumWeight *= (1.0-ITERATIONS_RECIPROCAL);
	}
	vec3 godraysCol = max((godrays / ITERATIONS) * u_intensity, 0.0);
	godraysCol *= step(-0.5, u_position.x+u_position.y); // occlude if position is negative
	#ifndef IS_ADDITIVE
	godraysCol = TonemapJodieReinhard(godraysCol);
	#endif
	gl_FragColor = vec4(godraysCol, 1.0);
}
