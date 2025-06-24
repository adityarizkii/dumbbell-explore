////
////  CameraPreviewView.swift
////  vision-explore
////
////  Created by Aditya Rizki on 28/05/25.
////
//import AVFoundation
//
//protocol CameraManagerDelegate: AnyObject {
//    func cameraManager(_ manager: CameraManager, didOutput pixelBuffer: CVPixelBuffer)
//}
//
//class CameraManager: NSObject {
//    private let captureSession = AVCaptureSession()
//    weak var delegate: CameraManagerDelegate?
//
//    func configureCamera() {
//        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
//              let input = try? AVCaptureDeviceInput(device: device) else {
//            print("❌ Failed to access camera")
//            return
//        }
//
//        captureSession.beginConfiguration()
//
//        if captureSession.canAddInput(input) {
//            captureSession.addInput(input)
//        }
//
//        let output = AVCaptureVideoDataOutput()
//        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera.queue"))
//
//        if captureSession.canAddOutput(output) {
//            captureSession.addOutput(output)
//        }
//
//        captureSession.commitConfiguration()
//    }
//
//    func startSession() {
//        if !captureSession.isRunning {
//            captureSession.commitConfiguration()
//            captureSession.startRunning()
//        }
//    }
//
//    func stopSession() {
//        if captureSession.isRunning {
//            captureSession.stopRunning()
//        }
//    }
//
//    func getPreviewLayer() -> AVCaptureVideoPreviewLayer {
//        let layer = AVCaptureVideoPreviewLayer(session: captureSession)
//        layer.videoGravity = .resizeAspectFill
//        return layer
//    }
//}
//
//extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
//    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
//        delegate?.cameraManager(self, didOutput: pixelBuffer)
//    }
//}
//
