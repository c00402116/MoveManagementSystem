//
//  TimeVariables.swift
//  MMS
//
//  Created by Dylan Johnson on 3/17/22.
//

import SwiftUI


struct TimeVariables: View {
    @AppStorage("email") var emailLoggedIn: String = ""
    @AppStorage("password") var passwordLoggedIn: String = ""
    @AppStorage("loggedIn") var loggedIn: Bool = false
    @AppStorage("admin") var adminLoggedIn: Bool = false
    
    @State var currentID: Int = 0
    @State var distance: String = ""
    @State var siteSurvey: String = ""
    @State var assembly_disassembly : String = ""
    @State var packing : String = ""
    @State var unpacking: String = ""
    @State var jobReview: String = ""
    @State var pressed: Int = 0
    
    @ObservedObject var adminService = AdminService()
    var body: some View {
        VStack { // will probably do a vstack with hstacks to display all future cost vars
            Button {adminService.checkLogin(emailLoggedIn)} label: {
                Text("Get current default time variables.")
            }
            Spacer()
            Text("User: \(emailLoggedIn)")
            
            List {
                
                ForEach(adminService.admins){admin in
                Text("Distance(minutes): \(admin.minLaborHours)")
                Text("Site Survey(mins/location): \(admin.travelPerMile)")
                Text("Assembly/Disassembly(mins/item): \(admin.businessRate)")
                Text("Packing Time: \(admin.employeeTrueCost)")
                Text("Unpacking Time: \(admin.employeeTrueCost)")
                Text("Quality Assurance(mins/location): \(admin.assembly_disassembly)")
                }
                
            }
        }
        
        Text("Edit time variables here.")
        VStack {
            TextField("Distance(minutes): ", text: $distance)
            TextField("Site Survey(mins/location): ", text: $siteSurvey)
            TextField("Assembly/Disassembly(mins/item): ", text: $assembly_disassembly)
            TextField("Packing Time: ", text: $packing)
            TextField("Unpacking Time: ", text: $unpacking)
            TextField("Quality Assurance(mins/location): ", text: $jobReview)
        }
        Spacer()
        Button(action: {
            getID(emailLoggedIn)
            pressed = confirmChanges(distance, siteSurvey, assembly_disassembly, packing, jobReview, currentID)
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
    
    func confirmChanges(_ distance: String, _ siteSurvey: String, _ assembly_disassembly: String, _ packing: String, _ jobReview: String, _ id: Int) -> Int {
        let int1 = Int(distance)
        let int2 = Int(siteSurvey)
        let int3 = Int(assembly_disassembly)  // you will need to do error checking for the user to enter an int or this will break
        //print(int3!)
        let int4 = Int(packing)
        //let int5 = Int(packing)
        let int6 = Int(jobReview)
        let result = adminService.changeCostVars(int1!, int2!, int3!, int4!, int6!, id)
        
        return result
    }
}

struct TimeVariables_Previews: PreviewProvider {
    static var previews: some View {
        TimeVariables()
    }
}
