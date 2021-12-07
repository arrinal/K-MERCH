//
//  K_MERCHApp.swift
//  K-MERCH
//
//  Created by Arrinal Sholifadliq on 20/10/21.
//

import SwiftUI

@main
struct K_MERCHApp: App {
//    let persistenceController = PersistenceController.shared
//    @Environment(\.scenePhase) var scenePhase
    
    
    var body: some Scene {
        WindowGroup {
            MainView().environmentObject(ViewModel())
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//            TextView()
        }
//        .onChange(of: scenePhase) { (newScenePhase) in
//            switch newScenePhase {
//                
//            case .background:
//                print("Scene is in background")
//                persistenceController.save()
//            case .inactive:
//                print("Scene is inactive")
//            case .active:
//                print("Scene is active")
//            @unknown default:
//                print("Apple error")
//            }
//        }
    }
}
