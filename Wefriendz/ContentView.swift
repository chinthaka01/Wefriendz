//
//  ContentView.swift
//  Wefriendz
//
//  Created by Chinthaka Perera on 12/22/25.
//

import SwiftUI
import PlatformKit
import DesignSystem

/// Root tab container for the shell app.
///
/// Renders all registered `MicroFeature`s as tabs and forwards
/// high‑level analytics events such as app launch and tab selection.
struct ContentView: View {
    
    /// Currently selected tab identifier, bound to the `TabView` selection.
    @State private var selectedTab: String?

    /// All micro features that should appear as tabs.
    let features: [MicroFeature]
    
    /// Shared analytics implementation injected from the shell.
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
        // Track tab selection changes and emit analytics events.
        .onChange(of: selectedTab) { _, newValue in
            if let id = newValue,
               let feature = features.first(where: { $0.id == id }) {
                analytics.track(.tabSelected(title: feature.title))
            }
        }
        // Fire a single analytics event when the app's root content appears.
        .onAppear {
            analytics.track(.appLaunched)
        }
    }
}

#Preview {
    //  Not implementing in this Demo.
}
