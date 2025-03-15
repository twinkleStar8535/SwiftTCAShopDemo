//
//  SwiftTCAShopDemoApp.swift
//  SwiftTCAShopDemo
//
//  Created by YcLin on 2025/2/21.
//

import SwiftUI
import ComposableArchitecture

@main
struct SwiftTCAShopDemoApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView(store: .init(
                initialState: HomeDomain.State(),
                reducer: { HomeDomain()}
            ),historyStore: .init(
                initialState: CartHistoryDomain.State(id: UUID()),
                reducer: { CartHistoryDomain()}
            )
           )
        }
    }
}
