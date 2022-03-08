//
//  PreliminarySurvey.swift
//  MMS
//
//  Created by Daniel Metrejean on 2/3/22.
//

import SwiftUI

struct PreliminarySurvey: View {
    
    @ObservedObject var jobService = JobService()
    @State var addJobSuccess: Int = 0
    
    @State var origAddrDisabled: Bool = true
    @State var showOrigItems: Bool = false;
    
    @State var originAddr: String = ""
    @State var originType: Int = 0
    @State var originFloor: Int = 0
    
    //these are just default values used for testing my insert php script.
    @State var adminID: Int = 1;
    @State var customerID: Int = 1;
    @State var totalWeight: Int = 400;
    @State var squareFeet: Int = 1000;
    @State var costEstimate: Int = 1200;
    @State var timeEstimate: Int = 4;
    
    var body: some View {
        ScrollView {
            VStack {
                Section {
                    VStack {
                        HStack {
                            Text("**Origin**")
                                .font(.system(size: 24))
                                .foregroundColor(Color.white)
                            Spacer()
                        }
                        HStack {
                            Text("Address")
                                .foregroundColor(Color.white)
                            TextField("", text: $originAddr)
                                .padding()
                                .background(origAddrDisabled ? Color.gray: Color.white)
                                .disabled(origAddrDisabled)
                                .cornerRadius(8)
                        }
                        HStack {
                            Text("Type")
                                .foregroundColor(Color.white)
                            TextField("\(originType)", text: $originAddr)
                                .padding()
                                .background(origAddrDisabled ? Color.gray: Color.white)
                                .disabled(origAddrDisabled)
                                .cornerRadius(8)
                        }
                        HStack {
                            Text("Floor")
                                .foregroundColor(Color.white)
                            TextField("\(originFloor)", text: $originAddr)
                                .padding()
                                .background(origAddrDisabled ? Color.gray: Color.white)
                                .disabled(origAddrDisabled)
                                .cornerRadius(8)
                        }
                        HStack {
                            Text("Itemized List")
                                .foregroundColor(Color.white)
                            Spacer()
                            //NavigationLink(destination: editPrelim(originAddr: originAddr, originType: originType, originFloor: originFloor)) {
                            //   Text("Edit")
                            //       .foregroundColor(Color.white)
                        }
                    }
                }
            }
            .padding()
            .background(Color.green)
            .cornerRadius(8)
            Spacer()
            
            Button { addJob(adminID, customerID, totalWeight, squareFeet, costEstimate, timeEstimate) } label: {
                Text("Add Test Job")
                    .padding()
                    .foregroundColor(Color.white)
            }
            .background(Color.blue)
            .buttonStyle(PlainButtonStyle())
            .cornerRadius(8)
            //.frame(width: 300) this doesn't seem to do anything thanks swiftUI.
            .padding()
            
            if (addJobSuccess == 1) {
                Text("Inserted Successfully")
            }
        }
    }
    
    public func addJob(_ adminID: Int, _ customerID: Int, _ totalWeight: Int, _ squareFeet: Int, _ costEstimate: Int, _ timeEstimate: Int) {
        addJobSuccess = jobService.insertJob(adminID,customerID,totalWeight,squareFeet, costEstimate,timeEstimate)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {

            //debugPrint(jobService.errorMessage)
        }
    }
}

struct PreliminarySurvey_Previews: PreviewProvider {
    static var previews: some View {
        PreliminarySurvey()
    }
}
