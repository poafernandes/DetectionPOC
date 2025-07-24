//
//  PoseDetectorDelegate.swift
//  DetectionPOC
//
//  Created by Alexandre Porto Alegre on 16/07/25.
//
import MLKitPoseDetectionCommon

protocol PoseDetectorDelegate: AnyObject {
    func forwardPoses(for result: [Pose])
}
