//
//  selectFurniture.swift
//  MMS
//
//  Created by Dylan Johnson on 3/24/22.
//

import SwiftUI

struct selectFurniture: View {
    @ObservedObject var furnitureService = FurnitureService()
    var body: some View {
        NavigationView {
            ForEach(furnitureService.furniture) { piece in
                Text("\(piece.name), \(piece.weight)")
            }
        }.onAppear(perform: {
            furnitureService.downloadFurniture()
        })
    }
}

struct selectFurniture_Previews: PreviewProvider {
    static var previews: some View {
        selectFurniture()
    }
}
