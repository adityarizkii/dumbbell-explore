//
//  Shape.swift
//  vision-explore
//
//  Created by Muhammad Chandra Ramadhan on 04/06/25.
//

import SwiftUI


struct ArcShape: Shape {
     var startDegrees : CGFloat = 0
     var endDegrees : CGFloat = 180
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        // Arc dari 0 ke 180 derajat (π radian)
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                    radius: rect.width / 2,
                    startAngle: .degrees(startDegrees),
                    endAngle: .degrees(endDegrees),
                    clockwise: true)
        return path
    }
}


struct CurvedLine: Shape {
    var curvature: CGFloat = 0.5  // -1.0 to 1.0 (negatif = lengkung ke bawah)

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let start = CGPoint(x: rect.minX, y: rect.midY)
        let end = CGPoint(x: rect.maxX, y: rect.midY)
        
        // Geser titik kontrol naik/turun tergantung nilai curvature
        let control = CGPoint(x: rect.midX, y: rect.midY - (rect.height * curvature))
        
        path.move(to: start)
        path.addQuadCurve(to: end, control: control)
        
        return path
    }
}

