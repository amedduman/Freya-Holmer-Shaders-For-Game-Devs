Shader "Unlit/Lighting_1"
{
    Properties
    {
        _Gloss ("Gloss", float) = 1
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            #define TAU 6.28318530718 

            float _Gloss;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
                float3 wPos : TEXCOORD2;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.wPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            float InverseLerp(float a, float b, float t)
            {
                return (t-a) / (b-a);
            }

            float4 frag (v2f i) : SV_Target
            {
                float3 N = normalize(i.normal);
                float3 L = _WorldSpaceLightPos0.xyz; // direction to the directional light in the scene.
                float3 diffuseCol = saturate(dot(N, L)) * _LightColor0.xyz; 

                float3 dirToCam = normalize(_WorldSpaceCameraPos - i.wPos);

                // phong
                // float3 reflectedVector = reflect(-L, N);
                // float specularLight = saturate(dot(reflectedVector, dirToCam));
                // specularLight = pow(specularLight, _Gloss);

                float3 halfVector = normalize(dirToCam + L);
                float specularLihgt = saturate(dot(halfVector, N));
                specularLihgt = pow(specularLihgt, _Gloss);

                return float4(specularLihgt.xxx, 1);
            }
            ENDHLSL
        }
    }
}
