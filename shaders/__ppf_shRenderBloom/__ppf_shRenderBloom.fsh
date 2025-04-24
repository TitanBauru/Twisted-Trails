
/*------------------------------------------------------------------
You cannot redistribute this pixel shader source code anywhere.
Only compiled binary executables. Don't remove this notice, please.
Copyright (C) 2025 Mozart Junior (FoxyOfJungle). Kazan Games Ltd.
Website: https://foxyofjungle.itch.io/ | Discord: @foxyofjungle
-------------------------------------------------------------------*/

#define IS_ADDITIVE // comment this if not

varying vec2 v_vTexcoord;

uniform vec2 u_texelSize;
uniform vec2 u_resolution;
uniform vec3 u_bloomColor;
uniform float u_bloomIntensity;
uniform float u_bloomWhiteAmount;
uniform float u_bloomDirtEnable;
uniform float u_bloomDirtIntensity;
uniform float u_bloomDirtScale;
uniform float u_bloomDirtCanDistort;
uniform float u_bloomDirtIsTiled;
uniform sampler2D u_bloomTexture;
uniform sampler2D u_bloomDirtTexture;
uniform vec4 u_bloomDirtTexUVs;

// >> dependencies
uniform float u_lensDistortionEnable;
uniform float u_lensDistortionAmount;
vec2 ApplyLensDistortionUV(vec2 uv, float intensity) {
	vec2 uvCenter = vec2(0.5);
	vec2 dir = (uv - uvCenter);
	float polar = atan(dir.y, dir.x);
	float radius = length(dir);
	radius *= (1.0 + pow(radius, 2.0) * u_lensDistortionAmount * intensity);
	uv = uvCenter + radius * vec2(cos(polar), sin(polar));
	return uv;
}

// >> effect
#region Common
vec3 Saturate(vec3 x) {
    return clamp(x, 0.0, 1.0);
}

vec2 Tiling(vec2 uv, vec2 tiling) {
	uv = (uv - 0.5) * tiling + 0.5;
	return mod(uv, 1.0);
}

vec2 TilingMirror(vec2 uv, vec2 tiling) {
	uv = (uv - 0.5) * tiling + 0.5;
	uv = abs(mod(uv - 1.0, 2.0) - 1.0);
	return uv;
}

const vec3 lum_weights = vec3(0.2126, 0.7152, 0.0722);
float GetLuminance(vec3 color) {
	return dot(color, lum_weights);
}

vec3 Blend(vec3 source, vec3 dest) {
	return source + dest - source * dest;
}

vec3 Blend(vec3 source, vec4 dest) {
	return dest.rgb * dest.a + source * (1.0-dest.a);
}

vec4 Blend(vec4 source, vec4 dest) {
	return dest * dest.a + source * (1.0-dest.a);
}

vec2 GetAspectRatio(vec2 size, vec2 res) {
	float aspect_ratio = res.x / res.y;
	return (res.x > res.y)
	? vec2(size.x * aspect_ratio, size.y)
	: vec2(size.x, size.y / aspect_ratio);
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
	vec4 destinationTex = texture2D(gm_BaseTexture, uv);
	
	vec3 bloom = texture2D(u_bloomTexture, uv).rgb; // alpha is 1 by default
	
	// blend
	bloom = mix(bloom, vec3(1.0), GetLuminance(bloom) * u_bloomWhiteAmount);
	bloom *= u_bloomColor * u_bloomIntensity;
	#ifdef IS_ADDITIVE
		destinationTex.rgb += bloom;
	#else
		bloom = TonemapJodieReinhard(bloom);
		destinationTex.rgb = Blend(destinationTex.rgb, bloom);
	#endif
	// lens
	if (u_bloomDirtEnable > 0.5) {
		if (u_lensDistortionEnable > 0.5 && u_bloomDirtCanDistort > 0.5) {
			uv = ApplyLensDistortionUV(uv, 1.0);
		}
		vec2 uvDirt = (u_bloomDirtIsTiled > 0.5) ? TilingMirror(uv, GetAspectRatio(vec2(u_bloomDirtScale), u_resolution)) : Tiling(uv, vec2(u_bloomDirtScale));
		vec3 dirtTex = texture2D(u_bloomDirtTexture, mix(u_bloomDirtTexUVs.xy, u_bloomDirtTexUVs.zw, uvDirt)).rgb * bloom * u_bloomDirtIntensity;
		#ifdef IS_ADDITIVE
			destinationTex.rgb += dirtTex;
		#else
			dirtTex = TonemapJodieReinhard(dirtTex);
			destinationTex.rgb = Blend(destinationTex.rgb, dirtTex);
	#endif
	}
	gl_FragColor = destinationTex;
}
