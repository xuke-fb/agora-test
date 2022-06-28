//
//  ContentView.swift
//  agora-test
//
//  Created by Xuke Fang on 6/28/22.
//

import SwiftUI
import AgoraRtcKit

struct ContentView: View {
    @EnvironmentObject var vm: AgoraViewModel
    var body: some View {
        VStack {
            /// N.B. Here I am using int  as our uid, but in our real app. we use real uids
            ForEach(0..<3){ id in
                VideoSurface(uid: UInt(id))
            }
        }.onAppear(){
            AgoraViewModel.join(channel: "some channel", with: "some token", as: AgoraClientRole.broadcaster)
        }.onDisappear(){
            AgoraViewModel.cleanUp()
        }
    }
}

struct VideoSurface: View {
    @EnvironmentObject var vm: AgoraViewModel
    let uid: UInt
    var body: some View {
        Rectangle().foregroundColor(.blue).shadow(radius: 10).onAppear(){
            vm.addVideoSurface(self, uid: uid)
        }
    }
}
