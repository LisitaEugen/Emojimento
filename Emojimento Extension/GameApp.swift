//
//  GameApp.swift
//  Emojimento Extension
//
//  Created by Lisita Evgheni on 18.05.21.
//  Copyright © 2021 Szymon Lorenz. All rights reserved.
//

import SwiftUI

@main
struct GameApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                GameView().environmentObject(GameViewModel())
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
