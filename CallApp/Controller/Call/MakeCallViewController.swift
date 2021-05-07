//
//  MakeCallViewController.swift
//  CallApp
//
//  Created by hau on 4/27/21.
//

import UIKit
import FirebaseAuth
import AgoraRtcKit

class MakeCallViewController: UIViewController {
    @IBOutlet weak var localView: UIView!
    @IBOutlet weak var remoteView: UIView!
    var delegate: UserDelegate?
    var agoraKit: AgoraRtcEngineKit!
    let localUID = UInt.random(in: 1111111111...9999999999)
    
    override func viewDidLoad() {
        print(localUID)
        super.viewDidLoad()
        initializeAgoraEngine()
        setupVideo()
        setupLocalVideo(uid: localUID)
        setChannelProfile()
        joinChannel()
    
//        guard let email = delegate?.user?.email else {return}
//        AppDelegate.shared.callManager.startCall(handle: email, videoEnabled: true)
        // Do any additional setup after loading the view.
    }
    func initializeAgoraEngine() {
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: KeyCenter.AppID, delegate: self)
    }
    
    func setupVideo() {
        agoraKit.enableVideo()
        agoraKit.setVideoEncoderConfiguration(AgoraVideoEncoderConfiguration(size: AgoraVideoDimension640x360, frameRate: .fps15, bitrate: AgoraVideoBitrateStandard, orientationMode: .adaptative))
    }
    func setChannelProfile() {
        agoraKit.setChannelProfile(.communication)
    }
    func joinChannel() {
        
        guard let channelID = delegate?.callee?.uid else { return }
        guard let token = KeyCenter.getToken(channelID: channelID) else { return }
        agoraKit.setDefaultAudioRouteToSpeakerphone(true)
        agoraKit.joinChannel(byToken: token, channelId: channelID, info: nil, uid: localUID) { (sid, uid, elapsed) -> Void in
            print("did join channel")
        }
        
        UIApplication.shared.isIdleTimerDisabled = true
    }
    func setupLocalVideo(uid: UInt) {
        
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.view = localView
        videoCanvas.renderMode = .hidden
        agoraKit.setupLocalVideo(videoCanvas)
      
    }
    @IBAction func endCall(_ sender: Any) {
        agoraKit.leaveChannel()
        UIApplication.shared.isIdleTimerDisabled = false
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func swichCamera(_ sender: Any) {
        
    }
    @IBAction func muteCall(_ sender: Any) {
        
    }
    
}
extension MakeCallViewController: AgoraRtcEngineDelegate {
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoFrameOfUid uid: UInt, size: CGSize, elapsed: Int) {
        
    }
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        print(uid)
    }
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid:UInt, size:CGSize, elapsed:Int) {
        
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.view = remoteView
        videoCanvas.renderMode = .hidden
        agoraKit.setupRemoteVideo(videoCanvas)
        
    }
    
    internal func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid:UInt, reason:AgoraUserOfflineReason) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didVideoMuted muted: Bool, byUid uid: UInt) {
        //
    }
    
}
