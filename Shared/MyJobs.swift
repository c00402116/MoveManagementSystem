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
    
    @AppStorage("email") var emailLoggedIn: String = ""
    @AppStorage("password") var passwordLoggedIn: String = ""
    @AppStorage("customerID") var customerID: Int = 0
    @AppStorage("loggedIn") var loggedIn: Bool = false
    @AppStorage("admin") var adminLoggedIn: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                if (adminLoggedIn) {
                    HStack {
                        Spacer()
                        Image(systemName: "signature")
                        Text("Admin Mode")
                            .foregroundColor(Color.red)
                            .padding()
                    }
                }
                Section {
                    NavigationLink(destination: JobView()) {
                        VStack {
                            HStack {
                                Text("**Job 1**")
                                    .foregroundColor(Color.white)
                                    .padding()
                                    .font(.title)
                                Spacer()
                                Image(systemName: "person.fill")
                                    .foregroundColor(Color.white)
                                Text("Johnson, D.")
                                    .foregroundColor(Color.white)
                                    .italic()
                                    .padding()
                            }
                            HStack {
                                Text("211 Republic Ave")
                                    .foregroundColor(Color.white)
                                    .padding()
                                Spacer()
                                Image(systemName: "arrow.forward")
                                    .foregroundColor(Color.white)
                                Spacer()
                                Text("1223 St. John St")
                                    .foregroundColor(Color.white)
                                    .padding()
                            }
                        }
                        .background(Color.green)
                        .cornerRadius(8)
                        .padding()
                    }
                }.navigationBarTitle("My Booked Jobs")
            }
        }
    }
}

struct AssignEmployee: View {
    
    
    @AppStorage("assigned") var assigned: Bool = false
    @State var employees: [String] = ["Do, Nicolas", "Ducrest, Frank", "Little, Marcus", "Metrejean, Daniel", "Potter, Jonathan", "Trahan, Charles"]
    @State var selected: [Bool] = [false, false, false, false, false, false]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(0..<employees.count) {employee in
                    HStack {
                        Image(systemName: "checkmark")
                            .foregroundColor(selected[employee] ? Color.black : Color.white)
                            .padding()
                        Text("\(employees[employee])")
                            .padding()
                        Spacer()
                    }
                    .onTapGesture {
                        if (selected[employee]) {
                            selected[employee] = false
                        } else {
                            selected[employee] = true
                        }
                        assigned = true
                    }
                }
            }
        }
    }
}

struct JobView: View {
    
    @AppStorage("email") var emailLoggedIn: String = ""
    @AppStorage("password") var passwordLoggedIn: String = ""
    @AppStorage("customerID") var customerID: Int = 0
    @AppStorage("loggedIn") var loggedIn: Bool = false
    @AppStorage("admin") var adminLoggedIn: Bool = false
    
    @AppStorage("totalWeightOrig") var totalWeightOrigDetail : Int = 0
    @AppStorage("totalWeightDest") var totalWeightDestDetail : Int = 0
    @ObservedObject var adminService = AdminService()
    
    @AppStorage("assigned") var assigned: Bool = false
    
    var body: some View {
        
        NavigationView {
            ScrollView {
                Section {
                    VStack {
                        VStack {
                            HStack {
                                Text("**Job 1**")
                                    .foregroundColor(Color.white)
                                    .padding()
                                    .font(.title)
                                Image(systemName: "house")
                                    .resizable()
                                    .foregroundColor(Color.white)
                                    .frame(width: 30, height: 25)
                                Spacer()
                                VStack {
                                    Text("Palmer Moving Services")
                                        .italic()
                                        .foregroundColor(Color.white)
                                    Text("Dylan Johnson")
                                        .italic()
                                        .foregroundColor(Color.white)
                                }
                                .padding()
                            }
                            HStack {
                                Text("**Origin:**")
                                    .foregroundColor(Color.white)
                                    .padding()
                                Spacer()
                                VStack {
                                    Text("211 Republic Avenue")
                                        .foregroundColor(Color.white)
                                    Text("Lafayette, LA 70508")
                                        .foregroundColor(Color.white)
                                }
                                .padding()
                            }
                            HStack {
                                Text("**Destination:**")
                                    .foregroundColor(Color.white)
                                    .padding()
                                Spacer()
                                VStack {
                                    Text("1223 St. John Street")
                                        .foregroundColor(Color.white)
                                    Text("Lafayette, LA 70506")
                                        .foregroundColor(Color.white)
                                }
                                .padding()
                            }
                            HStack {
                                Text("**Total weight:**")
                                    .foregroundColor(Color.white)
                                    .padding()
                                Spacer()
                                Text("\(totalWeightOrigDetail + totalWeightDestDetail)")
                                    .foregroundColor(Color.white)
                                    .padding()
                            }
                            if (adminLoggedIn) {
                                HStack {
                                    Text("**Employees Required: \(adminService.calculateAmtOfEmployees(totalWeightDestDetail + totalWeightOrigDetail))**")
                                        .foregroundColor(Color.white)
                                        .padding()
                                    if (!assigned) {
                                        Image(systemName: "exclamationmark.circle.fill")
                                            .foregroundColor(Color.red)
                                    }
                                    Spacer()
                                    NavigationLink(destination: AssignEmployee()) {
                                        Button(action: {}) {
                                            Text("Assign")
                                                .foregroundColor(Color.blue)
                                        }
                                    }.padding()
                                }
                            }
                            VStack{
                                HStack {
                                    Text("**Cost Estimate:**")
                                        .foregroundColor(Color.white)
                                        .padding()
                                    Spacer()
                                    Text("$770.99")
                                        .foregroundColor(Color.white)
                                        .padding()
                                }
                                HStack {
                                    Text("**Time Estimate:**")
                                        .foregroundColor(Color.white)
                                        .padding()
                                    Spacer()
                                    Text("4:40 - 5:30")
                                        .foregroundColor(Color.white)
                                        .padding()
                                }
                            }
                        }.background(Color.green)
                            .cornerRadius(8)
                            .padding()
                        if (!adminLoggedIn) {
                            NavigationLink(destination: DetailedSurvey()) {
                                Button(action: {}) {
                                    Text("Contact Us")
                                        .padding()
                                        .foregroundColor(Color.white)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .frame(width: 400, height: 80)
                                .background(Color.blue)
                                .cornerRadius(8)
                            }
                        }
                        NavigationLink(destination: DetailedSurvey()) {
                            Button(action: {}) {
                                Text("Cancel Move")
                                    .padding()
                                    .foregroundColor(Color.white)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .frame(width: 400, height: 80)
                            .background(Color.red)
                            .cornerRadius(8)
                        }
                    }
                }
            }
        }.navigationBarTitle("Job Details")
    }
}

struct MyJobs_Previews: PreviewProvider {
    static var previews: some View {
        MyJobs()
    }
}

