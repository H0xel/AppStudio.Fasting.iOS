//
//  BarcodeVIew.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 28.12.2023.
//

import SwiftUI
import AVFoundation

struct BarcodeView: UIViewControllerRepresentable {
    var didFindBarCode: (String) -> Void
    private let session = AVCaptureSession()

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return viewController }

        let videoInput: AVCaptureDeviceInput
        let metadataOutput = AVCaptureMetadataOutput()

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return viewController
        }

        guard session.canAddInput(videoInput), session.canAddOutput(metadataOutput) else { return viewController }

        session.addInput(videoInput)
        session.addOutput(metadataOutput)

        metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417, .upce]

        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = viewController.view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        viewController.view.layer.addSublayer(previewLayer)

        Task.detached(priority: .high) {
            session.startRunning()
        }

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: BarcodeView

        init(parent: BarcodeView) {
            self.parent = parent
        }

        func metadataOutput(
            _ output: AVCaptureMetadataOutput,
            didOutput metadataObjects: [AVMetadataObject],
            from connection: AVCaptureConnection
        ) {
            guard let barcode = (metadataObjects.first as? AVMetadataMachineReadableCodeObject)?.stringValue else {
                return
            }

            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            parent.didFindBarCode(barcode)
            parent.session.stopRunning()
        }
    }
}
