//
//  VisaActivityApp.swift
//  VisaActivity
//
//  Created by Apple on 29/07/25.
//

import SwiftUI
import SUINavigation

@main
struct VisaActivityApp: App {
    @StateObject var experienceAvailabilitySelectOptionsViewModel = ExperienceAvailabilitySelectOptionsViewModel()
    var body: some Scene {
        WindowGroup {
            ExperienceHomeView()
            //ExperienceListDetailView()
            //FilterScreenView()
            //SortView()
            //ExperienceDetailView()
            //TravellerPhotosExpandedView()
            //DubaiParksView()
            //TravellerPhotosGridView()
            //AvailabilitySelectionMainView()
            //CustomCalendarView(viewModel: experienceAvailabilitySelectOptionsViewModel)
            //ExperiencePaymentView()
            //ExperienceBookingConfirmationView()
            //BookingCancellationView()
            //BookingPendingScreen()
            //PaymentFailedView()
            //BookingFailedView()
            //ExperienceBookingStatusScreenView()
            //ExperienceCheckoutView()
            //ExperienceExitView()
        }
    }
}

