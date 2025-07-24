//
//  PoseViewModel.swift
//  DetectionPOC
//
//  Created by Alexandre Porto Alegre on 16/07/25.
//
import Foundation
import MLKit

@Observable
class PoseViewModel {
    private var lowerBodyHeight: CGFloat?
    private var upperBodyHeight: CGFloat?

    
    private func setupBodyHeight(from pose: Pose) -> CGFloat{
        let landmarkTypesUpper: [PoseLandmarkType] = [.leftWrist, .leftElbow, .leftShoulder]
        let landmarkTypesLower: [PoseLandmarkType] = [.leftAnkle, .leftKnee, .leftHip]
        
        //TODO: Maybe right side could be better in some situations but who knows
        let totalUpper = landmarkTypesUpper.reduce(0) { sum, landmarkType in
            sum + pose.landmark(ofType: landmarkType).inFrameLikelihood
        } / Float(landmarkTypesUpper.count)
        
        let totalLower = landmarkTypesUpper.reduce(0) { sum, landmarkType in
            sum + pose.landmark(ofType: landmarkType).inFrameLikelihood
        } / Float(landmarkTypesUpper.count)
        
        let isUpper = totalUpper >= totalLower ? true : false
        
        
        
    }
    
    //One function for lower
    //One function for distance
    //One function for upper
    //One fuction to find out which one
}
