//
//  MyJobs.swift
//  MMS
//
//  Created by Daniel Metrejean on 4/1/22.
//

import SwiftUI

struct MyJobs: View {
    
    @AppStorage("totalWeightOrig") var totalWeightOrigDetail : Int = 0
    @AppStorage("totalWeightDest") var totalWeightDestDetail : Int = 0
    @ObservedObject var adminService = AdminService()
    var body: some View {
        NavigationView {
            Section{
                VStack {
                    Text("Job #1")
                        .foregroundColor(Color.white)
                        .padding()
                        .font(.title)
                    Text("Origin Address: 211 Republic Avenue")
                        .foregroundColor(Color.white)
                    Text("                Lafayette, LA")
                            .foregroundColor(Color.white)
                    Text("                70508")
                            .foregroundColor(Color.white)
                    Text("Destination Address: 1223 St. John Street")
                        .foregroundColor(Color.white)
                    Text("                Lafayette, LA")
                        .foregroundColor(Color.white)
                    Text("                70506")
                        .foregroundColor(Color.white)
                    Text("Total weight: \(totalWeightOrigDetail + totalWeightDestDetail)")
                        .foregroundColor(Color.white)
                        .padding()
                    HStack {
                        Text("Employees Required: \(adminService.calculateAmtOfEmployees(totalWeightDestDetail + totalWeightOrigDetail))")
                            .foregroundColor(Color.red)
                        Button(action: {}) {
                            Text("Add employees")
                        }
                    }.padding()
                    VStack{
                        Text("Cost Estimate: $770.99")
                            .foregroundColor(Color.white)
                        Text("Time Estimate: 4:40 - 5:30")
                            .foregroundColor(Color.white)
                    }
                }.background(Color.green)
                    .cornerRadius(8)
                    .padding()
            }.navigationBarTitle("My Booked Jobs")
            
        }.navigationBarTitle("My Booked Jobs")
    }
}

struct MyJobs_Previews: PreviewProvider {
    static var previews: some View {
        MyJobs()
    }
}
