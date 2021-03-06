//
//  PreliminarySurvey.swift
//  MMS
//
//  Created by Daniel Metrejean on 2/3/22.
//

import SwiftUI
import CoreLocation

struct PreliminarySurvey: View {
    
    @AppStorage("email") var emailLoggedIn: String = ""
    @AppStorage("password") var passwordLoggedIn: String = ""
    @AppStorage("customerID") var customerID: Int = 0
    @AppStorage("loggedIn") var loggedIn: Bool = false
    
    @ObservedObject var jobService = JobService()
    @ObservedObject var customerService = CustomerService()
    @ObservedObject var stopsService = StopsService()
    @ObservedObject var furnitureService = FurnitureService()
    
    @State var addJobSuccess: Int = 0
    @State var addStopSuccess: Int = 0
    
    @State var origAddrDisabled: Bool = true
    @State var showOrigItems: Bool = false
    @State var origOrDest: Bool = true
    
    @State var furnitureSelectedOrig = Set<String>()
    @State var furnitureSelectedDest = Set<String>()
    
    //passes true to editPrelimSurvey.swift if you click edit on ORIGIN
    //passes false if you click on edit DESTINATION
    
    @AppStorage("address1") var address1: String = ""
    @AppStorage("address2") var address2: String = ""
    @AppStorage("address3") var address3: String = ""
    @AppStorage("type") var type: Int = 0
    @AppStorage("floor") var floor: Int = 1
    @AppStorage("sqft") var sqft: Int = 0
    
    @AppStorage("address1dest") var address1dest: String = ""
    @AppStorage("address2dest") var address2dest: String = ""
    @AppStorage("address3dest") var address3dest: String = ""
    @AppStorage("typeDest") var typeDest: Int = 0
    @AppStorage("floorDest") var floorDest: Int = 1
    @AppStorage("sqftDest") var sqftDest: Int = 0
    
    @AppStorage("totalWeightOrig") var totalWeightOrig : Int = 0
    @AppStorage("totalWeightDest") var totalWeightDest : Int = 0
    @AppStorage("totalWeight") var totalWeight : Int = 0
    
    @State var distance: Double = 0.0
    
    var typeOptions: [String] = ["Residential Home", "Apartment Complex", "Business"]
    
    @State var showAlert: Bool = false
    @State var costEstimate: Int = 0
    @State var timeEstimate: Int = 0
    
    var body: some View {
        ScrollView {
            Section {
                VStack {
                    HStack {
                        Text("**Origin**")
                            .foregroundColor(Color.white)
                            .font(.system(size: 28))
                            .padding()
                        Spacer()
                    }
                    HStack {
                        Text("Address")
                            .foregroundColor(Color.white)
                            .padding()
                        Spacer()
                        if (address1 == "" && address3 == "") {
                            Text("select Edit")
                                .foregroundColor(Color.white)
                                .italic()
                                .padding()
                        } else if (address1 != "" && address2 == "") {
                            Text("\(address1)\n\(address3)")
                                .foregroundColor(Color.white)
                                .padding()
                        } else if (address1 != "" && address2 != "") {
                            Text("\(address1)\n\(address2)\n\(address3)")
                                .foregroundColor(Color.white)
                                .padding()
                        } else if (address1 == "" || address3 == "") {
                            Text("select Edit")
                                .foregroundColor(Color.white)
                                .italic()
                                .padding()
                        }
                    }
                    HStack {
                        Text("Residence Type")
                            .foregroundColor(Color.white)
                            .padding()
                        Spacer()
                        Text("\(typeOptions[type])")
                            .foregroundColor(Color.white)
                            .padding()
                    }
                    HStack {
                        if (sqft > 0) {
                            Text("**\(sqft)** sq. ft.")
                                .foregroundColor(Color.white)
                                .padding()
                        } else {
                            Text("sq. ft. not set")
                                .foregroundColor(Color.white)
                                .italic()
                                .padding()
                        }
                        Text("Floors:   **\(floor)**")
                            .foregroundColor(Color.white)
                            .padding()
                        
                        Stepper("", value: $floor, in: 0...99)
                            .padding()
                    }
                    /*HStack {
                        if (sqft > 0) {
                            Text("**\(sqft)** sq. ft.")
                                .foregroundColor(Color.white)
                                .padding()
                        } else {
                            Text("Select Edit to set sq. ft.")
                                .foregroundColor(Color.white)
                                .italic()
                                .padding()
                        }
                    }*/
                    HStack {
                        Text("Itemized List")
                            .foregroundColor(Color.white)
                            .padding()
                        NavigationLink(destination: selectFurniture(furnitureSelectedOrig: furnitureSelectedOrig, PrelimOrDetail: true)) {
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color.white)
                        }
                        //Text("**\(totalWeightOrig)** lbs.")
                        //    .foregroundColor(Color.white)
                        Spacer()
                        NavigationLink(destination: editAddressView(origOrDest: origOrDest)) {
                            Text("Edit")
                                .foregroundColor(Color.white)
                                .padding()
                        }
                    }
                }
            }
            .background(Color.green)
            .cornerRadius(8)
            .padding()
            Section {
                VStack {
                    HStack {
                        Text("**Destination**")
                            .foregroundColor(Color.white)
                            .font(.system(size: 28))
                            .padding()
                        Spacer()
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(Color.white)
                        Text("\((distance/1000), specifier:"%.1f") km")
                            .foregroundColor(Color.white)
                            .padding()
                            .onChange(of: address1) { _ in
                                debugPrint(address1, address3, address1dest, address3dest)
                                getDistance(address1, address3, address1dest, address3dest)
                            }
                            .onChange(of: address3) { _ in
                                debugPrint(address1, address3, address1dest, address3dest)
                                getDistance(address1, address3, address1dest, address3dest)
                            }
                            .onChange(of: address1dest) { _ in
                                debugPrint(address1, address3, address1dest, address3dest)
                                getDistance(address1, address3, address1dest, address3dest)
                            }
                            .onChange(of: address3dest) { _ in
                                debugPrint(address1, address3, address1dest, address3dest)
                                getDistance(address1, address3, address1dest, address3dest)
                            }
                    }
                    HStack {
                        Text("Address")
                            .foregroundColor(Color.white)
                            .padding()
                        Spacer()
                        if (address1dest == "" && address3dest == "") {
                            Text("select Edit")
                                .foregroundColor(Color.white)
                                .italic()
                                .padding()
                        } else if (address1dest != "" && address2dest == "") {
                            Text("\(address1dest)\n\(address3dest)")
                                .foregroundColor(Color.white)
                                .padding()
                        } else if (address1dest != "" && address2dest != "") {
                            Text("\(address1dest)\n\(address2dest)\n\(address3dest )")
                                .foregroundColor(Color.white)
                                .padding()
                        } else if (address1dest == "" || address3dest == "") {
                            Text("select Edit")
                                .foregroundColor(Color.white)
                                .italic()
                                .padding()
                        }
                    }
                    HStack {
                        Text("Residence Type")
                            .foregroundColor(Color.white)
                            .padding()
                        Spacer()
                        Text("\(typeOptions[typeDest])")
                            .foregroundColor(Color.white)
                            .padding()
                    }
                    HStack {
                        if (sqftDest > 0) {
                            Text("**\(sqftDest)** sq. ft.")
                                .foregroundColor(Color.white)
                                .padding()
                        } else {
                            Text("sq. ft. not set")
                                .foregroundColor(Color.white)
                                .italic()
                                .padding()
                        }
                        Text("Floors:   **\(floorDest)**")
                            .foregroundColor(Color.white)
                            .padding()
                        
                        Stepper("", value: $floorDest, in: 0...99)
                            .padding()
                    }
                    /*HStack {
                        if (sqftDest > 0) {
                            Text("**\(sqftDest)** sq. ft.")
                                .foregroundColor(Color.white)
                                .padding()
                        } else {
                            Text("Select Edit to set sq. ft.")
                                .foregroundColor(Color.white)
                                .italic()
                                .padding()
                        }
                    }*/
                    HStack {
                        Text("Itemized List")
                            .foregroundColor(Color.white)
                            .padding()
                        NavigationLink(destination: selectFurnitureDest(furnitureSelectedDest: furnitureSelectedDest, PrelimOrDetail: true)) {
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color.white)
                        }
                        //Text("**\(totalWeightDest)** lbs.")
                        //    .foregroundColor(Color.white)
                        Spacer()
                        NavigationLink(destination: editAddressView(origOrDest: !origOrDest)) {
                            Text("Edit")
                                .foregroundColor(Color.white)
                                .padding()
                        }
                    }
                }
            }
            .background(Color.red)
            .cornerRadius(8)
            .padding()
            
            NavigationLink(destination: PreliminaryEstimates(sqft: sqft, sqftDest: sqftDest, distance: distance)) {
                Button(action: {}) {
                    Text("Get Free Estimate")
                        .padding()
                        .foregroundColor(Color.white)
                }
                .buttonStyle(PlainButtonStyle())
                .frame(width: 400, height: 80)
                .background((address1 == "" || address3 == "" || address1dest == "" || address3dest == "") ? Color.gray : Color.blue)
                .cornerRadius(8)
            }
            .disabled(address1 == "" || address3 == "" || address1dest == "" || address3dest == "")
        }
    }
    
    public func getDistance(_ address1: String, _ address3: String, _ address1dest: String, _ address3dest: String) -> Void {
        debugPrint("\(address1), \(address3)")
        debugPrint("\(address1dest), \(address3dest)")
        
        if (address1 == "" || address3 == "" || address1dest == "" || address3dest == "") {
            return
        }
        
        let orig = address1 + ", " + address3
        let dest = address1dest + ", " + address3dest
        
        var lat1: Double = 0.0
        var lon1: Double = 0.0
        var lat2: Double = 0.0
        var lon2: Double = 0.0
        
        var coordinate0 = CLLocation()
        var coordinate1 = CLLocation()
        
        let geocoder = CLGeocoder()
        var distanceInMeters: Double = 0.0
        
        
        geocoder.geocodeAddressString(orig) {
            placemarks, error in
            let placemark = placemarks?.first
            let lat = placemark?.location?.coordinate.latitude
            let lon = placemark?.location?.coordinate.longitude
            lat1 = (Double)(lat!)
            lon1 = (Double)(lon!)
        }
        
        
        let geocoder2 = CLGeocoder()
        geocoder2.geocodeAddressString(dest) {
            placemarks, error in
            let placemark = placemarks?.first
            let lat = placemark?.location?.coordinate.latitude
            let lon = placemark?.location?.coordinate.longitude
            lat2 = (Double)(lat!)
            lon2 = (Double)(lon!)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            debugPrint(lat1, lon1, lat2, lon2)
            coordinate0 = CLLocation(latitude: lat1, longitude: lon1)
            coordinate1 = CLLocation(latitude: lat2, longitude: lon2)
            
            distanceInMeters = coordinate0.distance(from: coordinate1)
            debugPrint(distanceInMeters)
            distance = (Double)(distanceInMeters)
        }
    }
}

struct editAddressView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @AppStorage("origOrDest") var origOrDest: Bool = true
    
    @AppStorage("address1") var address1: String = ""
    @AppStorage("address2") var address2: String = ""
    @AppStorage("address3") var address3: String = ""
    @AppStorage("type") var type: Int = 0
    @AppStorage("sqft") var sqft: Int = 0
    
    @AppStorage("address1dest") var address1dest: String = ""
    @AppStorage("address2dest") var address2dest: String = ""
    @AppStorage("address3dest") var address3dest: String = ""
    @AppStorage("typeDest") var typeDest: Int = 0
    @AppStorage("sqftDest") var sqftDest: Int = 0
    
    var typeOptions: [String] = ["Residential Home", "Apartment Complex", "Business"]
    
    
    var body: some View {
        ScrollView {
            if (origOrDest) {
                Section {
                    VStack {
                        HStack {
                            Text("Street")
                                .foregroundColor(Color.white)
                                .padding()
                            TextField("Street Adress", text: $address1)
                                .foregroundColor(Color.white)
                                .frame(width: 260)
                                .padding()
                        }
                        HStack {
                            Text("Apt/Suite")
                                .foregroundColor(Color.white)
                                .padding()
                            TextField("Apt/Suite", text: $address2)
                                .foregroundColor(Color.white)
                                .frame(width: 260)
                                .padding()
                        }
                        HStack {
                            Text("City/State")
                                .foregroundColor(Color.white)
                                .padding()
                            TextField("City/State", text: $address3)
                                .foregroundColor(Color.white)
                                .frame(width: 260)
                                .padding()
                        }
                        HStack {
                            Text("Residence Type")
                                .foregroundColor(Color.white)
                                .padding()
                            Spacer()
                            Picker("", selection: $type) {
                                ForEach(0..<typeOptions.count) { option in
                                    Text("\(typeOptions[option])")
                                }
                            }
                            .foregroundColor(Color.white)
                            .padding()
                            Image(systemName: "chevron.down")
                                .foregroundColor(Color.white)
                                .padding()
                        }
                        HStack {
                            Text("Sq. Ft.")
                                .foregroundColor(Color.white)
                                .padding()
                            TextField("Sq. Ft.", value: $sqft, formatter: NumberFormatter())
                                .foregroundColor(Color.white)
                                .padding()
                        }
                    }
                }
                .background(Color.green)
                .cornerRadius(8)
                .padding()
            }
            if (!origOrDest) {
                Section {
                    VStack {
                        HStack {
                            Text("Street")
                                .foregroundColor(Color.white)
                                .padding()
                            TextField("Street Adress", text: $address1dest)
                                .foregroundColor(Color.white)
                                .frame(width: 260)
                                .padding()
                        }
                        HStack {
                            Text("Apt/Suite")
                                .foregroundColor(Color.white)
                                .padding()
                            TextField("Apt/Suite", text: $address2dest)
                                .foregroundColor(Color.white)
                                .frame(width: 260)
                                .padding()
                        }
                        HStack {
                            Text("City/State")
                                .foregroundColor(Color.white)
                                .padding()
                            TextField("City/State", text: $address3dest)
                                .foregroundColor(Color.white)
                                .frame(width: 260)
                                .padding()
                        }
                        HStack {
                            Text("Residence Type")
                                .foregroundColor(Color.white)
                                .padding()
                            Spacer()
                            Picker("", selection: $typeDest) {
                                ForEach(0..<typeOptions.count) { option in
                                    Text("\(typeOptions[option])")
                                }
                            }
                            .foregroundColor(Color.white)
                            .padding()
                            Image(systemName: "chevron.down")
                                .foregroundColor(Color.white)
                                .padding()
                        }
                        HStack {
                            Text("Sq. Ft.")
                                .foregroundColor(Color.white)
                                .padding()
                            TextField("Sq. Ft.", value: $sqftDest, formatter: NumberFormatter())
                                .foregroundColor(Color.white)
                                .padding()
                        }
                    }
                }
                .background(Color.red)
                .cornerRadius(8)
                .padding()
            }
        }
    }
}

struct PreliminarySurvey_Previews: PreviewProvider {
    static var previews: some View {
        PreliminarySurvey(address1: "", address2: "", address3: "", type: 0, floor: 1)
    }
}
