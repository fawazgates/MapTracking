//
//  LocationDetailsView.swift
//  MapTracker
//
//  Created by User on 23/02/24.
//

import Foundation
import SwiftUI
import MapKit

struct LocationDetailsView: View {
    @Binding var mapSelection: MKMapItem?
    @Binding var show: Bool
    @State private var lookAroundScane: MKLookAroundScene?
    @Binding var getDirections: Bool
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading){
                    Text(mapSelection?.placemark.name ?? "")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text(mapSelection?.placemark.title ?? "")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                        .lineLimit(2)
                        .padding(.trailing)
                }
                
                Spacer()
                
                Button {
                    show.toggle()
                    mapSelection = nil
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.gray, Color(.systemGray4))
                }
            }
            if let scene = lookAroundScane {
                LookAroundPreview(initialScene: scene)
                    .frame(height: 200)
                    .cornerRadius(12)
                    .padding()
            } else {
                ContentUnavailableView("No preview available", systemImage: "eye.slash")
            }
            
            HStack(spacing: 24) {
                Button {
                    if let mapSelection {
                        mapSelection.openInMaps()
                    }
                    } label: {
                        Text("Open in Maps")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 170, height: 48)
                            .background(.green)
                            .cornerRadius(12)
                    }
                    
                    Button {
                        getDirections = false
                        show = false
                    } label: {
                        Text("Get Directions")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 170, height: 48)
                            .background(.blue)
                            .cornerRadius(12)
                    }
                }
            .padding(.horizontal)
        }
        .onAppear {
            print("DEBUG: Did call on appear")
            fetchLookAroundPreview()
        }
        .onChange(of: mapSelection) { oldValue, newValue in
          print("DEBUG: Did call on change")
            fetchLookAroundPreview()
        }
        .padding()
    }
}

extension LocationDetailsView {
    func fetchLookAroundPreview() {
        if let mapSelection {
            lookAroundScane = nil
            Task {
                let request = MKLookAroundSceneRequest(mapItem: mapSelection)
                lookAroundScane = try? await request.scene
            }
        }
    }
}

#Preview {
    LocationDetailsView(mapSelection: .constant(nil), show: .constant(false), getDirections: .constant(false))
}
