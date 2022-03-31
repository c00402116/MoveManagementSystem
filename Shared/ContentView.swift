//
//  ContentView.swift
//  Shared
//
//  Created by Daniel Metrejean on 2/3/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @AppStorage("email") var emailLoggedIn: String = ""
    @AppStorage("password") var passwordLoggedIn: String = ""
    @AppStorage("customerID") var customerID: Int = 0
    @AppStorage("loggedIn") var loggedIn: Bool = false
    @AppStorage("admin") var adminLoggedIn: Bool = false
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    var body: some View {
        
        NavigationView {
            VStack {
                NavigationLink(destination: PreliminarySurvey(emailLoggedIn: emailLoggedIn, passwordLoggedIn: passwordLoggedIn, customerID: customerID, loggedIn: loggedIn, address1: "", address2: "", address3: "", type: 0, floor: 1)) {
                    Button(action: {}) {
                        Text("Begin Free Preliminary Survey")
                            .padding()
                            .foregroundColor(Color.white)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(width: 400, height: 80)
                    .background(Color.green)
                    .cornerRadius(8)
                }
                
                NavigationLink(destination: DetailedSurvey()) {
                    Button(action: {}) {
                        Text("Begin Free Detailed Survey")
                            .padding()
                            .foregroundColor(Color.white)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(width: 400, height: 80)
                    .background(loggedIn ? Color.blue : Color.gray)
                    .cornerRadius(8)
                }
                .disabled(loggedIn == false)
                
                if (!loggedIn) {
                    VStack {
                        Text("User account required for detailed survey. Already have an account?")
                            .padding()
                            .foregroundColor(Color.gray)
                        NavigationLink(destination: LoginRegister()) {
                            Text("Log In")
                        }
                    }
                } else if (loggedIn) {
                    Spacer()
                    Text("Welcome <username associated with \(emailLoggedIn)>")
                        .padding()
                }
                if (adminLoggedIn) {
                    Spacer()
                    Text("Admin Mode")
                        .foregroundColor(Color.red)
                    NavigationLink(destination: CostVariables()) {
                        Button(action: {}) {
                            Text("Cost Variables")
                                .padding()
                                .foregroundColor(Color.white)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .frame(width: 400, height: 80)
                        .background(Color.green)
                        .cornerRadius(8)
                    }
                    NavigationLink(destination: TimeVariables()) {
                        Button(action: {}) {
                            Text("Time Variables")
                                .padding()
                                .foregroundColor(Color.white)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .frame(width: 400, height: 80)
                        .background(Color.blue)
                        .cornerRadius(8)
                    }
                }
                
                Spacer()
            

                HStack {
                    Text("Need help? Try visiting our")
                        .foregroundColor(Color.gray)
                    Link("FAQ", destination: URL(string: "https://www.apple.com")!)
                    //Button("FAQ") {}
                    Text("or")
                        .foregroundColor(Color.gray)
                    Link("Contact Us", destination: URL(string: "https://www.apple.com")!)
                    //Button("Contact Us") {}
                }
            }
        }
        .navigationBarTitle(Text("Move Management System"))
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
