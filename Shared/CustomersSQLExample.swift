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
    var minLaborHours: Int!
    var travelPerMile: Int!
    var businessRate: Int!
    var employeeTrueCost: Int!
    var assembly_disassembly: Int!
    
    enum CodingKeys: String,CodingKey {
        case id = "adminID"
        case name = "name"
        case address = "address"
        case email = "email"
        case password = "password"
        case minLaborHours = "minLaborHours"
        case travelPerMile = "travelPerMile"
        case businessRate = "businessRate"
        case employeeTrueCost = "employeeTrueCost"
        case assembly_disassembly = "assembly_disassembly"
    }
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
    
    enum CodingKeys: String,CodingKey {
        case id = "furnitureID"
        case name = "name"
        case weight = "weight"
        
    }
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
    
    func changeCostVars(_ minLaborHours: Int, _ travelPerMile: Int, _ businessRate: Int,_ employeeTrueCost: Int, _ assembly_disassembly: Int, _ id: Int) -> Int {
        let urlstring = "http://frankcmps490sp22.cmix.louisiana.edu/updateCostVars.php?adminID=\(id)"
        let url = URL(string: urlstring)!
        //print(businessRate)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "Post"
        let postString = "minLaborHours=\(minLaborHours) & businessRate=\(businessRate) & travelPerMile=\(travelPerMile) & employeeTrueCost=\(employeeTrueCost) & assembly_disassembly=\(assembly_disassembly)"
        urlRequest.httpBody = postString.data(using: String.Encoding.utf8)
        
        URLSession.shared
            .dataTaskPublisher(for: urlRequest)
            .map(\.data)
            .decode(type: [Admin].self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .sink {completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print(error)
                }
            } receiveValue: {
                self.admins.removeAll()
                self.admins = $0
            }.store(in: &cancellableSet)
        if (errorMessage == "") {
            return 1
        } else {
            return 2
        }
        
    }
    
    func calculateAmtOfEmployees(_ totalWeight: Int) -> Int {
        if(totalWeight <= 3599) {
            return 2
        } else if(totalWeight > 3599 && totalWeight <= 5199) {
            return 3
        } else if(totalWeight > 5199 && totalWeight <= 9999) {
            return 4
        } else if(totalWeight > 9999 && totalWeight <= 13999) {
            return 5
        } else {
            return 6
        }
    }
    
    func calculateLoadingTime(_ weightForLocation: Int, _ numOfEmplpyeesRequired: Int) -> Int {
        return ((weightForLocation / numOfEmplpyeesRequired) / 600)
    }
    
    func calculateUnloadingTime(_ weightForLocation: Int, _ numOfEmplpyeesRequired: Int) -> Int {
        return ((weightForLocation / numOfEmplpyeesRequired) / 720)
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
    var costEstimate: Int!
    var timeEstimate: Int!
    var address1orig: String!
    var address2orig: String!
    var address3orig: String!
    var address1dest: String!
    var address2dest: String!
    var address3dest: String!
    var sqftOrig: Int!
    var sqftDest: Int!
    var floorsOrig: Int!
    var floorsDest: Int!
    
    enum CodingKeys: String, CodingKey {
        case id = "jobID"
        case adminID = "adminID"
        case customerID = "customerID"
        case totalWeight = "totalWeight"
        case costEstimate = "costEstimate"
        case timeEstimate = "timeEstimate"
        case address1orig = "address1orig"
        case address2orig = "address2orig"
        case address3orig = "address3orig"
        case address1dest = "address1dest"
        case address2dest = "address2dest"
        case address3dest = "address3dest"
        case sqftOrig = "sqftOrig"
        case sqftDest = "sqftDest"
        case floorsOrig = "floorsOrig"
        case floorsDest = "floorsDest"
    }
}

class JobService: ObservableObject {
    @Published var errorMessage: String = ""
    @Published var jobs: [Job] = []
    private var cancellableSet: Set<AnyCancellable> = []
    
    func insertJob(_ adminID: Int, _ customerID: Int, _ totalWeight: Int, _ costEstimate: Int, _ timeEstimate: Int, _ address1orig: String, _ address2orig: String, _ address3orig: String, _ address1dest: String, _ address2dest: String, _ address3dest: String, _ sqftOrig: Int, _ sqftDest: Int, _ floorsOrig: Int, _ floorsDest: Int) -> Void {
        
        debugPrint("HEEREEE")
        
        let urlstring = "http://frankcmps490sp22.cmix.louisiana.edu/newJob.php"
        let url = URL(string: urlstring)!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "Post"
        let postString = "adminID=\(adminID) & customerID=\(customerID) & totalWeight=\(totalWeight) & costEstimate=\(costEstimate) & timeEstimate=\(timeEstimate) & address1orig=\(address1orig) & address2orig=\(address2orig) & address3orig=\(address3orig) & address1dest=\(address1dest) & address2dest=\(address2dest) & address3dest=\(address3dest) & sqftOrig=\(sqftOrig) & sqftDest=\(sqftDest) & floorsDest=\(floorsDest) & floorsOrig=\(floorsOrig)"
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
                    print(error)
                    //debugPrint("insertion failed")
                }
            } receiveValue: {
                self.jobs.removeAll()
                self.jobs = $0
            }.store(in: &cancellableSet)
        if (errorMessage != "") {
            debugPrint(errorMessage)
        }
        debugPrint("we made it through")
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
