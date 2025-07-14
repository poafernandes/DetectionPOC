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
    
    private var deviceInput: AVCaptureDeviceInput?
    private var videoOutput: AVCaptureVideoDataOutput?
    
    private let systemPreferredCamera = AVCaptureDevice.default(for: .video)
    
    private var sessionQueue = DispatchQueue(label: "view.preview.session")
    
    private var permissionGranted: Bool {
        get async {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            
            if status == .authorized {
                return true
            } else {
                return await AVCaptureDevice.requestAccess(for: .video)
            }
        }
    }
    
    private var addToPreviewStream: ((CGImage) -> Void)?
    
    lazy var previewStream: AsyncStream<CGImage> = {
        AsyncStream { continuation in
            addToPreviewStream = { cgImage in
                continuation.yield(cgImage)
            }
        }
    }()
    
    override init() {
        super.init()
        
        Task {
            await configureSession()
            await startSession()
        }
    }
    
    private func configureSession() async {
        guard await permissionGranted, let systemPreferredCamera, let deviceInput = try? AVCaptureDeviceInput(device: systemPreferredCamera)
        else {
            return
        }
        
        captureSession.beginConfiguration()
        
        defer {
            self.captureSession.commitConfiguration()
        }
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: sessionQueue)
        
        guard captureSession.canAddInput(deviceInput) else {
            return
        }
        
        guard captureSession.canAddOutput(videoOutput) else {
            return
        }
        
        captureSession.addInput(deviceInput)
        captureSession.addOutput(videoOutput)
    }
    
    private func startSession() async {
        guard await permissionGranted else { return }
        captureSession.startRunning()
    }
    
}

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let currentFrame = sampleBuffer.cgImage else { return }
        addToPreviewStream?(currentFrame)
    }
}
