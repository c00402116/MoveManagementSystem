//
//  PostCustomersSQLExample.swift
//  MMS
//
//  Created by Dylan Johnson on 2/10/22.
//

import SwiftUI
import Combine

class InsertCustomerService: ObservableObject {
    @Published var errorMessage: String = ""
    @Published var customers: [Customer] = []
    private var cancellableSet: Set<AnyCancellable> = []
    
    func getCustomers(_ phone: String, _ email: String, _ password: String) -> Int {
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
}

struct PostCustomersSQLExample: View {
    @ObservedObject var customerService = InsertCustomerService()
    @State var phone: String = ""
    @State var email: String = ""
    @State var password: String = ""
    var body: some View {
        VStack {
            TextField("Phone#", text: $phone)
            TextField("Email", text: $email)
            TextField("password", text: $password)
            Spacer()
            Button {customerService.getCustomers(phone,email,password)} label: {
                Text("Insert this customer into database")
            }
            Text(customerService.errorMessage)
                .font(.largeTitle)
        }
        
        List {
            Text("Input: \(phone), \(email), \(password)")
            ForEach(customerService.customers) { person in
                Text("\(person.id), \(person.phone), \(person.email), \(person.password)")
            }
        }
    }
}

struct PostCustomersSQLExample_Previews: PreviewProvider {
    static var previews: some View {
        PostCustomersSQLExample()
    }
}
