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

@main
struct WefriendzApp: App {
    let analytics = AnalyticsImpl()
    
    let feedAPI = FeedFeatureAPIClient()
    let friendsAPI = FriendsFeatureAPIClient()
    let profileAPI = ProfileFeatureAPIClient()

    let feedDependencies: FeedDependenciesImpl
    let friendsDependencies: FriendsDependenciesImpl
    let profileDependencies: ProfileDependenciesImpl
    
    let feedFactory: FeedFeatureFactory
    let friendsFactory: FriendsFeatureFactory
    let profileFactory: ProfileFeatureFactory
    
    let features: [MicroFeature]
    
    init() {
        feedDependencies = FeedDependenciesImpl(feedAPI: feedAPI, analytics: analytics)
        friendsDependencies = FriendsDependenciesImpl(friendsAPI: friendsAPI, analytics: analytics)
        profileDependencies = ProfileDependenciesImpl(profileAPI: profileAPI, analytics: analytics)
        
        feedFactory = FeedFeatureFactory(dependencies: feedDependencies)
        friendsFactory = FriendsFeatureFactory(dependencies: friendsDependencies)
        profileFactory = ProfileFeatureFactory(dependencies: profileDependencies)
        
        features = [
            feedFactory.makeFeature(),
            friendsFactory.makeFeature(),
            profileFactory.makeFeature()
        ]
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(features: features)
        }
    }
}
