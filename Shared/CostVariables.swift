
//  CostVariables.swift
//  MMS
//
//  Created by Dylan Johnson on 3/10/22.
//

import SwiftUI

struct CostVariables: View {
    @AppStorage("email") var emailLoggedIn: String = ""
    @AppStorage("password") var passwordLoggedIn: String = ""
    @AppStorage("loggedIn") var loggedIn: Bool = false
    @AppStorage("admin") var adminLoggedIn: Bool = false
    
    //@State var costVariable : String = ""  // going to have to expand these variables in data and allow admin user
    //@State var timeVariable : String = ""  // to change each one of these ( cost will be travel, stairs>50ft, etc... )
    //@State var minHours : String = ""
    //@State var minTime : String = ""
    @State var currentID : Int = 0
    //default cost variables
    @State var minLaborHours: String = ""
    @State var travelPerMile: String = ""
    @State var businessRate: String = ""
    @State var employeeTrueCost: String = ""
    @State var assembly_disassembly : String = ""
    @State var pressed: Int = 0
    
    @ObservedObject var adminService = AdminService()
    var body: some View {
        VStack { // will probably do a vstack with hstacks to display all future cost vars
            Button {adminService.checkLogin(emailLoggedIn)} label: {
                Text("Get current default cost variables.")
            }
            Spacer()
            Text("User: \(emailLoggedIn)")
            
            List {
                
                ForEach(adminService.admins){admin in
                Text("Minimum Labor Hours: \(admin.minLaborHours)")
                Text("Travel Per Mile: \(admin.travelPerMile)")
                Text("Business Rate (hr): \(admin.businessRate)")
                Text("Employee True Cost(n): \(admin.employeeTrueCost)")
                Text("Assembly/Disassembly(item): \(admin.assembly_disassembly)")
                }
                
            }
        }
        
        Text("Edit cost variables here.")
        
        VStack {
            TextField("Minimum Labor Hours", text: $minLaborHours) //error checking to make the user enter a number
            TextField("Travel Per Mile", text: $travelPerMile)
            TextField("Hourly Business Rate", text: $businessRate) // error checking for empty entries
            TextField("Employee True Cost", text: $employeeTrueCost)
            TextField("Assembly/Disassembly per item", text: $assembly_disassembly)
        }
        Spacer()
        Button(action: {
            getID(emailLoggedIn)
            pressed = confirmChanges(minLaborHours, travelPerMile, businessRate, employeeTrueCost, assembly_disassembly, currentID) //  add a message to user to display changes
        }) {
            Text("Confirm changes.")
        }
        if(pressed == 1) {
            Text("Changes made")
                .foregroundColor(Color.green)
        }
        if(pressed == 2) {
            Text("Changes failed")
                .foregroundColor(Color.red)
        }
        
    }
    
    func getID(_ email: String) {
        for admin in adminService.admins {
            if(emailLoggedIn == admin.email) {
                currentID = admin.id
            }
        }
    }
    
    func confirmChanges(_ minLaborHours: String, _ travelPerMile: String, _ businessRate: String, _ employeeTrueCost: String, _ assembly_disassembly: String, _ id: Int) -> Int {
        let int1 = Int(minLaborHours)
        let int2 = Int(travelPerMile)
        let int3 = Int(businessRate)  // you will need to do error checking for the user to enter an int or this will break
        //print(int3!)
        let int4 = Int(employeeTrueCost)
        let int5 = Int(assembly_disassembly)
        let result = adminService.changeCostVars(int1!, int2!, int3!, int4!, int5!, id)
        
        return result
    }
}

struct CostVariables_Previews: PreviewProvider {
    static var previews: some View {
        CostVariables()
    }
}
