//
//  InventaireApp.swift
//  Inventaire
//
//  Created by Ezequiel Gomes on 15/05/2024.
//

import SwiftUI

@main
struct InventaireApp: App {
    @StateObject private var check = CheckScannerDispo()
    var body: some Scene {

        WindowGroup {
            ContentView().environmentObject(check).task {
                await check.requestDataScannerAccessStatus()
            }.modelContainer(for: Maison.self)
        }
    }
}
