//
//  CameraStreamView.swift
//  DetectionPOC
//
//  Created by Alexandre Porto Alegre on 13/07/25.
//
import SwiftUI

struct CameraStreamView: View {
    @State private var cameraVM = CameraViewModel()
    
    var body: some View {
        ZStack {
            if let frame = cameraVM.currentFrame {
                Image(frame, scale: 1.0, label: Text("Camera feed"))
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
            }
            LazyVStack {
                ForEach(cameraVM.detectedPoses) { detection in
                    Text(detection.description)
                        .padding()
                        .font(.title)
                }
            }
            .padding()
        }
        .task {
            await cameraVM.startCamera()
        }
        .onDisappear() {
            cameraVM.stopCamera()
        }
    }
}

#Preview {
    CameraStreamView()
}
