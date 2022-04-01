//
//  DetailedEstimates.swift
//  MMS
//
//  Created by Daniel Metrejean on 3/31/22.
//

import SwiftUI

struct DetailedEstimates: View {
    
    @AppStorage("email") var emailLoggedIn: String = ""
    @AppStorage("password") var passwordLoggedIn: String = ""
    @AppStorage("customerID") var customerID: Int = 0
    @AppStorage("loggedIn") var loggedIn: Bool = false
    
    @State var sqft: Int = 0
    @State var sqftDest: Int = 0
    @State var distance: Double = 0
    
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
    
    @State var hoursLow: Int = 0
    @State var minutesLow: Int = 0
    @State var hoursHigh: Int = 0
    @State var minutesHigh: Int = 0
    
    @ObservedObject var jobService = JobService()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("**Cost:**")
                        .foregroundColor(Color.white)
                        .padding()
                    Spacer()
                    Text("$\((Double(sqft)*0.75)+((distance/1000)*3), specifier: "%.2f") - $\((Double(sqftDest)*0.75)+((distance/1000)*3), specifier: "%.2f")")
                        .foregroundColor(Color.white)
                        .padding()
                }
                .background(Color.green)
                .cornerRadius(8)
                .padding()
                HStack {
                    Text("**Time:**")
                        .foregroundColor(Color.white)
                        .padding()
                    Spacer()
                    Text("")
                }
                .background(Color.red)
                .cornerRadius(8)
                .padding()
                Spacer()
                Text("These values are approximations of potential cost and time for a job with the details you entered. For more information, registered users can complete the Detailed Survey.")
                    .italic()
                    .foregroundColor(Color.gray)
                    .padding()
                Spacer()
                Button(action: {
                    debugPrint("BUTTONHERE")
                    jobService.insertJob(1, customerID, (totalWeightOrigDetail + totalWeightDestDetail), 500, 90, address1Detail, address2Detail, address3Detail, address1DetailDest, address2DetailDest, address3DetailDest, sqft, sqftDest, floorDetail, floorDetailDest)
                }) {
                    Text("Book this Job")
                        .padding()
                        .foregroundColor(Color.white)
                }
                .buttonStyle(PlainButtonStyle())
                .frame(width: 400, height: 80)
                .background(Color.blue)
                .cornerRadius(8)
                
            }
        }
        .navigationTitle("Estimates")
        .onAppear(perform: { getTime(sqft, sqftDest, distance) })
    }
}

struct DetailedEstimates_Previews: PreviewProvider {
    static var previews: some View {
        DetailedEstimates()
    }
}
