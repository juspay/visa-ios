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
                            .foregroundColor(selected == tab ? Color(hex: Constants.HexColors.primary) : .black)
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
    @StateObject private var bookingViewModel = ExperienceBookingConfirmationViewModel()
    @ObservedObject var homeViewModel: HomeViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTransaction: Booking? = nil
    @State private var cancelledBooking: Booking? = nil
    @OptionalEnvironmentObject private var navigationStorage: NavigationStorage?
    
    var body: some View {
        NavigationStorageView {
            ThemeTemplateView(needsScroll: false,
                              header: {
                VStack {
                    HStack(spacing: 10) {
                        if let vectorImage = ImageLoader.bundleImage(named: Constants.Icons.vector) {
                            vectorImage
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                        }

                        Text(Constants.TransactionRowConstants.myTransactionsTitle)
                            .bold()
                            .foregroundColor(.white)
                            .font(.custom("Lexend-Bold", size: 16))
                        
                        Spacer()
                    }
                    .padding(.top, 8)
                }
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
                                noTransactionView
                            } else {
                                ForEach(viewModel.bookings) { item in
                                    Button(action: {
//                                        if item.status == .cancelled {
//                                            cancelledBooking = item
//                                        } else {
                                            selectedTransaction = item
//                                        }
                                    }) {
                                        TransactionRow(item: item)
                                    }
                                    .onAppear {
                                        // Load more when the last item appears
                                        if item.id == viewModel.bookings.last?.id {
                                            viewModel.loadMoreBookings()
                                        }
                                    }
                                }
                            }
                            
                            if viewModel.isLoading {
                                LoaderView(text: "Loading bookings...")
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                    NavigationLink(
                        destination: Group {
                            if let transaction = selectedTransaction {
                                let participantText = transaction.travellerText
                                let time = transaction.time
                                if let nav = navigationStorage {
                                    ExperienceBookingConfirmationView(orderNo: transaction.orderNo, isFromBookingJourney: false,
                                                                      booking: transaction,
                                                                      participantsSummary: participantText,
                                                                      selectedTime: time)
                                    .environmentObject(nav)
                                } else {
                                    ExperienceBookingConfirmationView(orderNo: transaction.orderNo, isFromBookingJourney: false,
                                                                      booking: transaction,
                                                                      participantsSummary: participantText,
                                                                      selectedTime: time)
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
        .navigationBarHidden(true)
    }

    private var noTransactionView: some View {
        VStack {
            if let noResultImage = ImageLoader.bundleImage(named: Constants.Icons.noTransactionResult) {
                noResultImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 123, height: 123)
                    .padding(.top, 40)
            }

            Text(String(format: Constants.TransactionRowConstants.noTransactionResult, viewModel.selectedTab.rawValue.lowercased()))
                .font(.custom(Constants.Font.openSansSemiBold, size: 14))
                .foregroundColor(.primary)
                .padding(.top, 16)
            
            Button {
                homeViewModel.showMenu = false
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text(String(format: Constants.TransactionRowConstants.bookExperience, viewModel.selectedTab.rawValue.lowercased()))
                    .font(.custom(Constants.Font.openSansBold, size: 12))
                    .foregroundColor(Color.white)
                    .padding()
                    .background(Color(hex: Constants.HexColors.primary))
                    .cornerRadius(4)
            }
            .padding(.top, 60)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}
