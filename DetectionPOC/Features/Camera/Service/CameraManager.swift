//
//  CameraManager.swift
//  DetectionPOC
//
//  Created by Alexandre Porto Alegre on 12/07/25.
//
import Foundation
import AVFoundation

class CameraManager: NSObject {
    private let captureSession = AVCaptureSession()
    
    private var videoOutput = AVCaptureVideoDataOutput()
    
    private var permissionGranted: Bool {
        get async {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            return status == .authorized ? true : await AVCaptureDevice.requestAccess(for: .video)
        }
    }
    
    private var previewStreamUpdated: AsyncStream<CMSampleBuffer>.Continuation?
    
    lazy var previewStream: AsyncStream<CMSampleBuffer> = {
        AsyncStream { continuation in
            self.previewStreamUpdated = continuation
            Task {
                await configureCapture()
                await startCapture()
            }
        }
    }()
    
    private func configureCapture() async {
        guard let systemPreferredCamera = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: systemPreferredCamera),
              captureSession.canAddInput(input),
              captureSession.canAddOutput(videoOutput)
        else {
            return
        }
        
        captureSession.beginConfiguration()
        
        defer {
            self.captureSession.commitConfiguration()
        }
        
        captureSession.addInput(input)
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera.preview.session"))
        captureSession.addOutput(videoOutput)
        
        guard await permissionGranted else { return }
    }
    
    func stopCapture() {
        captureSession.stopRunning()
        previewStreamUpdated?.finish()
    }
    
    func startCapture() async {
        await configureCapture()
        captureSession.startRunning()
    }
}

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        previewStreamUpdated?.yield(sampleBuffer)
    }
}
