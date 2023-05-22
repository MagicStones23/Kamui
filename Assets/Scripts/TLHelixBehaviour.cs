using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;

public class TLHelixBehaviour : PlayableBehaviour {
    public TLHelixData data;

    public override void OnBehaviourPause(Playable playable, FrameData info) {
        base.OnBehaviourPause(playable, info);

        data.helixHelper.absorbLerp = 0;
    }

    public override void ProcessFrame(Playable playable, FrameData info, object playerData) {
        base.ProcessFrame(playable, info, playerData);

        float time = (float)playable.GetTime();
        float t = Mathf.Clamp01(time / data.duration);
        t = data.curve.Evaluate(t);
        data.helixHelper.absorbLerp = Mathf.Lerp(data.from, data.to, t);
    }
}