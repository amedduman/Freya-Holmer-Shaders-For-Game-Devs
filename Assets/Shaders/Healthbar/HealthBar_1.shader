Shader "Unlit/HealthBar_1"
{
    Properties
    {
        _ColorHealthHigh ("Color Health High", Color) = (1,1,1,1)
        _ColorHealthLow ("Color Health Low", Color) = (1,1,1,1)
        _Percentage ("Percentage", Range(0,1)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float4 _ColorHealthHigh;
            float4 _ColorHealthLow;
            float4 _ColorBackground;
            float _Percentage;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float InverseLerp(float a, float b, float t)
            {
                return (t-a) / (b-a);
            }

            float4 frag (v2f i) : SV_Target
            {
                float uvx = i.uv.x; 

                float mask = _Percentage > uvx;
                float tPercentage = InverseLerp(.4, .7, _Percentage);
                float4 outColor = lerp(_ColorHealthLow, _ColorHealthHigh, tPercentage);

                clip(mask - .5);

                return outColor * mask;
            }
            ENDCG
        }
    }
}
