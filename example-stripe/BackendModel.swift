//
//  BackendModel.swift
//  example-stripe
//
//  Created by Thomas Mello on 10/20/21.
//

import Foundation
import Stripe

class BackendModel: ObservableObject {
    @Published var paymentStatus: STPPaymentHandlerActionStatus?
    @Published var paymentIntentParams: STPPaymentIntentParams?
    @Published var lastPaymentError: NSError?
    var spId: String?
    var vendorId: String?
    var amount: String?
    var currency: String?
    var clientSecret: String?
    
    func preparePaymentIntent(spId: String, vendorId: String, amount: String, currency: String) {
        self.spId = spId
        self.vendorId = vendorId
        self.amount = amount
        self.currency = currency
        
        // MARK: POSTMAN STYLE
        let semaphore = DispatchSemaphore (value: 0)

        let parameters = "{\n\"spId\": \"\(spId)\",\n\"vendorId\": \"\(vendorId)\",\n\"amount\": \"\(amount)\",\n\"currency\": \"\(currency)\"\n}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "http://localhost:8081/resource/supplies-vendor-gateway/pay?r_username=api_test&r_accesskey=NEhR2ugM")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200 else {
                print(String(describing: error))
                semaphore.signal()
                return
            }
            guard let data = data else {
                print(String(describing: error))
                semaphore.signal()
                return
            }
            print(String(data: data, encoding: .utf8)!)
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
            if json?["clientSecret"] as? String == nil {
                print("Could not get client secret.")
                semaphore.signal()
                return
            }
            self.clientSecret = json?["clientSecret"] as? String
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
        print("Created PaymentIntent")
        
        // MARK: Create the PaymentIntent
        DispatchQueue.main.async {
            self.paymentIntentParams = STPPaymentIntentParams(clientSecret: self.clientSecret ?? "")
        }
        task.resume()
    }

    func onCompletion(status: STPPaymentHandlerActionStatus, pi: STPPaymentIntent?, error: NSError?) {
        self.paymentStatus = status
        self.lastPaymentError = error


        // MARK: Demo cleanup
        if status == .succeeded {
            // A PaymentIntent can't be reused after a successful payment. Prepare a new one for the demo
            self.paymentIntentParams = nil
//            preparePaymentIntent(paymentMethodType: self.paymentMethodType!, currency: self.currency!)
            preparePaymentIntent(spId: self.spId!, vendorId: self.vendorId!, amount: self.amount!, currency: self.currency!)
        }
    }
}
