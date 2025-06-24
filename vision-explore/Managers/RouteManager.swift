//
//  RouteManager.swift
//  vision-explore
//
//  Created by Muhammad Chandra Ramadhan on 17/06/25.
//

import SwiftUI

class RouteManager: ObservableObject {
    @Published var path: NavigationPath = NavigationPath()
    private let routeService: RouteService

    init(routeService: RouteService = RouteService()) {
        self.routeService = routeService
        setupRoutes()
    }

    private func setupRoutes() {
        routeService.addRoute(name: "home", view: HomeView())
        routeService.addRoute(name: "tutorial", view: TutorialView())
        routeService.addRoute(name: "firstguidance", view: IntroGuideView())
        routeService.addRoute(name: "guidance", view: InstructionView())
        routeService.addRoute(name: "workout", view: WorkoutView())
    }

    func getView(for routeName: String) -> AnyView {
        routeService.getRoute(name: routeName)?.view ?? AnyView(EmptyView())
    }

    func push(_ route: String) {
        path.append(route)
    }

    func pop() {
        if path.count > 1 {
            path.removeLast()
        }
    }
}
