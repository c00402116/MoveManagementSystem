//
//  LoginRegister.swift
//  MMS
//
//  Created by Daniel Metrejean on 2/11/22.
//

import SwiftUI
import Combine

struct LoginRegister: View {
    
    @AppStorage("email") var emailLoggedIn: String = ""
    @AppStorage("password") var passwordLoggedIn: String = ""
    @AppStorage("customerID") var customerID: Int = 0
    @AppStorage("loggedIn") var loggedIn: Bool = false
    @AppStorage("admin") var adminLoggedIn: Bool = false
    
    @ObservedObject var customerService = CustomerService()
    @ObservedObject var insertThisCustomer = InsertCustomerService()
    
    //This is an integer for tracking the Picker at the top of the View. When = 0 for login, the user is using email[0] and password[0] which is used in a GET query to compare existing database entries. When = 1 for register, the user is in email[1] and password[1] which is used for a POST query to add a new entry.
    @State var loginOrRegister: Int = 0
    
    @State var email: [String] = ["", ""]
    @State var password: [String] = ["", ""]
    @State var phone: [String] = ["", ""]
    @State var name: [String] = ["", ""]
    
    @State var options: [String] = ["Log In", "Register"]
    @State var headers: [String] = ["Log in to an existing account.", "Register for a new account."]
    
    //valid = 2 is fail, valid == 1 is success
    @State public var valid: Int = 0
    
    var body: some View {
        VStack {
            Picker("Options", selection: $loginOrRegister) {
                ForEach(0..<options.count) { option in
                    Text("\(options[option])")
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            if (loginOrRegister==1) {
                HStack {
                    Text("Name")
                        .padding()
                        .frame(width:140, alignment: .leading)
                    TextField("name", text: $name[1])
                        .padding()
                }
            }
            HStack {
                Text("Email")
                    .padding()
                    .frame(width:140, alignment: .leading)
                TextField("email", text: $email[loginOrRegister])
                    .padding()
                    .disableAutocorrection(true)
                    .autocapitalization(UITextAutocapitalizationType.none)
            }
            HStack {
                Text("Password")
                    .padding()
                    .frame(width:140, alignment: .leading)
                SecureField("password", text: $password[loginOrRegister])
                    .padding()
                    .disableAutocorrection(true)
                    .autocapitalization(UITextAutocapitalizationType.none)
            }
            if (loginOrRegister==1) {
                HStack {
                    Text("Phone")
                        .padding()
                        .frame(width:140, alignment: .leading)
                    TextField("password", text: $phone[1])
                        .padding()
                }
            }
            Spacer()
            Text("\(headers[loginOrRegister])")
                .padding()
            //if (valid == 0) {
            //    Text("")
            //} else if (valid == 1) {
            //
            //} else {
            //    Text("Log in failed.")
            //        .padding()
            //        .foregroundColor(Color.red)
            //}
            Spacer()
            if(loginOrRegister==0) {
                Button { checkLogin() } label: {
                    Text("Log In")
                        .padding()
                        .foregroundColor(Color.white)
                }
                .background(Color.blue)
                .buttonStyle(PlainButtonStyle())
                .cornerRadius(8)
                //.frame(width: 300) this doesn't seem to do anything thanks swiftUI.
                .padding()
            } else if(loginOrRegister==1) {
                Button { registerCustomer(phone[1],email[1],password[1]) } label: {
                    Text("Register")
                        .padding()
                        .foregroundColor(Color.white)
                }
                .background(Color.blue)
                .buttonStyle(PlainButtonStyle())
                .cornerRadius(8)
                //.frame(width: 300) this doesn't seem to do anything thanks swiftUI.
                .padding()
                if(valid == 1) {
                    Text("Register successful!")
                        .foregroundColor(.green)
                }
            }
            VStack {
                Text("Are you an administrator? ")
                NavigationLink(destination: adminLogIn()) {
                    Text("Log In Here.")
                        .padding()
                }
            }
            
        }
    }
    //timing issue. App reacts faster than the response from SQL.
    private func checkLogin() {
        
        //let passwordReturn = customerService.checkLogin(email[0])
        
        customerService.checkLogin(email[0])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
            debugPrint(customerService.errorMessage)
            //debugPrint(customerService.customers[0].email!)
            //debugPrint(customerService.customers[0].password!)
            
            if (customerService.customers.count > 0) {
                //for pwd in customerService.customers {
                if (password[0] == customerService.customers[0].password) {
                    valid = 1
                } else {
                    valid = 2
                }
                //}
            } else { valid = 2 }
            if (valid == 1) {
                emailLoggedIn = email[0]
                passwordLoggedIn = customerService.customers[0].password
                customerID = customerService.customers[0].id
                loggedIn = true
                adminLoggedIn = false
                NavigationLink("ContentView", destination: ContentView(emailLoggedIn: emailLoggedIn, passwordLoggedIn: passwordLoggedIn, customerID: customerID, loggedIn: loggedIn, adminLoggedIn: adminLoggedIn))
            }
        }
    }
    private func registerCustomer(_ phone: String, _ email: String, _ password: String) {
        valid = insertThisCustomer.getCustomers(phone,email,password)
        
    }
}

struct LoginRegister_Previews: PreviewProvider {
    static var previews: some View {
        LoginRegister()
    }
}
