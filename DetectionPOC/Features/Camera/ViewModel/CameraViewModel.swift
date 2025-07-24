//
//  CameraViewModel.swift
//  DetectionPOC
//
//  Created by Alexandre Porto Alegre on 13/07/25.
//

import Foundation
import CoreImage
import CoreMedia
import Observation
import MLKitPoseDetectionCommon

@Observable
class CameraViewModel {
    var currentFrame: CGImage?
    var detectedPoses: [PoseIdentifiable] = []
    
    private let cameraManager = CameraManager()
    private var currentOrientation: CGImagePropertyOrientation = .right
    private let frameContext = CIContext()
    
    func startCamera() async {
        cameraManager.delegate = self
        for await buffer in cameraManager.previewStream {
            processBuffer(buffer)
        }
    }
    
    func stopCamera() {
        cameraManager.stopCapture()
    }
    
    private func processBuffer(_ buffer: CMSampleBuffer) {
        Task { @MainActor in
            currentFrame = buffer.toCGImage(context: frameContext, orientation: currentOrientation)
        }
    }
}

extension CameraViewModel: PoseDetectorDelegate {
    func forwardPoses(for result: [Pose]) {
        self.detectedPoses = result.compactMap({ pose in
            var objDescription = ""
            dump(pose.landmarks, to: &objDescription)
            return PoseIdentifiable(pose: pose, description: objDescription)
        })
    }
}
