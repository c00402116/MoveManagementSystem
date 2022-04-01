//
//  PreliminarySurvey.swift
//  MMS
//
//  Created by Daniel Metrejean on 2/3/22.
//

import SwiftUI
import CoreLocation

struct DetailedSurvey: View {
    
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
    
    @AppStorage("address1Detail") var address1Detail: String = ""
    @AppStorage("address2Detail") var address2Detail: String = ""
    @AppStorage("address3Detail") var address3Detail: String = ""
    @AppStorage("typeDetail") var typeDetail: Int = 0
    @AppStorage("floorDetail") var floorDetail: Int = 1
    @AppStorage("sqftDetail") var sqftDetail: Int = 0
    
    @AppStorage("address1DetailDest") var address1DetailDest: String = ""
    @AppStorage("address2DetailDest") var address2DetailDest: String = ""
    @AppStorage("address3DetailDest") var address3DetailDest: String = ""
    @AppStorage("typeDetailDest") var typeDetailDest: Int = 0
    @AppStorage("floorDetailDest") var floorDetailDest: Int = 1
    @AppStorage("sqftDestDetail") var sqftDestDetail: Int = 0
    
    @AppStorage("totalWeightOrig") var totalWeightOrigDetail : Int = 0
    @AppStorage("totalWeightDest") var totalWeightDestDetail : Int = 0
    @AppStorage("totalWeight") var totalWeightDetail : Int = 0
    
    @State var distanceDetail: Double = 0.0
    
    @State var companySelected: Int = 0
    
    var typeOptions: [String] = ["Residential Home", "Apartment Complex", "Business"]
    
    @State var companyOptions: [String] = ["None", "Acadiana Best Movers",  "Acadiana Movers", "A & L Movers", "Hayes House Moving and Leveling", "Palmer Moving Services", "Two Boys and a Truck"]
    @AppStorage("selection") var selection: Int = 0
    
    
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
                        if (address1Detail == "" && address3Detail == "") {
                            Text("select Edit")
                                .foregroundColor(Color.white)
                                .italic()
                                .padding()
                        } else if (address1Detail != "" && address2Detail == "") {
                            Text("\(address1Detail)\n\(address3Detail)")
                                .foregroundColor(Color.white)
                                .padding()
                        } else if (address1Detail != "" && address2Detail != "") {
                            Text("\(address1Detail)\n\(address2Detail)\n\(address3Detail)")
                                .foregroundColor(Color.white)
                                .padding()
                        } else if (address1Detail == "" || address3Detail == "") {
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
                        Text("\(typeOptions[typeDetail])")
                            .foregroundColor(Color.white)
                            .padding()
                    }
                    HStack {
                        if (sqftDetail > 0) {
                            Text("**\(sqftDetail)** sq. ft.")
                                .foregroundColor(Color.white)
                                .padding()
                        } else {
                            Text("sq. ft. not set")
                                .foregroundColor(Color.white)
                                .italic()
                                .padding()
                        }
                        Text("Floors:   **\(floorDetail)**")
                            .foregroundColor(Color.white)
                            .padding()
                        
                        Stepper("", value: $floorDetail, in: 0...99)
                            .padding()
                    }
                    HStack {
                        Text("Itemized List")
                            .foregroundColor(Color.white)
                            .padding()
                        NavigationLink(destination: selectFurniture(furnitureSelectedOrig: furnitureSelectedOrig, PrelimOrDetail: false)) {
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color.white)
                        }
                        //Text("**\(totalWeightOrig)** lbs.")
                        //    .foregroundColor(Color.white)
                        Spacer()
                        NavigationLink(destination: editAddressViewDetail(origOrDest: origOrDest)) {
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
                        Text("\((distanceDetail/1000), specifier:"%.1f") km")
                            .foregroundColor(Color.white)
                            .padding()
                            .onChange(of: address1Detail) { _ in
                                debugPrint(address1Detail, address3Detail, address1DetailDest, address3DetailDest)
                                getDistance(address1Detail, address3Detail, address1DetailDest, address3DetailDest)
                            }
                            .onChange(of: address3Detail) { _ in
                                debugPrint(address1Detail, address3Detail, address1DetailDest, address3DetailDest)
                                getDistance(address1Detail, address3Detail, address1DetailDest, address3DetailDest)
                            }
                            .onChange(of: address1DetailDest) { _ in
                                debugPrint(address1Detail, address3Detail, address1DetailDest, address3DetailDest)
                                getDistance(address1Detail, address3Detail, address1DetailDest, address3DetailDest)
                            }
                            .onChange(of: address3DetailDest) { _ in
                                debugPrint(address1Detail, address3Detail, address1DetailDest, address3DetailDest)
                                getDistance(address1Detail, address3Detail, address1DetailDest, address3DetailDest)
                            }
                    }
                    HStack {
                        Text("Address")
                            .foregroundColor(Color.white)
                            .padding()
                        Spacer()
                        if (address1DetailDest == "" && address3DetailDest == "") {
                            Text("select Edit")
                                .foregroundColor(Color.white)
                                .italic()
                                .padding()
                        } else if (address1DetailDest != "" && address2DetailDest == "") {
                            Text("\(address1DetailDest)\n\(address3DetailDest)")
                                .foregroundColor(Color.white)
                                .padding()
                        } else if (address1DetailDest != "" && address2DetailDest != "") {
                            Text("\(address1DetailDest)\n\(address2DetailDest)\n\(address3DetailDest)")
                                .foregroundColor(Color.white)
                                .padding()
                        } else if (address1DetailDest == "" || address3DetailDest == "") {
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
                        Text("\(typeOptions[typeDetailDest])")
                            .foregroundColor(Color.white)
                            .padding()
                    }
                    HStack {
                        if (sqftDestDetail > 0) {
                            Text("**\(sqftDestDetail)** sq. ft.")
                                .foregroundColor(Color.white)
                                .padding()
                        } else {
                            Text("sq. ft. not set")
                                .foregroundColor(Color.white)
                                .italic()
                                .padding()
                        }
                        Text("Floors:   **\(floorDetailDest)**")
                            .foregroundColor(Color.white)
                            .padding()
                        
                        Stepper("", value: $floorDetailDest, in: 0...99)
                            .padding()
                    }
                    HStack {
                        Text("Itemized List")
                            .foregroundColor(Color.white)
                            .padding()
                        NavigationLink(destination: selectFurnitureDest(furnitureSelectedDest: furnitureSelectedDest, PrelimOrDetail: false)) {
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color.white)
                        }
                        //Text("**\(totalWeightDest)** lbs.")
                        //    .foregroundColor(Color.white)
                        Spacer()
                        NavigationLink(destination: editAddressViewDetail(origOrDest: !origOrDest)) {
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
            
            Divider()
            HStack {
                Text("Moving Company")
                    .padding()
                Spacer()
                Picker(selection: $companySelected, label: Text("Moving Company")) {
                    ForEach(0..<companyOptions.count) {company in
                        Text("\(companyOptions[company])")
                    }
                }
                .padding()
            }
            Divider()
            
            NavigationLink(destination: DetailedEstimates(sqft: sqftDetail, sqftDest: sqftDestDetail, distance: distanceDetail, totalWeightOrigDetail: totalWeightOrigDetail, totalWeightDestDetail: totalWeightDestDetail)) {
                Button(action: {}) {
                    Text("Get Estimate")
                        .padding()
                        .foregroundColor(Color.white)
                }
                .buttonStyle(PlainButtonStyle())
                .frame(width: 400, height: 80)
                .background((companySelected == 0 || address1Detail == "" || address3Detail == "" || address1DetailDest == "" || address3DetailDest == "") ? Color.gray : Color.blue)
                .cornerRadius(8)
            }
            .disabled(companySelected == 0)
            .disabled(address1Detail == "" || address3Detail == "" || address1DetailDest == "" || address3DetailDest == "")
        }
    }
    
    public func getDistance(_ address1: String, _ address3: String, _ address1dest: String, _ address3dest: String) -> Void {
        debugPrint("\(address1), \(address3)")
        debugPrint("\(address1dest), \(address3dest)")
        
        // if any address string is empty, this function will crash the app because it is trying
        // to force unwrap an empty variable. This if statement prevents it from running unless
        // all four address strings are full.
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
            distanceDetail = (Double)(distanceInMeters)
        }
    }
}

struct editAddressViewDetail: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @AppStorage("origOrDest") var origOrDest: Bool = true
    
    @AppStorage("address1Detail") var address1Detail: String = ""
    @AppStorage("address2Detail") var address2Detail: String = ""
    @AppStorage("address3Detail") var address3Detail: String = ""
    @AppStorage("typeDetail") var typeDetail: Int = 0
    @AppStorage("floorDetail") var floorDetail: Int = 1
    @AppStorage("sqftDetail") var sqftDetail: Int = 0
    
    @AppStorage("address1DetailDest") var address1DetailDest: String = ""
    @AppStorage("address2DetailDest") var address2DetailDest: String = ""
    @AppStorage("address3DetailDest") var address3DetailDest: String = ""
    @AppStorage("typeDetailDest") var typeDetailDest: Int = 0
    @AppStorage("floorDetailDest") var floorDetailDest: Int = 1
    @AppStorage("sqftDestDetail") var sqftDestDetail: Int = 0
    
    @AppStorage("totalWeightOrig") var totalWeightOrigDetail : Int = 0
    @AppStorage("totalWeightDest") var totalWeightDestDetail : Int = 0
    @AppStorage("totalWeight") var totalWeightDetail : Int = 0
    
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
                            TextField("Street Adress", text: $address1Detail)
                                .foregroundColor(Color.white)
                                .frame(width: 260)
                                .padding()
                        }
                        HStack {
                            Text("Apt/Suite")
                                .foregroundColor(Color.white)
                                .padding()
                            TextField("Apt/Suite", text: $address2Detail)
                                .foregroundColor(Color.white)
                                .frame(width: 260)
                                .padding()
                        }
                        HStack {
                            Text("City/State")
                                .foregroundColor(Color.white)
                                .padding()
                            TextField("City/State", text: $address3Detail)
                                .foregroundColor(Color.white)
                                .frame(width: 260)
                                .padding()
                        }
                        HStack {
                            Text("Residence Type")
                                .foregroundColor(Color.white)
                                .padding()
                            Spacer()
                            Picker("", selection: $typeDetail) {
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
                            TextField("Sq. Ft.", value: $sqftDetail, formatter: NumberFormatter())
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
                            TextField("Street Adress", text: $address1DetailDest)
                                .foregroundColor(Color.white)
                                .frame(width: 260)
                                .padding()
                        }
                        HStack {
                            Text("Apt/Suite")
                                .foregroundColor(Color.white)
                                .padding()
                            TextField("Apt/Suite", text: $address2DetailDest)
                                .foregroundColor(Color.white)
                                .frame(width: 260)
                                .padding()
                        }
                        HStack {
                            Text("City/State")
                                .foregroundColor(Color.white)
                                .padding()
                            TextField("City/State", text: $address3DetailDest)
                                .foregroundColor(Color.white)
                                .frame(width: 260)
                                .padding()
                        }
                        HStack {
                            Text("Residence Type")
                                .foregroundColor(Color.white)
                                .padding()
                            Spacer()
                            Picker("", selection: $typeDetailDest) {
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
                            TextField("Sq. Ft.", value: $sqftDestDetail, formatter: NumberFormatter())
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

struct selectCompany: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var companyOptions: [String] = ["Acadiana Best Movers",  "Acadiana Movers", "A & L Movers", "Hayes House Moving and Leveling", "Palmer Moving Services", "Two Boys and a Truck"]
    @AppStorage("selection") var selection: Int = 0
    
    var body: some View {
        NavigationView {
            Picker(selection: $selection, label: Text("Company")) {
                ForEach(0..<companyOptions.count) { company in
                    Text("\(companyOptions[company])")
                        .onTapGesture {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                }
            }
        }
        .navigationTitle(Text("Select Moving Company"))
    }
}


struct Detailedsurvey_Previews: PreviewProvider {
    static var previews: some View {
        PreliminarySurvey(address1: "", address2: "", address3: "", type: 0, floor: 1)
    }
}
