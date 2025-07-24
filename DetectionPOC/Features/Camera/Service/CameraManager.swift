//
//  CameraManager.swift
//  DetectionPOC
//
//  Created by Alexandre Porto Alegre on 12/07/25.
//
import Foundation
import AVFoundation
import MLKit

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
    
    weak var delegate: PoseDetectorDelegate?
    
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
        videoOutput.alwaysDiscardsLateVideoFrames = true
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
        
        guard let inputImage = MLImage(sampleBuffer: sampleBuffer) else {
            return
        }
        
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
//        let imageHeight = CGFloat(CVPixelBufferGetHeight(imageBuffer))
//        let imageWidth = CGFloat(CVPixelBufferGetWidth(imageBuffer))
        
        detectPose(in: inputImage)
    }
    
    private func detectPose(in image: MLImage) {
        let detectorOptions = PoseDetectorOptions()
        detectorOptions.detectorMode = .stream
        
        let poseDetector = PoseDetector.poseDetector(options: detectorOptions)
        
        var poses: [Pose] = []
        
        do {
            poses = try poseDetector.results(in: image)
        } catch let error {
            print(error.localizedDescription)
        }
        
        print("👁️ Arrived here tf")
        delegate?.forwardPoses(for: poses)
    }
}
