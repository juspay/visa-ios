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
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTransaction: Booking? = nil
    @State private var cancelledBooking: Booking? = nil
    @OptionalEnvironmentObject private var navigationStorage: NavigationStorage?
    
    var body: some View {
        NavigationStorageView {
            ThemeTemplateView(needsScroll: false,
                              header: {
                // Header
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
                                    Image(systemName: Constants.TransactionRowConstants.docTextSystemImage)
                                        .font(.system(size: 50))
                                        .foregroundColor(.black)
                                    Text(String(format: Constants.TransactionRowConstants.noBookingsFormat, viewModel.selectedTab.rawValue.lowercased()))
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.top, 50)
                            } else {
                                ForEach(viewModel.bookings) { item in
                                    Button(action: {
                                        if item.status == .cancelled {
                                            cancelledBooking = item
                                        } else {
                                            selectedTransaction = item
                                        }
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
                                ProgressView()
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 8)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                    NavigationLink(
                        destination: Group {
                            if let transaction = selectedTransaction {
                                if let nav = navigationStorage {
                                    ExperienceBookingConfirmationView(orderNo: transaction.orderNo, isFromBookingJourney: false,
                                                                      booking: transaction )
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
                .sheet(item: $cancelledBooking) { booking in
                    CancelBookingBottomSheet(isPresented: .constant(true), onFinish: {
                        cancelledBooking = nil
                    })
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
