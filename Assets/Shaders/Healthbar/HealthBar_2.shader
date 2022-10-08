Shader "Unlit/HealthBar_2"
{
    Properties
    {
        [NoScaleOffset] _Tex ("Texture", 2D) = "white" {}
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
            #define TAU 6.28318530718 

            sampler2D _Tex;
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
                float mask = _Percentage < i.uv.x;
                float4 outCol = tex2D(_Tex, float2(_Percentage, i.uv.y));
                float flash = (cos(_Time.y * .6 * TAU)+1) * .2 + 1;
                
                if(_Percentage < .2)
                {
                    outCol *= flash;
                }

                return lerp(outCol, float4(0,0,0,1), mask);
            }
            ENDCG
        }
    }
}
