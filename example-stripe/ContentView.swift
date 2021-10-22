//
//  ContentView.swift
//  example-stripe
//
//  Created by Thomas Mello on 10/19/21.
//

import SwiftUI

struct ContentView: View {
    @State var isShowingApplePayView: Bool = false
    
    var body: some View {
        if isShowingApplePayView {
            ApplePay()
        } else {
            Button("GO TO STRIPE TEST") {
                isShowingApplePayView = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
