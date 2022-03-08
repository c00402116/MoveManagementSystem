//
//  adminLogIn.swift
//  MMS
//
//  Created by Daniel Metrejean on 2/25/22.
//

import SwiftUI

struct adminLogIn: View {
    
    @AppStorage("email") var emailLoggedIn: String = ""
    @AppStorage("password") var passwordLoggedIn: String = ""
    @AppStorage("loggedIn") var loggedIn: Bool = false
    @AppStorage("admin") var adminLoggedIn: Bool = false
    
    @ObservedObject var adminService = AdminService()
    
    @State var email: String = ""
    @State var password: String = ""
    
    @State var valid: Int = 0
    
    var body: some View {
        
        HStack {
            Text("Email")
                .padding()
                .frame(width:140, alignment: .leading)
            TextField("email", text: $email)
                .padding()
                .disableAutocorrection(true)
                .autocapitalization(UITextAutocapitalizationType.none)
        }
        HStack {
            Text("Password")
                .padding()
                .frame(width:140, alignment: .leading)
            TextField("password", text: $password)
                .padding()
                .disableAutocorrection(true)
                .autocapitalization(UITextAutocapitalizationType.none)
        }
        Spacer()
        Button { checkLogin(email) } label: {
            Text("Log In")
                .padding()
                .foregroundColor(Color.white)
        }
        .background(Color.blue)
        .buttonStyle(PlainButtonStyle())
        .cornerRadius(8)
        //.frame(width: 300) this doesn't seem to do anything thanks swiftUI.
        .padding()
    }
    
    private func checkLogin(_ email: String) {
        
        adminService.checkLogin(email)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
            debugPrint(adminService.errorMessage)
            //debugPrint(customerService.customers[0].email!)
            //debugPrint(customerService.customers[0].password!)
            
            if (adminService.admins.count > 0) {
                //for pwd in customerService.customers {
                if (password == adminService.admins[0].password) {
                    valid = 1
                } else {
                    valid = 2
                }
                //}
            } else { valid = 2 }
            if (valid == 1) {
                emailLoggedIn = adminService.admins[0].email
                passwordLoggedIn = adminService.admins[0].password
                loggedIn = true
                adminLoggedIn = true
                NavigationLink("contentView", destination: ContentView(emailLoggedIn: emailLoggedIn, passwordLoggedIn: passwordLoggedIn, loggedIn: loggedIn, adminLoggedIn: adminLoggedIn))
            }
        }
    }
}

struct adminLogIn_Previews: PreviewProvider {
    static var previews: some View {
        adminLogIn()
    }
}
