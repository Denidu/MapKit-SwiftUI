//
//  LocationDetailsView.swift
//  MapKit-SwiftUI
//
//  Created by Denidu Gamage on 2024-11-28.
//

import SwiftUI
import MapKit

struct LocationDetailsView: View {
    
    @Binding var mapSelectedResults : MKMapItem?
    @State var show : Bool = false
    @State private var lookAroundImage: MKLookAroundScene?
    
    var body: some View {
        VStack{
            HStack{
                VStack(alignment: .leading){
                    Text(mapSelectedResults?.placemark.name ?? "").font(.title2)
                        .fontWeight(.semibold)
                        
                    Text(mapSelectedResults?.placemark.title ?? "").font(.footnote)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                        .padding(.trailing)
                }
                
                Spacer()
                
                Button{
                    show.toggle()
                    mapSelectedResults = nil
                }label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.gray, Color(.systemGray6) )
                }
            }
        }
        if let scene = lookAroundImage{
            LookAroundPreview(initialScene: scene)
                .frame(height: 200)
                .cornerRadius(10)
                .padding()
        }else{
            ContentUnavailableView("No preview Availble", systemImage: "eye.slash.fill")
        }
    }
}

#Preview {
    LocationDetailsView(mapSelectedResults: .constant(nil))
}
