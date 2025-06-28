//
//  CameraPreviewView.swift
//  Bumdle
//
//  Created by Muhammad Chandra Ramadhan on 23/06/25.
//

//
//struct CameraPreviewView: UIViewRepresentable {
//    @ObservedObject var viewModel: PoseDetectionViewModel
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(viewModel: viewModel)
//    }
//
//    func makeUIView(context: Context) -> PreviewView {
//        let preview = PreviewView()
//        context.coordinator.setup(preview: preview)
//        return preview
//    }
//
//    func updateUIView(_ uiView: PreviewView, context: Context) {}
//
//    class Coordinator: NSObject, CameraManagerDelegate {
//        let viewModel: PoseDetectionViewModel
//        let manager = CameraManager()
//
//        init(viewModel: PoseDetectionViewModel) {
//            self.viewModel = viewModel
//        }
//
//        func setup(preview: PreviewView) {
//            manager.delegate = self
//            manager.configureCamera()
//            preview.videoPreviewLayer = manager.getPreviewLayer()
//            manager.startSession()
//        }
//
//        func cameraManager(_ manager: CameraManager, didOutput pixelBuffer: CVPixelBuffer) {
//            viewModel.processFrame(pixelBuffer: pixelBuffer)
//        }
//    }
//}
