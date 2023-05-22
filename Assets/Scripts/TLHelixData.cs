using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[Serializable]
public class TLHelixData : MonoBehaviour {
    public HelixFromToHelper helixHelper;
    public float from;
    public float to;
    public float duration;
    public AnimationCurve curve;
}