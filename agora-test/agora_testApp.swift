//
//  agora_testApp.swift
//  agora-test
//
//  Created by Xuke Fang on 6/28/22.
//

import SwiftUI

@main
struct agora_testApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(AgoraViewModel.agora)
        }
    }
}
