// Crest Ocean System

// This file is subject to the MIT License as seen in the root of this folder structure (LICENSE)

// Ocean LOD data - data, samplers and functions associated with LODs

// comment out to disable weather maker integration
// feel free to replace with your favorite asset
#define USE_EXTERNAL_SHADERS

#if defined(USE_EXTERNAL_SHADERS)

#include "../../../WeatherMaker/Prefab/Shaders/WeatherMakerFogExternalShaderInclude.cginc"

static fixed3 crest_ExternalDirLightColor = (_WeatherMakerDirLightColor[0].rgb * _WeatherMakerDirLightColor[0].a);

#define CREST_PRIMARY_DIR_LIGHT_COLOR crest_ExternalDirLightColor
#define CREST_PRIMARY_DIR_LIGHT_DIR _WeatherMakerDirLightPosition[0].xyz

fixed OceanExternalShadow(float3 worldPos, float shadowValue)
{
	return max(0.2, ComputeWeatherMakerShadows(worldPos, shadowValue, false)); // true to sample shadow details, higher res shadow
}

fixed3 OceanExternalFog(fixed3 col, float3 worldPos)
{
	return col;
	// TODO: Completely bugged, fix later...
	//fixed4 fog = ComputeWeatherMakerFog(fixed4(col, 1.0), worldPos, true); // false for non-volumetric lighted fog
	//return fog.rgb; // ignore fog.a value
}

float3 CrestWorldSpaceLightDir(float3 worldPos)
{
	return _WeatherMakerDirLightPosition[0].xyz;
}

#else

#define CREST_PRIMARY_DIR_LIGHT_COLOR (_LightColor0.rgb * _LightColor0.a)
#define CREST_PRIMARY_DIR_LIGHT_DIR (_WorldSpaceLightPos0.xyz)

float3 CrestWorldSpaceLightDir(float3 worldPos)
{
	float3 lightDir = _WorldSpaceLightPos0.xyz;
	if (_WorldSpaceLightPos0.w > 0.)
	{
		// non-directional light - this is a position, not a direction
		lightDir = normalize(lightDir - worldPos.xyz);
	}
	return lightDir;
}

#endif
