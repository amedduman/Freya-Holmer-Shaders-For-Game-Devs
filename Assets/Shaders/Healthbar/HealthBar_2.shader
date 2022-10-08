Shader "Unlit/HealthBar_2"
{
    Properties
    {
        _Tex ("Texture", 2D) = "white" {}
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

            float4 frag (v2f i) : SV_Target
            {
                float uvx = i.uv.x; 
                if(uvx < _Percentage)
                {
                    if(_Percentage < .2)
                    {
                        if(_Time.y%1 == 0)
                        {
                            return float4(1,1,1,1);
                        }
                        return tex2D(_Tex, i.uv);
                    }
                    else
                    {
                        return tex2D(_Tex, i.uv);
                    }
                }
                else
                {
                    discard;
                    return float4(0,0,0,0);
                }
            }
            ENDCG
        }
    }
}
