//
//  HomeView.swift
//  DetectionPOC
//
//  Created by Alexandre Porto Alegre on 10/07/25.
//
import SwiftUI

struct HomeView: View {
    @State private var path = NavigationPath()
    @State private var selectedRoute: Route?
    
    enum Route: Identifiable {
        case camera, library
        var id: Self { self }
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Button(action: { selectedRoute = .camera }) {
                    Label("Camera", systemImage: "camera")
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: { selectedRoute = .library }) {
                    Label("Photo Library", systemImage: "photo.on.rectangle")
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .camera:
                    CameraStreamView()
                case .library:
                    //WIP
                    CameraStreamView()
                }
            }
            .onChange(of: selectedRoute, initial: false) { _, newRoute in
                print(path)
                if let route = newRoute {
                    path.append(route)
                    selectedRoute = nil
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
