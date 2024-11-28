//
//  ContentView.swift
//  MapKit-SwiftUI
//
//  Created by Denidu Gamage on 2024-11-28.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var cameraPosition: MapCameraPosition = .region(.userRegion)
    @State private var userInput: String = ""
    @State private var result = [MKMapItem]()
    @State private var mapSelectedResults: MKMapItem?
    @State private var showDetails: Bool = false

    var body: some View {
        Map(position: $cameraPosition, selection: $mapSelectedResults) {
            Annotation("My Location", coordinate: .userLocation) {
                ZStack {
                    Circle()
                        .frame(width: 32, height: 32)
                        .foregroundColor(.blue.opacity(0.25))
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                    Circle()
                        .frame(width: 12, height: 12)
                        .foregroundColor(.blue)
                }
            }

            ForEach(result, id: \.self) { item in
                let placemark = item.placemark
                let name = placemark.name ?? ""
                let coordinate = placemark.coordinate

                Marker(name, coordinate: coordinate)
            }
        }
        .overlay(alignment: .topLeading) {
            searchFieldOverlay
        }
        .onSubmit(of: .text) {
            Task { await searchPlaces() }
        }
        .onChange(of: mapSelectedResults) { newValue in
            showDetails = newValue != nil
        }
        .sheet(isPresented: $showDetails) {
            LocationDetailsView(mapSelectedResults: $mapSelectedResults, show: showDetails)
                .presentationDetents([.height(340)])
                .presentationBackgroundInteraction(.enabled(upThrough: .height(340)))
                .presentationCornerRadius(12)
        }
        .mapControls {
            MapCompass()
            MapPitchToggle()
            MapUserLocationButton()
        }
    }

    var searchFieldOverlay: some View {
        TextField("Search for a location...", text: $userInput)
            .font(.subheadline)
            .padding(12)
            .background(.white)
            .shadow(radius: 10)
            .padding()
    }

    func searchPlaces() async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = userInput
        request.region = .userRegion

        if let result = try? await MKLocalSearch(request: request).start() {
            self.result = result.mapItems
        }
    }
}

extension CLLocationCoordinate2D {
    static var userLocation: CLLocationCoordinate2D {
        .init(latitude: 7.2890275, longitude: 80.6591573)
    }
}

extension MKCoordinateRegion {
    static var userRegion: MKCoordinateRegion {
        .init(center: .userLocation, latitudinalMeters: 10000, longitudinalMeters: 10000)
    }
}

#Preview {
    ContentView()
}
