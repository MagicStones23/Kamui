Shader "Tutorial/Model"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white" {}
        [HDR] _BaseColor ("BaseColor", Color) = (1, 1, 1, 1)
        
        //_Normal ("Normal", 2D) = "bump" {}
        
        _OverlayTex ("OverlayTex", 2D) = "white" {}
        [HDR] _OverlayColor ("OverlayColor", Color) = (1, 1, 1, 1)
        _OverlayStrength ("OverlayStrength", Range(0, 1)) = 1

        _AbsorbBorder ("AbsorbBorder", Float) = 4
        _AbsorbStretch ("AbsorbStretch", Range(0, 1)) = 0.5
        _HelixFromToLerp ("HelixFromToLerp", Range(0, 1)) = 0
        _PivotDistanceThreshold ("PivotDistanceThreshold", Range(-20, 20)) = 0
    }
    SubShader
    {
        Pass
        {
            Tags { "Queue"="Opaque" "RenderPipeline"="UniversalPipeline" "LightMode"="UniversalForward" }

            Cull Off

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Assets/Library/Library_Helix.hlsl"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 localPos : TEXCOORD1;
                float3 worldPos : TEXCOORD2;
                float3 normal : TEXCOORD3;
                float3 tangent : TEXCOORD4;
                float3 binormal : TEXCOORD5;
            };

            sampler2D _MainTex;
            float4 _BaseColor;

            float _AbsorbBorder;
            float _AbsorbStretch;
            float _HelixFromToLerp;
            float _PivotDistanceThreshold;

            sampler2D _Normal;
            float4 _Normal_ST;

            sampler2D _OverlayTex;
            float4 _OverlayTex_ST;
            float4 _OverlayColor;
            float _OverlayStrength;

            float _HelixRadiusMin;
            float _HelixRadiusMax;
            float _HelixAngleOffset;
            float _HelixAngleMax;
            float3 _HelixFromPos;
            float3 _HelixToPos;

            v2f vert (appdata v)
            {
                v2f o;

                float3 worldPos = TransformObjectToWorld(v.vertex.xyz);

                //float toFromDistance = distance(_HelixFromPos, worldPos);
                //if(toFromDistance < _PivotDistanceThreshold) {
                //    float3 helixPos = GetHelixFromToPos(_HelixFromToLerp, _HelixRadiusMin, _HelixRadiusMax, _HelixAngleOffset, _HelixAngleMax, _HelixFromPos, _HelixToPos);
                //    worldPos = helixPos;
                //}

                //o.vertex = TransformWorldToHClip(worldPos);
                //o.uv = v.uv;
                //o.normal = TransformObjectToWorldNormal(v.normal.xyz);

                //float3 worldPos = TransformObjectToWorld(v.vertex.xyz);




                //float toFromDistance = distance(_HelixFromPos, worldPos);
                //if(toFromDistance < _PivotDistanceThreshold + _AbsorbBorder) {
                //    float t = (_PivotDistanceThreshold + _AbsorbBorder - toFromDistance) / _AbsorbBorder;
                //    t = saturate(t);
                //    t = pow(t, 8);
    
                //    float3 helixPos = GetHelixFromToPos(_HelixFromToLerp, _HelixRadiusMin, _HelixRadiusMax, _HelixAngleOffset, _HelixAngleMax, _HelixFromPos, _HelixToPos);
                    
                //    worldPos = lerp(worldPos, helixPos, t);
                //}




                float toFromDistance = distance(_HelixFromPos, worldPos);
                if(toFromDistance < _PivotDistanceThreshold + _AbsorbBorder) {
                    float t = (_PivotDistanceThreshold + _AbsorbBorder - toFromDistance) / _AbsorbBorder;
                    t = saturate(t);
                    t = pow(t, 8);
    
                    float fromToLerp = lerp(_HelixFromToLerp - _AbsorbStretch, _HelixFromToLerp, t);
                    fromToLerp = saturate(fromToLerp);

                    float3 helixPos = GetHelixFromToPos(fromToLerp, _HelixRadiusMin, _HelixRadiusMax, _HelixAngleOffset, _HelixAngleMax, _HelixFromPos, _HelixToPos);
                    
                    worldPos = lerp(worldPos, helixPos, t);
                }




                o.vertex = TransformWorldToHClip(worldPos);
                o.uv = v.uv;
                o.normal = TransformObjectToWorldNormal(v.normal.xyz);

                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                Light mainLight = GetMainLight();
                float3 lightDir = mainLight.direction;
                float3 normal = normalize(i.normal);
                float ndl = dot(normal, lightDir) * 0.5 + 0.5;

                float4 overlayColor = tex2D(_OverlayTex, i.uv * _OverlayTex_ST.xy + _OverlayTex_ST.zw * _Time.y);
                overlayColor = _OverlayColor * overlayColor.a * _OverlayStrength;

                float4 color = tex2D(_MainTex, i.uv);
                color *= ndl * _BaseColor;
                color.rgb += overlayColor;
                return color;
            }
            ENDHLSL
        }
    }
}