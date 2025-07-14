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

@Observable
class CameraViewModel {
    var currentFrame: CGImage?
    private let cameraManager = CameraManager()
    
    private var currentOrientation: CGImagePropertyOrientation = .right
    
    private let frameContext = CIContext()
    
    func startCamera() async {
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
//           Forward to PoseDetection
        }
    }
}
