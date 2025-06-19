//
//  RouteManager.swift
//  vision-explore
//
//  Created by Muhammad Chandra Ramadhan on 17/06/25.
//

import SwiftUI

class RouteManager : Route {
    override init() {
        super.init()
        
        self.addRoute(route: "home", view: HomeView())
        self.addRoute(route: "preview", view: Preview())
        self.addRoute(route: "exercise", view: WorkOut())
        self.path.append("preview")
    }
    
    public func getViewFromRoute(path:String) -> AnyView {
        return self.routes.first(where: { $0.name == path })?.view ?? AnyView(EmptyView())
    }
    
    public func push(path:String){
        self.path.append(path)
    }
}
