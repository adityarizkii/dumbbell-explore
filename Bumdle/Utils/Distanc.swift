//
//  Distanc.swift
//  Bumdle
//
//  Created by Muhammad Chandra Ramadhan on 24/06/25.
//
import CoreGraphics

func distanceBetween(_ pointA: CGPoint, _ pointB: CGPoint) -> Double {
    let dx = pointA.x - pointB.x
    let dy = pointA.y - pointB.y
    return Double(sqrt(dx * dx + dy * dy))
}

func isPoint(_ point: CGPoint, insideCircleWithCenter center: CGPoint, radius: CGFloat) -> Bool {
    let dx = point.x - center.x
    let dy = point.y - center.y
    let distanceSquared = dx * dx + dy * dy
    return distanceSquared <= radius * radius
}
