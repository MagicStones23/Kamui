using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;

public class TLMaterialFloatBehaviour : PlayableBehaviour {
    public TLMaterialFloatData data;

    public override void OnBehaviourPause(Playable playable, FrameData info) {
        base.OnBehaviourPause(playable, info);

        if (data.setToWhenPaused) {
            data.target.sharedMaterial.SetFloat(data.field, data.to);
        }
        else {
            data.target.sharedMaterial.SetFloat(data.field, data.from);
        }
    }

    public override void ProcessFrame(Playable playable, FrameData info, object playerData) {
        base.ProcessFrame(playable, info, playerData);

        float time = (float)playable.GetTime();
        float t = Mathf.Clamp01(time / data.duration);
        t = data.curve.Evaluate(t);
        data.target.sharedMaterial.SetFloat(data.field, Mathf.Lerp(data.from, data.to, t));
    }
}