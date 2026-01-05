//
//  WefriendzApp.swift
//  Wefriendz
//
//  Created by Chinthaka Perera on 12/22/25.
//

import SwiftUI
import PlatformKit
import DesignSystem
import FeedFeature
import FriendsFeature
import ProfileFeature

/// Main application entry point for Wefriendz.
///
/// Composes shared platform services, feature APIs, dependencies,
/// and factories, then exposes them to the SwiftUI shell UI.
@main
struct WefriendzApp: App {
    
    /// Shared analytics implementation used across all features.
    let analytics = AnalyticsImpl()
    
    /// Shared networking implementation used by all feature APIs.
    let networking = NetworkingImpl()
    
    /// Feature APIs used to communicate with the BFF.
    let feedAPI: FeatureAPI
    let friendsAPI: FeatureAPI
    let profileAPI: FeatureAPI

    /// Concrete dependency containers for each feature.
    let feedDependencies: FeedDependenciesImpl
    let friendsDependencies: FriendsDependenciesImpl
    let profileDependencies: ProfileDependenciesImpl
    
    /// Feature factories responsible for creating `MicroFeature` instances.
    let feedFactory: FeedFeatureFactory
    let friendsFactory: FriendsFeatureFactory
    let profileFactory: ProfileFeatureFactory
    
    /// All micro features that will be rendered as tabs in the shell.
    let features: [MicroFeature]
    
    /// Initializes the app and composes all features and dependencies.
    init() {
        // Build API clients over the shared networking layer.
        feedAPI = FeedFeatureAPIClient(networking: networking)
        friendsAPI = FriendsFeatureAPIClient(networking: networking)
        profileAPI = ProfileFeatureAPIClient(networking: networking)

        // Wrap APIs and analytics into feature‑specific dependency containers.
        feedDependencies = FeedDependenciesImpl(feedAPI: feedAPI as! FeedFeatureAPI, analytics: analytics)
        friendsDependencies = FriendsDependenciesImpl(friendsAPI: friendsAPI as! FriendsFeatureAPI, analytics: analytics)
        profileDependencies = ProfileDependenciesImpl(profileAPI: profileAPI as! ProfileFeatureAPI, analytics: analytics)
        
        // Create factories that know how to build each micro feature.
        feedFactory = FeedFeatureFactory(dependencies: feedDependencies)
        friendsFactory = FriendsFeatureFactory(dependencies: friendsDependencies)
        profileFactory = ProfileFeatureFactory(dependencies: profileDependencies)
        
        // Register all micro features that should appear in the shell UI.
        features = [
            feedFactory.makeFeature(),
            friendsFactory.makeFeature(),
            profileFactory.makeFeature()
        ]
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(features: features, analytics: analytics)
        }
    }
}
