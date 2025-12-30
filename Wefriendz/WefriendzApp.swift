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
    let networking = NetworkingImpl()
    
    let feedAPI: FeatureAPI
    let friendsAPI: FeatureAPI
    let profileAPI: FeatureAPI

    let feedDependencies: FeedDependenciesImpl
    let friendsDependencies: FriendsDependenciesImpl
    let profileDependencies: ProfileDependenciesImpl
    
    let feedFactory: FeedFeatureFactory
    let friendsFactory: FriendsFeatureFactory
    let profileFactory: ProfileFeatureFactory
    
    let features: [MicroFeature]
    
    init() {
        feedAPI = FeedFeatureAPIClient(networking: networking)
        friendsAPI = FriendsFeatureAPIClient(networking: networking)
        profileAPI = ProfileFeatureAPIClient(networking: networking)

        feedDependencies = FeedDependenciesImpl(feedAPI: feedAPI as! FeedFeatureAPI, analytics: analytics)
        friendsDependencies = FriendsDependenciesImpl(friendsAPI: friendsAPI as! FriendsFeatureAPI, analytics: analytics)
        profileDependencies = ProfileDependenciesImpl(profileAPI: profileAPI as! ProfileFeatureAPI, analytics: analytics)
        
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
