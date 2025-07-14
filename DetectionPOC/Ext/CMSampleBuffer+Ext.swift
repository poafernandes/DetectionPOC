//
//  CMSampleBuffer+Ext.swift
//  DetectionPOC
//
//  Created by Alexandre Porto Alegre on 13/07/25.
//
import AVFoundation
import CoreImage

extension CMSampleBuffer {
    func toCGImage (context: CIContext, orientation: CGImagePropertyOrientation = .up) -> CGImage? {
        guard let imagePixelBuffer = CMSampleBufferGetImageBuffer(self) else {
            return nil
        }
        let image = CIImage(cvPixelBuffer: imagePixelBuffer).oriented(orientation)
        return context.createCGImage(image, from: image.extent)
    }
}
