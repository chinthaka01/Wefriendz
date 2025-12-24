//
//  ContentView.swift
//  Wefriendz
//
//  Created by Chinthaka Perera on 12/22/25.
//

import SwiftUI
import PlatformKit
import DesignSystem

struct ContentView: View {
    let features: [MicroFeature]

    var body: some View {
        TabView {
            ForEach(Array(features.enumerated()), id: \.element.id) { _, feature in
                feature
                    .makeRootView()
                    .tabItem {
                        Image(uiImage: feature.tabIcon)
                        Text(feature.title)
                    }
            }
        }
    }
}

#Preview {
    ContentView(features: [])
}
