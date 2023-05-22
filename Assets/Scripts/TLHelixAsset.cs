using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;

public class TLHelixAsset : PlayableAsset {
    public ExposedReference<TLHelixData> exposedAsset;

    public override Playable CreatePlayable(PlayableGraph graph, GameObject owner) {
        TLHelixBehaviour behaviour = new TLHelixBehaviour();
        behaviour.data = exposedAsset.Resolve(graph.GetResolver());
        return ScriptPlayable<TLHelixBehaviour>.Create(graph, behaviour);
    }
}