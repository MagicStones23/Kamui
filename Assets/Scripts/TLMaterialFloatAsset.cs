using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;

public class TLMaterialFloatAsset : PlayableAsset {
    public ExposedReference<TLMaterialFloatData> exposedAsset;

    public override Playable CreatePlayable(PlayableGraph graph, GameObject owner) {
        TLMaterialFloatBehaviour behaviour = new TLMaterialFloatBehaviour();
        behaviour.data = exposedAsset.Resolve(graph.GetResolver());
        return ScriptPlayable<TLMaterialFloatBehaviour>.Create(graph, behaviour);
    }
}