//
//  ContentView.swift
//  MapKit-SwiftUI
//
//  Created by Denidu Gamage on 2024-11-28.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var cameraPosition : MapCameraPosition = .region(.userRegion)
    @State private var userInput : String = ""
    @State private var result = [MKMapItem]()
    @State private var mapSelectedResults: MKMapItem?
    
    var body: some View {
        Map(position: $cameraPosition, selection: $mapSelectedResults){
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
            ForEach(result, id: \.self){ item in
                let placemarks = item.placemark
                Marker(placemarks.name ?? "", coordinate: placemarks.coordinate)
            }
        }
        .overlay(alignment: .topLeading){
            TextField("Search for a location...", text: $userInput)
                .font(.subheadline)
                .padding(12)
                .background(.white)
                .shadow(radius: 10)
                .padding()
                
        }.onSubmit(of: .text) {
            Task{await searchPlaces()}
        }
        .onChange(of: mapSelectedResults, { oldValue, newValue in
            Text("Hi")
        })
        .mapControls {
            MapCompass()
            MapPitchToggle()
            MapUserLocationButton()
        }
    }
}

extension ContentView{
    func searchPlaces()async{
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = userInput
        request.region = .userRegion
        
        let result = try? await MKLocalSearch(request: request).start()
        self.result = result?.mapItems ?? []
    }
}

extension CLLocationCoordinate2D{
    static var userLocation : CLLocationCoordinate2D{
        return .init(latitude: 7.2890275, longitude: 80.6591573)
    }
}

extension MKCoordinateRegion{
    static var userRegion : MKCoordinateRegion{
        return .init(center: .userLocation, latitudinalMeters: 10000, longitudinalMeters: 10000)
    }
}

#Preview {
    ContentView()
}
