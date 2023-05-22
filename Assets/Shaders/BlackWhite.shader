Shader "Tutorial/BlackWhite"
{
    Properties
    {
        _Threshold ("Threshold", Range(0, 1)) = 0
        [HDR] _BrightColor ("BrightColor", Color) = (1, 1, 1, 1)
        [HDR] _DarkBottom ("DarkBottom", Color) = (0, 0, 0, 0)
        [HDR] _DarkTop ("DarkTop", Color) = (0, 0, 0, 0)
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderPipeline"="UniversalPipeline" "LightMode"="UniversalForward" }

        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite Off
        ZTest Always

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/core.hlsl"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float4 color : TEXCOORD1;
            };

            float _Threshold;
            float4 _BrightColor;
            float4 _DarkBottom;
            float4 _DarkTop;
            
            sampler2D _CameraOpaqueTexture;

            v2f vert (appdata v)
            {
                v2f o;

                float4 vertex = float4(v.uv, 0, 1);
                #if UNITY_UV_STARTS_AT_TOP
                vertex.y = 1 - vertex.y;
                #endif
                vertex.xy = (vertex.xy * 2) - float2(1, 1);
                o.vertex = vertex;
                
                o.uv = v.uv;
                o.color = v.color;
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                float4 color = tex2D(_CameraOpaqueTexture, i.uv);
                float luminance = dot(color.rgb, float3(0.2125, 0.7154, 0.0721));
                if(luminance > _Threshold) {
                    color = lerp(color, _BrightColor, i.color.a);
                }
                else {
                    color = lerp(color, lerp(_DarkBottom, _DarkTop, i.uv.y), i.color.a);
                }

                return float4(color.rgb, i.color.a);
            }
            ENDHLSL
        }
    }
}