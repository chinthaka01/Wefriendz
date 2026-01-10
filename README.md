# Wefriendz (Shell App)

Wefriendz is the **shell application** that composes multiple independent iOS micro‑features into a single tab‑based SwiftUI app. It wires shared platform services like networking, analytics, and the design system into feature‑specific dependency containers, and renders each feature as a tab.

## Features

The shell currently integrates three micro‑features:

- **FeedFeature**
  - Displays a feed of posts using the shared networking layer.
  - Uses `FeedFeatureAPIClient` and `FeedDependencies` to stay decoupled from the shell.
- **FriendsFeature**
  - Shows the user’s friends list and related actions.
  - Uses `FriendsFeatureAPIClient` and `FriendsDependencies`.
- **ProfileFeature**
  - Displays and edits the current user’s profile.
  - Uses `ProfileFeatureAPIClient` and `ProfileDependencies`.

Each micro‑feature is responsible for its own UI and view models, while the shell focuses on composition and navigation.

## Architecture

Wefriendz follows a **micro‑feature architecture**:

- The shell owns:
  - Shared platform services (analytics, networking).
  - Construction of feature APIs, dependencies, and factories.
  - Registration and layout of features inside a `TabView`.
- Each feature module:
  - Exposes a `FeatureFactory` that builds a `MicroFeature`.
  - Receives only what it needs (API, analytics) via a dedicated dependencies type.
  - Implements its own SwiftUI entry point and internal view hierarchy.

High‑level flow:

1. `WefriendzApp` creates shared instances of `AnalyticsImpl` and `NetworkingImpl`.
2. The app builds feature‑specific API clients over the shared networking instance.
3. Each API is wrapped in a `*DependenciesImpl` alongside the shared analytics.
4. Each `*FeatureFactory` is created with its dependencies and produces a `MicroFeature`.
5. All `MicroFeature`s are collected into a single array and passed into `ContentView`.
6. `ContentView` renders each micro‑feature as a tab and sends analytics events for app launch and tab selection.

## App Composition

### App entry point

`WefriendzApp` is the main entry point that wires everything together:

- Creates shared `analytics` and `networking` instances.
- Constructs:
  - `FeedFeatureAPIClient`, `FriendsFeatureAPIClient`, `ProfileFeatureAPIClient`.
  - `FeedDependenciesImpl`, `FriendsDependenciesImpl`, `ProfileDependenciesImpl`.
  - `FeedFeatureFactory`, `FriendsFeatureFactory`, `ProfileFeatureFactory`.
- Builds the `features` array by calling `makeFeature()` on each factory.
- Injects `features` and `analytics` into the root `ContentView`.


## Root UI (Tabs)

`ContentView` is the main SwiftUI root view that presents each `MicroFeature` as a tab in a `TabView`:

- Binds `selectedTab` to the `TabView` selection.
- For each `MicroFeature`:
  - Calls `makeRootView()` to get its SwiftUI entry view.
  - Uses `feature.tabIcon` and `feature.title` for the tab item.
  - Uses `feature.id` as the tab selection tag.
- Sends:
  - `.appLaunched` analytics when the view appears.
  - `.tabSelected(title:)` analytics on tab change.

## Dependencies

The Wefriendz shell depends on:

- **PlatformKit**
  - Core platform protocols and types:
    - `Analytics`, `FeatureAPI`, `MicroFeature`, `FeatureFactory`, etc.
- **DesignSystem**
  - Shared colors, typography, spacing, and reusable components used inside features.
- **Feature modules**
  - `FeedFeature`
  - `FriendsFeature`
  - `ProfileFeature`

These modules are integrated as Swift packages (or local frameworks) and imported at the app level.

## Development Notes

- The shell app owns **lifecycle and composition** only; feature modules own their **domain logic and UI**.
- Shared concerns (analytics, networking, design system) are created once in the shell and injected into each feature through small dependency containers.
- Adding a new feature typically involves:
  1. Adding the feature module dependency.
  2. Creating its API client and dependency implementation.
  3. Creating its `FeatureFactory`.
  4. Appending `factory.makeFeature()` to the `features` array in `WefriendzApp`.

This keeps the shell focused, while allowing each micro‑feature to evolve independently within a consistent platform.

***

## The Other Related Repositories

### Shared Contracts:
PlatformKit - https://github.com/chinthaka01/PlatformKit
DesignSystem - https://github.com/chinthaka01/DesignSystem

### Micro-Feature Modules:
Feed Feature - https://github.com/chinthaka01/FeedFeature
Friends Feature - https://github.com/chinthaka01/FriendsFeature
Profile Feature - https://github.com/chinthaka01/ProfileFeature

### Isolated Feature Apps:
Feed Feature App - https://github.com/chinthaka01/FeedFeatureApp
Friends Feature App - https://github.com/chinthaka01/FriendsFeatureApp
Profile Feature App - https://github.com/chinthaka01/ProfileFeatureApp
