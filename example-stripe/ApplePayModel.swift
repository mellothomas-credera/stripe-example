//
//  ApplePayModel.swift
//  example-stripe
//
//  Created by Thomas Mello on 10/20/21.
//

import Foundation
import Stripe
import PassKit

class ApplePayModel: NSObject, ObservableObject, STPApplePayContextDelegate {
    @Published var paymentStatus: STPPaymentStatus?
    @Published var lastPaymentError: Error?
    var clientSecret: String?
    var cost: String?
    
    func pay(clientSecret: String?, cost: String?) {
        self.clientSecret = clientSecret
        self.cost = cost
        // Configure our Apple Pay payment request object
        let pr = StripeAPI.paymentRequest(withMerchantIdentifier: "FILL-LATER", country: "US", currency: "USD")
        
        pr.requiredBillingContactFields = [.postalAddress]
        pr.requiredShippingContactFields = []
        // Configure shipping methods
        pr.shippingMethods = []
        
        // Last array entry must be the total
        pr.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "Regular Banana", amount: NSDecimalNumber(string: cost)),
            PKPaymentSummaryItem(label: "RenoRun", amount: NSDecimalNumber(string: cost))
        ]
        
        // Present the Apple Pay Context:
        let applePayContext = STPApplePayContext(paymentRequest: pr, delegate: self)
        applePayContext?.presentApplePay()
    }
    
    func applePayContext(_ context: STPApplePayContext, didCreatePaymentMethod paymentMethod: STPPaymentMethod, paymentInformation: PKPayment, completion: @escaping STPIntentClientSecretCompletionBlock) {
        // Payment method was created -> confirm our PaymentIntent
        if (self.clientSecret != nil) {
            // Call the completion block with the clientSecret
            completion(clientSecret, nil)
        } else {
            completion(nil, NSError())
        }
    }
    
    func applePayContext(_ context: STPApplePayContext, didCompleteWith status: STPPaymentStatus, error: Error?) {
        // Get the payment status or error
        self.paymentStatus = status
        self.lastPaymentError = error
    }
}
