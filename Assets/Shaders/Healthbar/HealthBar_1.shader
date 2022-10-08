Shader "Unlit/HealthBar_1"
{
    Properties
    {
        _ColorHealthHigh ("Color Health High", Color) = (1,1,1,1)
        _HealthHighLimit ("Health High Limit", Range(0, 1)) = .8
        _ColorHealthLow ("Color Health Low", Color) = (1,1,1,1)
        _HealthLowLimit ("Health Low Limit", Range(0, 1)) = .3
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
            float _HealthHighLimit;
            float4 _ColorHealthLow;
            float _HealthLowLimit;
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

            float4 frag (v2f i) : SV_Target
            {
                float uvx = i.uv.x; 
                if(uvx < _Percentage)
                {
                    if(_Percentage > _HealthHighLimit)
                    {
                        return _ColorHealthHigh;
                    }
                    else if(_Percentage < _HealthHighLimit && _Percentage > _HealthLowLimit)
                    {
                        return lerp(_ColorHealthLow, _ColorHealthHigh, uvx);
                    }
                    else if(_Percentage < _HealthLowLimit)
                    {
                        return _ColorHealthLow;
                    }
                    else
                    {
                        return float4(1,1,1,1);
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
