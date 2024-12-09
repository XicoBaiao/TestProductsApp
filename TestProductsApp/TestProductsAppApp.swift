//
//  TestProductsAppApp.swift
//  TestProductsApp
//
//  Created by Francisco Baião on 08/12/2024.
//

import SwiftUI
import RealmSwift

@main
struct TestProductsAppApp: SwiftUI.App {
    init() {
        configureRealm()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }

    private func configureRealm() {
        let config = Realm.Configuration(
            schemaVersion: 2,
            objectTypes: [RealmProduct.self]
        )
        Realm.Configuration.defaultConfiguration = config
    }
}
