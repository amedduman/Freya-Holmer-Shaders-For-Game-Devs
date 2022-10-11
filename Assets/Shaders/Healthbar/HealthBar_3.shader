Shader "Unlit/HealthBar_3"
{
    Properties
    {
        _Radius ("Radius", Range(0,1)) = 0
        _Percentage ("Percentage", Range(0,1)) = 1
        [NoScaleOffset] _Tex ("Texture", 2D) = "white" {}
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


            float _Radius;
            float _Percentage;
            sampler2D _Tex;

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
                float2 coords = i.uv;
                coords.x *= 8;
                float2 pointOnLineSeg = float2(clamp(coords.x, 0.5, 7.5), 0.5);
                float sdf = distance(coords, pointOnLineSeg) - _Radius; 
                float mask = step(sdf, 0);
                clip(mask - .5);
                // return float4(1,1,1,1);  

                float healthMask = _Percentage < i.uv.x;
                float4 outCol = tex2D(_Tex, float2(_Percentage, i.uv.y));
                float flash = (cos(_Time.y * .6 * TAU)+1) * .2 + 1;
                
                if(_Percentage < .2)
                {
                    outCol *= flash;
                }

                return lerp(outCol, float4(0,0,0,1), healthMask);
            }
            ENDCG
        }
    }
}
