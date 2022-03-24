//
//  selectFurniture.swift
//  MMS
//
//  Created by Dylan Johnson on 3/24/22.
//

import SwiftUI

struct selectFurniture: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var furnitureService = FurnitureService()
    var body: some View {
        NavigationView {
            List{
                Text("Furniture List")
                    .font(.largeTitle)
                ForEach(furnitureService.furniture) { piece in
                    Text("\(piece.name), Weight: \(piece.weight)")
                }
            }.navigationBarItems(leading: backButton)
        }.navigationBarHidden(true)
            //.navigationTitle("Furniture List")
            .navigationViewStyle(.stack)
            .onAppear(perform: {
                furnitureService.downloadFurniture()
            })
    }
    
    
    
    var backButton: some View {
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Back") // 2
                }
            })
        }
}

struct selectFurniture_Previews: PreviewProvider {
    static var previews: some View {
        selectFurniture()
    }
}
