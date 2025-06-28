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
        routeService.addRoute(name: "home", view: WorkoutView())
        routeService.addRoute(name: "tutorial", view: TutorialView())
        routeService.addRoute(name: "trial", view: TrialView())
        routeService.addRoute(name: "firstguidance", view: IntroGuideView())
        routeService.addRoute(name: "guidance", view: InstructionView())
        routeService.addRoute(name: "workout", view: WorkoutView())
        routeService.addRoute(name: "leftworkout", view: LeftWorkoutView())
        routeService.addRoute(name: "finished", view: FinishView())
    }

    func getView(for routeName: String) -> AnyView {
        routeService.getRoute(name: routeName)?.view ?? AnyView(EmptyView())
    }

    func push(_ route: String) {
        path.append(route)
    }
    
    func clear(){
        path.removeLast(path.count)
    }

    func pop() {
        if path.count > 1 {
            path.removeLast()
        }
    }
}
