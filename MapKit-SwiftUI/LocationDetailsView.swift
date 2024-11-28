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
            }
        }
    }
}

#Preview {
    LocationDetailsView(mapSelectedResults: .constant(nil))
}
