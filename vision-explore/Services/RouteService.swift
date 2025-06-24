//
//  Route.swift
//  vision-explore
//
//  Created by Muhammad Chandra Ramadhan on 17/06/25.
//

import SwiftUI

class RouteService {
    private(set) var routes: [RouteModel] = []

    func addRoute(name: String, view: some View) {
        routes.append(RouteModel(name: name, view: AnyView(view)))
    }

    func getRoute(name: String) -> RouteModel? {
        routes.first { $0.name == name }
    }
}


