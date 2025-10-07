//
//  LaunchPageView.swift
//  VisaActivity
//
//  Created by Sakshi on 11/09/25.
//

import SwiftUI
import SUINavigation

struct LaunchPageView: View {
    @State private var navigateToHome = false
    var body: some View {
       
            NavigationStorageView {
                VStack {
                    NavigationLink(
                        destination: ExperienceHomeView(encryptPayLoad: encryptedPayload , isActive: $navigateToHome, onFinish:  {
                            print("Got callback")
                            // can modify this action as per requirement -
                        }
                            ) ,
                        isActive: $navigateToHome
                    )
                    
                    {
                        Text("HomePage")
                            .font(.title2)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .navigationTitle("Launch Page")
            }
        }
}
