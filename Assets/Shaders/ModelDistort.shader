Shader "Tutorial/ModelDistort"
{
    Properties
    {
        _Mask ("Mask", 2D) = "white" {}
        _Noise ("Noise", 2D) = "white" {}
        _DistortStrength ("DistortStrength", Float) = 0
    }
    SubShader
    {
        Pass
        {
            Tags { "Queue"="Transparent" "RenderPipeline"="UniversalPipeline" "LightMode"="UniversalForward" }

            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            ZTest Always

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/core.hlsl"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
                float4 color : COLOR;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
                float4 screenPos : TEXCOORD2;
                float4 color : TEXCOORD3;
            };

            sampler2D _Mask;
            float4 _Mask_ST;
            sampler2D _Noise;
            float4 _Noise_ST;
            float _DistortStrength;

            float3 _DistortCenter;

            sampler2D _CameraOpaqueTexture;
            float4 _CameraOpaqueTexture_TexelSize;

            v2f vert (appdata v)
            {
                v2f o;

                float3 worldPos = TransformObjectToWorld(v.vertex.xyz);
                o.vertex = TransformWorldToHClip(worldPos);
                o.uv = v.uv;
                o.color = v.color;

                float3 normal = TransformObjectToWorldNormal(v.normal.xyz).xyz;
                o.normal = mul(UNITY_MATRIX_V, float4(normal, 0)).xyz;

                o.screenPos = o.vertex;
                #if UNITY_UV_STARTS_AT_TOP
                o.screenPos.y *= -1;
                #endif

                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                float mask = tex2D(_Mask, i.uv * _Mask_ST.xy + _Mask_ST.zw);

                float noise = tex2D(_Noise, i.uv * _Noise_ST.xy + _Noise_ST.zw * _Time.y).a;

                i.screenPos.xyz /= i.screenPos.w;
                float2 screenUV = i.screenPos.xy;
                screenUV = (screenUV + 1) / 2;
                
                float2 distortDir = normalize(screenUV - _DistortCenter.xy);

                screenUV.xy += distortDir * _CameraOpaqueTexture_TexelSize.xy * _DistortStrength * noise * mask * i.color.a;
                
                if(screenUV.x < 0 || screenUV.x > 1 || screenUV.y < 0 || screenUV.y > 1) {
                    discard;
                }

                float4 color = tex2D(_CameraOpaqueTexture, screenUV);
                return color;
            }
            ENDHLSL
        }
    }
}