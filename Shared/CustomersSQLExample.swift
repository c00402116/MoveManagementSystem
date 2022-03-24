//
//  CustomersSQLExample.swift
//  MMS
//
//  Created by Daniel Metrejean on 2/5/22.
//

import SwiftUI
import Combine

struct Customer: Decodable, Identifiable {
    var id: Int
    var phone: String!
    var email: String!
    var password: String!
}

struct Admin: Decodable, Identifiable {
    var id: Int
    var name: String!
    var address: String!
    var email: String!
    var password: String!
    var costVar: Int!
    var timeVar: Int!
    var minHrs: Int!
    var minTimes: Int!
    var standardRates: Int!
}
struct Stop: Decodable, Identifiable {
    var id: Int //jobID in the database
    var which: Int!
    var line1: String!
    var line2: String!
    var line3: String!
    var type: Int!
    var floor: Int!
}

struct Furniture: Decodable, Identifiable {
    var id: Int
    var name: String!
    var weight: Int!
    
    
}

class CustomerService: ObservableObject {
    @Published var errorMessage: String = ""
    @Published var customers: [Customer] = []
    private var cancellableSet: Set<AnyCancellable> = []
    
    func downloadCustomers() {
        let urlstring = "http://frankcmps490sp22.cmix.louisiana.edu/Customers2.php"
        let url = URL(string: urlstring)!
        
        URLSession.shared
            .dataTaskPublisher(for: URLRequest(url: url))
            .map(\.data)
            .decode(type: [Customer].self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print(error)
                }
            } receiveValue: {
                self.customers.removeAll()
                self.customers = $0
            }.store(in: &cancellableSet)
    }
    
    func checkLogin(_ email: String) {
        let urlstring = "http://frankcmps490sp22.cmix.louisiana.edu/login.php?email=\(email)"
        let url = URL(string: urlstring)!
        //var returnVal: String = ""
        
        URLSession.shared
            .dataTaskPublisher(for: URLRequest(url: url))
            .map(\.data)
            .decode(type: [Customer].self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: {
                self.customers.removeAll()
                self.customers = $0
                //returnVal = self.customers[0].password ?? ""
            }.store(in: &cancellableSet)
        //return returnVal
    }
    
    func registerCustomer(_ phone: String, _ email: String, _ password: String) -> Int {
        let urlstring = "http://frankcmps490sp22.cmix.louisiana.edu/insertCustomer.php"
        let url = URL(string: urlstring)!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "Post"
        let postString = "phone=\(phone) & email=\(email) & password=\(password)"
        urlRequest.httpBody = postString.data(using: String.Encoding.utf8)
        
        URLSession.shared
            .dataTaskPublisher(for: urlRequest)
            .map(\.data)
            .decode(type: [Customer].self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .sink {completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: {
                self.customers.removeAll()
                self.customers = $0
            }.store(in: &cancellableSet)
        if (errorMessage == "") {
            return 1
        } else {
            return 2
        }
    }
    
    func getID(_ email: String) -> Int {
        let urlstring = "http://frankcmps490sp22.cmix.louisiana.edu/login.php"
        let url = URL(string: urlstring)!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        let postString = "email=\(email)"
        urlRequest.httpBody = postString.data(using: String.Encoding.utf8)
        
        URLSession.shared
            .dataTaskPublisher(for: urlRequest)
            .map(\.data)
            .decode(type: [Customer].self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .sink {completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: {
                self.customers.removeAll()
                self.customers = $0
            }.store(in: &cancellableSet)
        if (errorMessage != "" && customers.count > 0) {
            return customers[0].id
        }
        return 0
    }
}

class AdminService: ObservableObject {
    @Published var errorMessage: String = ""
    @Published var admins: [Admin] = []
    private var cancellableSet: Set<AnyCancellable> = []
    
    func checkLogin(_ email: String) {
        let urlstring = "http://frankcmps490sp22.cmix.louisiana.edu/adminLogIn.php?email=\(email)"
        let url = URL(string: urlstring)!
        //var returnVal: String = ""
        
        URLSession.shared
            .dataTaskPublisher(for: URLRequest(url: url))
            .map(\.data)
            .decode(type: [Admin].self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: {
                self.admins.removeAll()
                self.admins = $0
                //returnVal = self.customers[0].password ?? ""
            }.store(in: &cancellableSet)
        //return returnVal
    }
}

class StopsService: ObservableObject {
    @Published var errorMessage: String = ""
    @Published var stops: [Stop] = []
    private var cancellableSet: Set<AnyCancellable> = []
    
    func insertStop(_ jobID: Int, _ which: Int, _ line1: String, _ line2: String, _ line3: String, _ type: Int, _ floor: Int) -> Int {
        let urlstring = "http://frankcmps490sp22.cmix.louisiana.edu/insertJob.php"
        let url = URL(string: urlstring)!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "Post"
        let postString = "jobID=\(jobID) & which=\(which) & line1=\(line1) & line2=\(line2) & line3=\(line3) & type=\(type) & floor=\(floor)"
        urlRequest.httpBody = postString.data(using: String.Encoding.utf8)
        
        URLSession.shared
            .dataTaskPublisher(for: urlRequest)
            .map(\.data)
            .decode(type: [Stop].self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .sink {completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: {
                self.stops.removeAll()
                self.stops = $0
            }.store(in: &cancellableSet)
        if (errorMessage == "") {
            return 1
        } else {
            return 2
        }
    }
}

class FurnitureService: ObservableObject {
    @Published var errorMessage: String = ""
    @Published var furniture: [Furniture] = []
    private var cancellableSet: Set<AnyCancellable> = []
    
    func downloadFurniture() {
        let urlstring = "http://frankcmps490sp22.cmix.louisiana.edu/getFurniture.php"
        let url = URL(string: urlstring)!
        
        URLSession.shared
            .dataTaskPublisher(for: URLRequest(url: url))
            .map(\.data)
            .decode(type: [Furniture].self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print(error)
                }
            } receiveValue: {
                self.furniture.removeAll()
                self.furniture = $0
            }.store(in: &cancellableSet)
    }
}


struct Job: Decodable, Identifiable {
    var id: Int
    var adminID: Int!
    var customerID: Int!
    var totalWeight: Int!
    var squareFeet: Int!
    var costEstimate: Int!
    var timeEstimate: Int!
}

class JobService: ObservableObject {
    @Published var errorMessage: String = ""
    @Published var jobs: [Job] = []
    private var cancellableSet: Set<AnyCancellable> = []
    
    func insertJob(_ adminID: Int, _ customerID: Int, _ totalWeight: Int, _ squareFeet: Int, _ costEstimate: Int, _ timeEstimate: Int) -> Int {
        let urlstring = "http://frankcmps490sp22.cmix.louisiana.edu/newJob.php"
        let url = URL(string: urlstring)!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "Post"
        let postString = "adminID=\(adminID) & customerID=\(customerID) & totalWeight=\(totalWeight) & squareFeet=\(squareFeet) & costEstimate=\(costEstimate) & timeEstimate=\(timeEstimate)"
        urlRequest.httpBody = postString.data(using: String.Encoding.utf8)
        
        URLSession.shared
            .dataTaskPublisher(for: urlRequest)
            .map(\.data)
            .decode(type: [Job].self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .sink {completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: {
                self.jobs.removeAll()
                self.jobs = $0
            }.store(in: &cancellableSet)
        if (errorMessage == "" && jobs.count > 0) {
            return jobs[0].id
        } else {
            return 0
        }
    }
}

struct CustomersSQLExample: View {
    @ObservedObject var customerService = CustomerService()
    //@State var month: String = ""
    
    var body: some View {
        VStack {
            //TextField("Month:", text: $month)
            Button { customerService.downloadCustomers() } label: {
                Text("Get Customers!")
            }
            Text(customerService.errorMessage)
            //.font(.largeTitle)
                .foregroundColor(Color.gray)
        }
        
        List {
            ForEach(customerService.customers) {cust in
                Text("**\(cust.id)** \(cust.phone) \(cust.email) \(cust.password)")
            }
        }
    }
}

struct CustomersSQLExample_Previews: PreviewProvider {
    static var previews: some View {
        CustomersSQLExample()
    }
}
