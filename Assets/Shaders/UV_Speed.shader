Shader "Tutotial/UV_Speed"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white" {}
        [HDR] _MainColor ("MainColor", Color) = (1, 1, 1, 1)
        _MainSpeed ("MainSpeed", Vector) = (0, 0, 0, 0)
        _MaskTex ("MaskTex", 2D) = "white" {}
        _MaskSpeed ("MaskSpeed", Vector) = (0, 0, 0, 0)
        _FixedMaskTex ("FixedMaskTex", 2D) = "white" {}
        _AlphaPower ("Power", Float) = 1
        
        [Enum(Add, 1, Alpha, 10)] _DstBlend ("DstBlend", Float) = 1
        [Enum(Off, 0, Front, 1, Back, 2)] _Cull ("Cull", Float) = 0
        [Enum(Never, 1, LessE, 4, Always, 8)] _ZTest ("ZTest", Float) = 4
        [MaterialToggle] _ZWrite ("ZWrite", Float) = 0
    }
    SubShader
    {
        Tags { "RenderPipeline"="UniversalPipeline" "Queue"="Transparent" }

        Blend SrcAlpha [_DstBlend]
        Cull [_Cull]
        ZTest [_ZTest]
        ZWrite [_ZWrite]
        
        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/core.hlsl"

            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float4 color : TEXCOORD0;
                float2 mainUV : TEXCOORD1;
                float2 maskUV : TEXCOORD2;
                float2 fixedMaskUV : TEXCOORD3;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _MainColor;
            float4 _MainSpeed;
            sampler2D _MaskTex;
            float4 _MaskTex_ST;
            float4 _MaskSpeed;
            sampler2D _FixedMaskTex;
            float4 _FixedMaskTex_ST;
            float _AlphaPower;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = TransformObjectToHClip(v.vertex.xyz);
                o.color = v.color;
                o.mainUV = TRANSFORM_TEX(v.uv, _MainTex);
                o.maskUV = TRANSFORM_TEX(v.uv, _MaskTex);
                o.fixedMaskUV = TRANSFORM_TEX(v.uv, _FixedMaskTex);
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                float4 finalColor = i.color;

                float2 mainUV = i.mainUV + _MainSpeed.xy * _Time.y;
                float4 mainColor = tex2D(_MainTex, mainUV);
                mainColor *= _MainColor;
                finalColor *= mainColor;

                float2 maskUV = i.maskUV + _MaskSpeed.xy * _Time.y;
                float4 maskColor = tex2D(_MaskTex, maskUV);
                finalColor.a *= maskColor.a;

                float4 fixedMaskColor = tex2D(_FixedMaskTex, i.fixedMaskUV);
                finalColor.a *= fixedMaskColor.r;
                
                

                finalColor.a = pow(abs(finalColor.a), _AlphaPower);
                return finalColor;
            }
            ENDHLSL
        }
    }
}