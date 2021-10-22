//
//  example_stripeApp.swift
//  example-stripe
//
//  Created by Thomas Mello on 10/19/21.
//

import SwiftUI
import Stripe

let BackendUrl = "http://localhost:8081/resource/supplies-vendor-gateway/pay?r_username=api_test&r_accesskey=NEhR2ugM"

@main
struct example_stripeApp: App {
    init() {
//        let url = URL(string: BackendUrl + "config")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
//            guard let response = response as? HTTPURLResponse,
//                  response.statusCode == 200,
//                  let data = data,
//                  let json = try? JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any],
//                  let publishableKey = json["publishableKey"] as? String else {
//                      print("Failed to retrieve publishable key from server")
//                      return
//                  }
//            print("Fetched the publishable key \(publishableKey)")
//            StripeAPI.defaultPublishableKey = publishableKey
//        })
//        task.resume()
        StripeAPI.defaultPublishableKey = "pk_test_51JjSejHWDt83v9GEfoKJk24PbWJYJJyPgQ8wTyRuwoJaVFslHw0ac5clBXt3s0irUb7V2owsyGHnBzarHfipB85L004sidtOoa"
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
