//
//  Agora.swift
//  agora-test
//
//  Created by Xuke Fang on 6/28/22.
//

import Foundation
import AgoraRtcKit
import SwiftUI


class AgoraViewModel: NSObject, ObservableObject {
    // singleton
    static let agora = AgoraViewModel()
    private override init(){}
    
    private var videoSurfaces: [UInt: VideoSurface] = [:]
    
    lazy var rtckit: AgoraRtcEngineKit = {
        let engine = AgoraRtcEngineKit.sharedEngine(
            withAppId:  "YOUR APP ID", delegate: self
        )
        engine.setChannelProfile(.liveBroadcasting)
        return engine
    }()
    
    public static func join(channel: String, with token: String?, as role: AgoraClientRole,  uid: UInt? = nil) {
        let option = AgoraRtcChannelMediaOptions()
        agora.rtckit.enableVideo()
        agora.rtckit.joinChannel(byToken: token, channelId: channel,  uid: uid ?? 0, mediaOptions: option){
            (channel, uid, elapsed) in
            print("successfully joined the channel \(channel)")
        }
    }
    public static func cleanUp() {
        agora.rtckit.leaveChannel()
        agora.videoSurfaces = [:]
    }
    
    func addVideoSurface(_ videoSurface: VideoSurface, uid: UInt) {
        videoSurfaces[uid] = videoSurface
    }
    
    deinit {
        AgoraRtcEngineKit.destroy()
    }
}

extension AgoraViewModel: AgoraRtcEngineDelegate {
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid:UInt, size:CGSize, elapsed:Int) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let videoSurface = self.videoSurfaces[uid] else {
                return;
            }
            
            let videoCanvas = AgoraRtcVideoCanvas()
            videoCanvas.uid = uid
            videoCanvas.renderMode = .fit
            let controller = UIHostingController(rootView: videoSurface)
            videoCanvas.view = controller.view
            self.rtckit.setupRemoteVideo(videoCanvas)
        }
    }
}
