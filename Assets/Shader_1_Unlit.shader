Shader "Unlit/Shader_1_Unlit"
{
    Properties
    {
        _ColorA ("Color A", Color) = (.25, .5, .5, 1) 
        _ColorB ("Color B", Color) = (.25, .5, .5, 1)
        _ColorStart ("Color Start", Range(0,1)) = 0
        _ColorEnd ("Color End", Range(0, 1)) = 1
        [MaterialToggle] _VerticalGradient ("Vertical Gradient", int) = 0

        _Offset ("UV Offset", float) = 0
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

            float4 _ColorA;
            float4 _ColorB;
            float _ColorStart;
            float _ColorEnd;
            bool _VerticalGradient;
            float _Offset;

            struct MeshData // mesh data per vertex
            {
                float4 vertex : POSITION; // vertex pos
                float3 normals : NORMAL;
                float2 uv0 : TEXCOORD0; // uv0 pos of vertex
            };

            struct v2f // data passed from vertex shader to fragment shader
            {
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
                float4 vertex : SV_POSITION; // clip space position of each vertex
            };

            float InverseLerp(float a, float b, float t)
            {
                return (t-a) / (b-a);
            }

            v2f vert (MeshData v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex); // convert local space to clip space
                // o.normal = v.normals; // local space normals
                o.normal = UnityObjectToWorldNormal(v.normals); // world space normals
                //o.uv = float2(v.uv0.x + _Offset, v.uv0.y);
                o.uv = v.uv0;
                return o;
            }

            float4 frag (v2f i) : SV_Target // we can use float4 instead of fixed4 (fixed has less precission so it is about performance)
            {
                // return float4(i.normal, 1); // return normals
                //return float4(i.uv, 0, 1); // show only one x axis of UV

                float t = InverseLerp(_ColorStart, _ColorEnd, i.uv.x);

                if(_VerticalGradient == 1)
                {
                    return lerp(_ColorA, _ColorB, t);
                }
                else
                {
                    return lerp(_ColorA, _ColorB, t);
                }
            }
            ENDCG
        }
    }
}
