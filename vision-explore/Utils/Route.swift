//
//  Route.swift
//  vision-explore
//
//  Created by Muhammad Chandra Ramadhan on 17/06/25.
//

import SwiftUI

class Route : ObservableObject{
    @Published public var path : NavigationPath
    public var routes : [RouteModel]
    
    init () {
        self.path = NavigationPath()
        self.routes = []
    }
    
    public func addRoute(route : String, view : some View){
        self.routes.append(RouteModel(name: route, view: AnyView(view)))
    }
    
    public func getRoute(name : String) -> RouteModel? {
        return self.routes.first(where: { $0.name == name })
    }
    
//    public func getViewFromRoute(name : String) ->  AnyView {
//        return self.routes.first(where: { $0.name == name })?.view ?? AnyView(EmptyView())
//    }
}

