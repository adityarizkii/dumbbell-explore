//
//  Distanc.swift
//  vision-explore
//
//  Created by Muhammad Chandra Ramadhan on 24/06/25.
//
import CoreGraphics

func distanceBetween(_ pointA: CGPoint, _ pointB: CGPoint) -> Double {
    let dx = pointA.x - pointB.x
    let dy = pointA.y - pointB.y
    return Double(sqrt(dx * dx + dy * dy))
}
