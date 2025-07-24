//
//  PoseView.swift
//  DetectionPOC
//
//  Created by Alexandre Porto Alegre on 16/07/25.
//
import SwiftUI
import MLKit

struct PoseOverlayView: View {
    
    var pose: Pose?
    
    //What if the right side is visible?
    private var lowerBodyHeight: CGFloat? {
        guard let pose = pose else { return 1 }
        
        
        if let pose = pose {
            return distance(from: pose.landmark(ofType: .leftAnkle).position , to: pose.landmark(ofType: .leftKnee).position) + distance(from: pose.landmark(ofType: .leftKnee).position, to: pose.landmark(ofType: .leftHip).position)
        }
        return 1
    }
    
    private var upperBodyHeight: CGFloat? {
        if let pose = pose {
            return distance(from: pose.landmark(ofType: .leftWrist).position , to: pose.landmark(ofType: .leftElbow).position) + distance(from: pose.landmark(ofType: .leftElbow).position, to: pose.landmark(ofType: .leftShoulder).position)
        }
        return 1
    }
    
    var body: some View {
        ZStack{
            
        }
    }
    
    private func averageReliability
    
    func distance(from point1: VisionPoint, to point2: VisionPoint) -> CGFloat{
        let xDiff = point1.x - point2.x
        let yDiff = point1.y - point2.y
        return CGFloat(sqrt(pow(xDiff, 2) + pow(yDiff, 2)))
    }
}
