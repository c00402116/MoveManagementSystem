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
    @State var furnitureSelectedOrig = Set<String>()
    //@State var weightAccumulated: Int = 0
    @AppStorage("totalWeightOrig") var totalWeightOrig : Int = 0
    @AppStorage("totalWeightDest") var totalWeightDest : Int = 0
    @AppStorage("totalWeight") var totalWeight : Int = 0
    
    @AppStorage("totalWeightOrigDetail") var totalWeightOrigDetail : Int = 0
    @AppStorage("totalWeightDestDetail") var totalWeightDestDetail : Int = 0
    @AppStorage("totalWeightDetail") var totalWeightDetail : Int = 0
    
    @State var PrelimOrDetail: Bool = true
    //true = Preliminary
    //false = Detailed
    //this is to keep the totalWeight variable separate. As they were, the two forms used the same total weight variable.
    
    //issue with the set.. it doesn't keep data between different views. need a way to store
    //the furniture selected
    // ill have to create a view for orig and dest passing the array of furniture selected in each to have it save
    //also this current implementation only allows for one of each furniture, need to take into account that
    // the user can have multiple pieces of the same furniture -> seperate view that allows the user to see
    // furniture selected with the option to delete duplicates if necessary?
    var body: some View {
        NavigationView {
            List(self.furnitureService.furniture, selection: $furnitureSelectedOrig){ type in
                /*ForEach(furnitureService.furniture) { piece in
                 Text("\(piece.name), Weight: \(piece.weight)")
                 }*/
                
                HStack {
                    Image(systemName: "checkmark")
                        .foregroundColor(furnitureSelectedOrig.contains(type.name) ? Color.black : Color.white)
                    
                    if (PrelimOrDetail) {
                        Text("\(type.name), Weight: \(type.weight) lbs.")
                            .onTapGesture {
                                if self.furnitureSelectedOrig.contains(type.name) {
                                    self.furnitureSelectedOrig.remove(type.name)
                                    self.totalWeightOrig -= type.weight
                                } else {
                                    self.furnitureSelectedOrig.insert(type.name)
                                    self.totalWeightOrig += type.weight
                                }
                            }
                    } else if (!PrelimOrDetail) {
                        Text("\(type.name), Weight: \(type.weight) lbs.")
                            .onTapGesture {
                                if self.furnitureSelectedOrig.contains(type.name) {
                                    self.furnitureSelectedOrig.remove(type.name)
                                    self.totalWeightOrigDetail -= type.weight
                                } else {
                                    self.furnitureSelectedOrig.insert(type.name)
                                    self.totalWeightOrigDetail += type.weight
                                }
                            }
                    }
                }
            }
            .navigationBarItems(trailing: backButton)
            .navigationBarItems(leading: titleView)
        }.navigationBarHidden(true)
        //.navigationBarTitle("Furniture List")
            .navigationViewStyle(.stack)
            .onAppear(perform: {
                furnitureService.downloadFurniture()
                debugPrint(furnitureSelectedOrig)
            })
        HStack {
            if (PrelimOrDetail) {
                Text("Total Weight(Origin): \(totalWeightOrig)")
                Button(action: {
                    totalWeightOrig = 0
                    totalWeight = 0
                }) {
                    Text("Reset Weight")
                }
            } else {
                Text("Total Weight(Origin): \(totalWeightOrigDetail)")
                Button(action: {
                    totalWeightOrigDetail = 0
                    totalWeightDetail = 0
                }) {
                    Text("Reset Weight")
                }
            }
        }
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
    var titleView: some View {
        Text("Furniture List")
            .font(.largeTitle)
    }
}

struct selectFurnitureDest: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var furnitureService = FurnitureService()
    @State var furnitureSelectedDest = Set<String>()
    //@State var weightAccumulated: Int = 0
    @AppStorage("totalWeightOrig") var totalWeightOrig : Int = 0
    @AppStorage("totalWeightDest") var totalWeightDest : Int = 0
    @AppStorage("totalWeight") var totalWeight : Int = 0
    
    @AppStorage("totalWeightOrigDetail") var totalWeightOrigDetail : Int = 0
    @AppStorage("totalWeightDestDetail") var totalWeightDestDetail : Int = 0
    @AppStorage("totalWeightDetail") var totalWeightDetail : Int = 0
    
    @State var PrelimOrDetail: Bool = true

    
    var body: some View {
        NavigationView {
            List(self.furnitureService.furniture, selection: $furnitureSelectedDest){ type in
                /*ForEach(furnitureService.furniture) { piece in
                 Text("\(piece.name), Weight: \(piece.weight)")
                 }*/
                
                if (PrelimOrDetail) {
                Text("\(type.name), Weight: \(type.weight) lbs.")
                    .onTapGesture {
                        if self.furnitureSelectedDest.contains(type.name) {
                            self.furnitureSelectedDest.remove(type.name)
                            self.totalWeightDest -= type.weight
                        } else {
                            self.furnitureSelectedDest.insert(type.name)
                            self.totalWeightDest += type.weight
                        }
                    }
                } else {
                    Text("\(type.name), Weight: \(type.weight) lbs.")
                        .onTapGesture {
                            if self.furnitureSelectedDest.contains(type.name) {
                                self.furnitureSelectedDest.remove(type.name)
                                self.totalWeightDestDetail -= type.weight
                            } else {
                                self.furnitureSelectedDest.insert(type.name)
                                self.totalWeightDestDetail += type.weight
                            }
                        }
                }
            }
            .navigationBarItems(trailing: backButton)
            .navigationBarItems(leading: titleView)
        }.navigationBarHidden(true)
        //.navigationBarTitle("Furniture List")
            .navigationViewStyle(.stack)
            .onAppear(perform: {
                furnitureService.downloadFurniture()
            })
        HStack {
            if (PrelimOrDetail) {
                Text("Total Weight(Dest): \(totalWeightDest)")
                Button(action: {
                    totalWeightDest = 0
                    totalWeight = 0
                }) {
                    Text("Reset Weight")
                }
            } else {
                Text("Total Weight(Dest): \(totalWeightDestDetail)")
                Button(action: {
                    totalWeightDestDetail = 0
                    totalWeightDetail = 0
                }) {
                    Text("Reset Weight")
                }
            }
        }
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
    var titleView: some View {
        Text("Furniture List")
            .font(.largeTitle)
    }
}


struct selectFurniture_Previews: PreviewProvider {
    static var previews: some View {
        selectFurniture()
    }
}
