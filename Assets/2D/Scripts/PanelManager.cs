using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PanelManager : MonoBehaviour
{
    public Button _ReplayBtn;
    public Button _VideoBtn;
    public Material _GreyMat;

    bool mIsVideo = true;
    bool mIsReplay = false;

    void Start()
    {
        ChangeBtnState();
    }

    void ChangeBtnState()
    {
        if (mIsReplay)
        {
            _ReplayBtn.interactable = true;
            _ReplayBtn.image.material = null;
        }
        else
        {
            _ReplayBtn.interactable = false;
            _ReplayBtn.image.material = _GreyMat;
        }

        if (mIsVideo)
        {
            _VideoBtn.interactable = true;
            _VideoBtn.image.material = null;
        }
        else
        {
            _VideoBtn.interactable = false;
            _VideoBtn.image.material = _GreyMat;
        }

    }

    public void OnReplayClick()
    {
        mIsReplay = false;
        mIsVideo = true;
        ChangeBtnState();
    }

    public void OnVideoPlay()
    {
        mIsReplay = true;
        mIsVideo = false;
        ChangeBtnState();
    }

    
}
