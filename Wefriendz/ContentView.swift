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
    @State private var selectedTab: String?

    let features: [MicroFeature]
    private let analytics: Analytics
    
    init(features: [MicroFeature], analytics: Analytics) {
        self.features = features
        self.analytics = analytics
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(Array(features.enumerated()), id: \.element.id) { _, feature in
                feature
                    .makeRootView()
                    .tabItem {
                        Image(uiImage: feature.tabIcon)
                        Text(feature.title)
                    }
                    .tag(feature.id)
            }
        }
        .onChange(of: selectedTab) { _, newValue in
            if let id = newValue,
               let feature = features.first(where: { $0.id == id }) {
                analytics.track(.tabSelected(title: feature.title))
            }
        }
        .onAppear {
            analytics.track(.appLaunched)
        }
    }
}

#Preview {
    //  Not implementing in this Demo.
}
