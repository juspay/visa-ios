//
//  MyTransactionView.swift
//  VisaActivity
//
//  Created by praveen on 04/09/25.
//
import SwiftUI
import SUINavigation


// MARK: - TabsBar
struct TabsBar: View {
    @Binding var selected: TransactionTab
    
    var body: some View {
        HStack {
            ForEach(TransactionTab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.easeInOut(duration: 0.22)) { selected = tab }
                } label: {
                    VStack(spacing: 6) {
                        Text(tab.rawValue)
                            .font(.system(size: 16, weight: selected == tab ? .semibold : .regular))
                            .foregroundColor(selected == tab ? .primary : .secondary)
                            .frame(maxWidth: .infinity)
                        Capsule()
                            .fill(selected == tab ? Color.tabAccent : .clear)
                            .frame(height: 3)
                    }
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.top, 10)
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)
        )
        .padding(.horizontal, 12)
    }
}

// MARK: - MyTransactionView

enum MyTransactionRoute: Hashable {
    case confirmation(orderNo: String)
}

struct MyTransactionView: View {
    @StateObject private var viewModel = TransactionsViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTransaction: Booking? = nil
    @OptionalEnvironmentObject private var navigationStorage: NavigationStorage?

    var body: some View {
        NavigationStorageView {
            ThemeTemplateView(needsScroll: false,
                header: {
                    // Header
                    HStack(spacing: 8) {
                        Image(systemName: "ticket")
                            .foregroundColor(.white)
                        Text("My Transactions")
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .semibold))
                        Spacer()
                    }
                    .padding(.top, 8)
                },
                content: {
                    VStack(spacing: 0) {
                        // Tabs
                        TabsBar(selected: $viewModel.selectedTab)
                            .padding(.top, 8)

                        // List of bookings (ScrollView instead of List)
                        ScrollView {
                            LazyVStack(spacing: 19) {
                                if viewModel.bookings.isEmpty && !viewModel.isLoading {
                                    // Empty state for current tab
                                    VStack(spacing: 16) {
                                        Image(systemName: "doc.text")
                                            .font(.system(size: 50))
                                            .foregroundColor(.gray)
                                        Text("No \(viewModel.selectedTab.rawValue.lowercased()) bookings")
                                            .font(.headline)
                                            .foregroundColor(.secondary)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.top, 50)
                                } else {
                                    ForEach(viewModel.bookings) { item in
                                        Button(action: {
                                            // Only navigate if the booking is not cancelled
                                            if item.status != .cancelled {
                                                selectedTransaction = item
                                            }
                                        }) {
                                            TransactionRow(item: item)
                                        }
                                    }
                                }

                                if viewModel.isLoading {
                                    ProgressView()
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 8)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 8)
                        }

                        // Navigation
                        NavigationLink(
                            destination: Group {
                                if let transaction = selectedTransaction {
                                    if let nav = navigationStorage {
                                        ExperienceBookingConfirmationView(orderNo: transaction.orderNo, isFromBookingJourney: false)
                                            .environmentObject(nav)
                                    } else {
                                        ExperienceBookingConfirmationView(orderNo: transaction.orderNo, isFromBookingJourney: false)
                                    }
                                } else {
                                    EmptyView()
                                }
                            },
                            isActive: Binding(
                                get: { selectedTransaction != nil },
                                set: { if !$0 { selectedTransaction = nil } }
                            ),
                            label: { EmptyView() }
                        )
                        .hidden()
                    }
                }
            )
            .onAppear {
                viewModel.fetchBookings()
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

//struct MyTransactionView: View {
//    @StateObject private var viewModel = TransactionsViewModel()
//    @Environment(\.presentationMode) var presentationMode
//    @State private var selectedTransaction: Booking? = nil
//    @OptionalEnvironmentObject private var navigationStorage: NavigationStorage?
//
//    var body: some View {
//        NavigationStorageView {
//            ThemeTemplateView(needsScroll: false,
//                header: {
//                    //  Wrap inside HStack
//                    HStack(spacing: 8) {
//                        Image(systemName: "ticket")
//                            .foregroundColor(.white)
//                        Text("My Transactions")
//                            .foregroundColor(.white)
//                            .font(.system(size: 20, weight: .semibold))
//                        Spacer()
//                    }
//                    .padding(.top, 8)
//                },
//                content: {
//                    //  Wrap inside VStack
//                    VStack(spacing: 0) {
//                        // Tabs
//                        TabsBar(selected: $viewModel.selectedTab)
//                            .padding(.top, 8)
//
//                        // List of bookings
//                        List {
//                            Section {
//                                ForEach(viewModel.bookings) { item in
//                                    Button(action: {
//                                        selectedTransaction = item
//                                    }) {
//                                        TransactionRow(item: item)
//                                            .padding(.vertical, 4)
//                                    }
//                                    .listRowSeparator(.hidden)
//                                    .listRowBackground(Color.clear)
//                                }
//                            } footer: {
//                                if viewModel.isLoading {
//                                    ProgressView()
//                                        .frame(maxWidth: .infinity)
//                                        .listRowInsets(.init())
//                                }
//                            }
//                        }
//                        .listStyle(.plain)
//                        .background(Color(.systemGroupedBackground))
//                        NavigationLink(
//                            destination: Group {
//                                if let transaction = selectedTransaction {
//                                    if let nav = navigationStorage {
//                                        ExperienceBookingConfirmationView(orderNo: transaction.orderNo)
//                                            .environmentObject(nav) // inject the same NavigationStorage
//                                    } else {
//                                        ExperienceBookingConfirmationView(orderNo: transaction.orderNo)
//                                    }
//                                } else {
//                                    EmptyView()
//                                }
//                            },
//                            isActive: Binding(
//                                get: { selectedTransaction != nil },
//                                set: { if !$0 { selectedTransaction = nil } }
//                            ),
//                            label: { EmptyView() }
//                        )
//                        .hidden()
//                    }
//                }
//            )
//            .onAppear {
//                viewModel.fetchBookings()
//            }
//            .navigationBarBackButtonHidden(true)
//        }
//    }
//}
