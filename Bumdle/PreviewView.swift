//
//  PreviewView.swift
//  Bumdle
//
//  Created by Aditya Rizki on 28/05/25.
//

import UIKit
import AVFoundation

class PreviewView: UIView {
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }

    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
}


//class PreviewView: UIView {
//    var videoPreviewLayer: AVCaptureVideoPreviewLayer? {
//        get { layer as? AVCaptureVideoPreviewLayer }
//        set { if let newLayer = newValue { layer.addSublayer(newLayer) } }
//    }
//
//    override class var layerClass: AnyClass {
//        AVCaptureVideoPreviewLayer.self
//    }
//}
