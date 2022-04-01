//
//  PreliminaryEstimates.swift
//  MMS
//
//  Created by Daniel Metrejean on 3/30/22.
//

import SwiftUI

struct PreliminaryEstimates: View {
    
    @AppStorage("email") var emailLoggedIn: String = ""
    @AppStorage("password") var passwordLoggedIn: String = ""
    @AppStorage("customerID") var customerID: Int = 0
    @AppStorage("loggedIn") var loggedIn: Bool = false
    
    @State var sqft: Int = 0
    @State var sqftDest: Int = 0
    @State var distance: Double = 0
    
    @State var hoursLow: Int = 0
    @State var minutesLow: Int = 0
    @State var hoursHigh: Int = 0
    @State var minutesHigh: Int = 0
    
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
            }
        }
        .navigationTitle("Free Estimates")
        .onAppear(perform: { getTime(sqft, sqftDest, distance) })
    }
}

public func getTime(_ sqft: Int, _ sqftDest: Int, _ distance: Double) -> Void {
    
    let lower = (((Double(sqft+sqftDest)*0.22) + (distance/1000)) / 60)
    debugPrint(lower)
    
}

struct PreliminaryEstimates_Previews: PreviewProvider {
    static var previews: some View {
        PreliminaryEstimates()
    }
}
