//
//  HomeView.swift
//  DetectionPOC
//
//  Created by Alexandre Porto Alegre on 10/07/25.
//
import SwiftUI

struct HomeView: View {
    @State private var selectedRoute: Route?
    
    enum Route: Identifiable {
        case camera, library
        var id: Self { self }
    }
    
    var body: some View {
        VStack {
            Button(action: { selectedRoute = .camera }) {
                Label("Camera", systemImage: "camera")
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            Button(action: { selectedRoute = .library }) {
                Label("Library", systemImage: "photo.on.rectangle")
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }.fullScreenCover(item: $selectedRoute) { route in
            switch route {
            case .camera:
                //Open screen
                CameraStreamView()
            case .library:
                //OpenScreen
                CameraStreamView()
            }
        }
    }
}

#Preview {
    HomeView()
}
