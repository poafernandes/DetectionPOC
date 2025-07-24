//
//  PoseHashable.swift
//  DetectionPOC
//
//  Created by Alexandre Porto Alegre on 16/07/25.
//
import MLKitPoseDetectionCommon

struct PoseIdentifiable: Identifiable {
    let id = UUID()
    let pose: Pose
    var description: String
}
