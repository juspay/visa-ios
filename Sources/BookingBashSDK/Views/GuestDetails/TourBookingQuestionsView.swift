import SwiftUI

// MARK: - ViewModel
class TourBookingQuestionsViewModel: ObservableObject {
    // Tour Specific
    @Published var tourLanguage: String = ""
    @Published var specialRequest: String = ""
    // Arrival
    @Published var arrivalTransferMode: String = ""
    @Published var pickUpLocation: String = ""
    @Published var enterPickupLocation: String = ""
    @Published var arrivalFlightNo: String = ""
    @Published var arrivalAirlines: String = ""
    @Published var arrivalTime: Date = Date()
    @Published var disembarkationTime: Date = Date()
    @Published var arrivalDropOffLocation: String = ""
    @Published var arrivalRailLine: String = ""
    @Published var arrivalRailStation: String = ""
    // Departure
    @Published var departureTransferMode: String = ""
    @Published var departurePickUpLocation: String = ""
    @Published var departureFlightNo: String = ""
    @Published var departureAirlines: String = ""
    @Published var departureTime: Date = Date()
    @Published var boardingTime: Date = Date()
    @Published var departureDate: Date = Date()
    @Published var departureRailLine: String = ""
    @Published var departureRailStation: String = ""
    @Published var cruiseShip: String = ""
    // Dropdown options
    let tourLanguages: [String]
    let transferModes: [String]
    let pickUpLocations: [String]
    let departurePickUpLocations: [String]
    init(
        tourLanguages: [String] = ["English - Audio", "French - Audio", "German - Audio"],
        transferModes: [String] = ["Air", "Rail", "Bus", "Other"],
        pickUpLocations: [String] = ["I don't see my pickup location", "Hotel", "Airport", "Other"],
        departurePickUpLocations: [String] = ["Other", "Hotel", "Airport", "Railway Station"]
    ) {
        self.tourLanguages = tourLanguages
        self.transferModes = transferModes
        self.pickUpLocations = pickUpLocations
        self.departurePickUpLocations = departurePickUpLocations
        self.tourLanguage = tourLanguages.first ?? ""
        self.arrivalTransferMode = transferModes.first ?? ""
        self.pickUpLocation = pickUpLocations.first ?? ""
        self.departureTransferMode = transferModes.first ?? ""
        self.departurePickUpLocation = departurePickUpLocations.first ?? ""
    }
}

// MARK: - View
struct TourBookingQuestionsView: View {
    @StateObject private var vm = TourBookingQuestionsViewModel()
    @State private var showArrivalTimePicker = false
    @State private var showDisembarkationTimePicker = false
    @State private var showDepartureTimePicker = false
    @State private var showBoardingTimePicker = false
    @State private var showDepartureDatePicker = false
    @State private var tempDepartureDate: Date = Date()
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text(Constants.TourBookingQuestionsConstants.tourSpecific)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color(.systemGray))
                // Tour Language
                VStack(alignment: .leading, spacing: 6) {
                    Text(Constants.TourBookingQuestionsConstants.tourLanguage)
                        .font(.system(size: 16))
                    Menu {
                        ForEach(vm.tourLanguages, id: \ .self) { lang in
                            Button(lang) { vm.tourLanguage = lang }
                        }
                    } label: {
                        HStack {
                            Text(vm.tourLanguage)
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.brown)
                        }
                        .padding(.horizontal, 12)
                        .frame(height: 44)
                        .background(Color.white)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.35)))
                        .cornerRadius(8)
                    }
                }
                // Special Request
                VStack(alignment: .leading, spacing: 6) {
                    Text(Constants.TourBookingQuestionsConstants.specialRequest)
                        .font(.system(size: 16))
                    TextEditor(text: $vm.specialRequest)
                        .frame(height: 90)
                        .padding(8)
                        .background(Color.white)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.35)))
                }
                // Arrival Transfer Mode
                VStack(alignment: .leading, spacing: 6) {
                    Text(Constants.TourBookingQuestionsConstants.arrivalTransferMode)
                        .font(.system(size: 16))
                    Menu {
                        ForEach(vm.transferModes, id: \ .self) { mode in
                            Button(mode) { vm.arrivalTransferMode = mode }
                        }
                    } label: {
                        HStack {
                            Text(vm.arrivalTransferMode)
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.brown)
                        }
                        .padding(.horizontal, 12)
                        .frame(height: 44)
                        .background(Color.white)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.35)))
                        .cornerRadius(8)
                    }
                }
                // Pick Up Location
                VStack(alignment: .leading, spacing: 6) {
                    Text(Constants.TourBookingQuestionsConstants.pickUpLocation)
                        .font(.system(size: 16))
                    Menu {
                        ForEach(vm.pickUpLocations, id: \ .self) { loc in
                            Button(loc) { vm.pickUpLocation = loc }
                        }
                    } label: {
                        HStack {
                            Text(vm.pickUpLocation)
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.brown)
                        }
                        .padding(.horizontal, 12)
                        .frame(height: 44)
                        .background(Color.white)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.35)))
                        .cornerRadius(8)
                    }
                }
                // Enter Your Pickup Location
                VStack(alignment: .leading, spacing: 6) {
                    Text(Constants.TourBookingQuestionsConstants.enterYourPickupLocation)
                        .font(.system(size: 16))
                    StyledTextField(placeholder: "Bus Stop", text: $vm.enterPickupLocation)
                }
                // Arrival Flight No.
                VStack(alignment: .leading, spacing: 6) {
                    Text(Constants.TourBookingQuestionsConstants.arrivalFlightNo)
                        .font(.system(size: 16))
                    StyledTextField(placeholder: "FT23543", text: $vm.arrivalFlightNo)
                }
                // Arrival Airlines
                VStack(alignment: .leading, spacing: 6) {
                    Text(Constants.TourBookingQuestionsConstants.arrivalAirlines)
                        .font(.system(size: 16))
                    StyledTextField(placeholder: "Airindia", text: $vm.arrivalAirlines)
                }
                // Arrival Time
                VStack(alignment: .leading, spacing: 6) {
                    Text(Constants.TourBookingQuestionsConstants.arrivalTime)
                        .font(.system(size: 16))
                    ZStack(alignment: .trailing) {
                        StyledTextField(placeholder: "12:30", text: .constant(timeString(vm.arrivalTime)))
                            .disabled(true)
                        Button(action: { showArrivalTimePicker = true }) {
                            Image(systemName: "clock")
                                .foregroundColor(.brown)
                                .padding(.trailing, 12)
                        }
                        .frame(height: 44, alignment: .trailing)
                    }
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.35)))
                    .cornerRadius(8)
                    .frame(height: 44)
                }
                // Disembarkation Time
                VStack(alignment: .leading, spacing: 6) {
                    Text(Constants.TourBookingQuestionsConstants.disembarkationTime)
                        .font(.system(size: 16))
                    ZStack(alignment: .trailing) {
                        StyledTextField(placeholder: "12:30", text: .constant(timeString(vm.disembarkationTime)))
                            .disabled(true)
                        Button(action: { showDisembarkationTimePicker = true }) {
                            Image(systemName: "clock")
                                .foregroundColor(.brown)
                                .padding(.trailing, 12)
                        }
                        .frame(height: 44, alignment: .trailing)
                    }
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.35)))
                    .cornerRadius(8)
                    .frame(height: 44)
                }
                // Arrival Drop Off Location
                VStack(alignment: .leading, spacing: 6) {
                    Text(Constants.TourBookingQuestionsConstants.arrivalDropOffLocation)
                        .font(.system(size: 16))
                    StyledTextField(placeholder: "Dubai", text: $vm.arrivalDropOffLocation)
                }
                // Arrival Rail Line
                VStack(alignment: .leading, spacing: 6) {
                    Text(Constants.TourBookingQuestionsConstants.arrivalRailLine)
                        .font(.system(size: 16))
                    StyledTextField(placeholder: "Arrival Rail Line", text: $vm.arrivalRailLine)
                }
                // Arrival Rail Station
                VStack(alignment: .leading, spacing: 6) {
                    Text(Constants.TourBookingQuestionsConstants.arrivalRailStation)
                        .font(.system(size: 16))
                    StyledTextField(placeholder: "Arrival Rail Station", text: $vm.arrivalRailStation)
                }
                // Departure Transfer Mode
                VStack(alignment: .leading, spacing: 6) {
                    Text(Constants.TourBookingQuestionsConstants.departureTransferMode)
                        .font(.system(size: 16))
                    Menu {
                        ForEach(vm.transferModes, id: \ .self) { mode in
                            Button(mode) { vm.departureTransferMode = mode }
                        }
                    } label: {
                        HStack {
                            Text(vm.departureTransferMode)
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.brown)
                        }
                        .padding(.horizontal, 12)
                        .frame(height: 44)
                        .background(Color.white)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.35)))
                        .cornerRadius(8)
                    }
                }
                // Departure Pick Up Location
                VStack(alignment: .leading, spacing: 6) {
                    Text(Constants.TourBookingQuestionsConstants.departurePickUpLocation)
                        .font(.system(size: 16))
                    Menu {
                        ForEach(vm.departurePickUpLocations, id: \ .self) { loc in
                            Button(loc) { vm.departurePickUpLocation = loc }
                        }
                    } label: {
                        HStack {
                            Text(vm.departurePickUpLocation)
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.brown)
                        }
                        .padding(.horizontal, 12)
                        .frame(height: 44)
                        .background(Color.white)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.35)))
                        .cornerRadius(8)
                    }
                }
                // Departure Flight No.
                VStack(alignment: .leading, spacing: 6) {
                    Text(Constants.TourBookingQuestionsConstants.departureFlightNo)
                        .font(.system(size: 16))
                    StyledTextField(placeholder: "FT23543", text: $vm.departureFlightNo)
                }
                // Departure Airlines
                VStack(alignment: .leading, spacing: 6) {
                    Text(Constants.TourBookingQuestionsConstants.departureAirlines)
                        .font(.system(size: 16))
                    StyledTextField(placeholder: "Airindia", text: $vm.departureAirlines)
                }
                // Departure Time
                VStack(alignment: .leading, spacing: 6) {
                    Text(Constants.TourBookingQuestionsConstants.departureTime)
                        .font(.system(size: 16))
                    ZStack(alignment: .trailing) {
                        StyledTextField(placeholder: "12:30", text: .constant(timeString(vm.departureTime)))
                            .disabled(true)
                        Button(action: { showDepartureTimePicker = true }) {
                            Image(systemName: "clock")
                                .foregroundColor(.brown)
                                .padding(.trailing, 12)
                        }
                        .frame(height: 44, alignment: .trailing)
                    }
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.35)))
                    .cornerRadius(8)
                    .frame(height: 44)
                }
                // Boarding Time
                VStack(alignment: .leading, spacing: 6) {
                    Text(Constants.TourBookingQuestionsConstants.boardingTime)
                        .font(.system(size: 16))
                    ZStack(alignment: .trailing) {
                        StyledTextField(placeholder: "12:30", text: .constant(timeString(vm.boardingTime)))
                            .disabled(true)
                        Button(action: { showBoardingTimePicker = true }) {
                            Image(systemName: "clock")
                                .foregroundColor(.brown)
                                .padding(.trailing, 12)
                        }
                        .frame(height: 44, alignment: .trailing)
                    }
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.35)))
                    .cornerRadius(8)
                    .frame(height: 44)
                }
                // Departure Date
                VStack(alignment: .leading, spacing: 6) {
                    Text(Constants.TourBookingQuestionsConstants.departureDate)
                        .font(.system(size: 16))
                    ZStack(alignment: .top) {
                        VStack(spacing: 0) {
                            ZStack(alignment: .trailing) {
                                StyledTextField(placeholder: "dd/mm/yyyy", text: .constant(dateString(vm.departureDate)))
                                    .disabled(true)
                                Button(action: {
                                    tempDepartureDate = vm.departureDate < Date() ? Date() : vm.departureDate
                                    showDepartureDatePicker = true
                                }) {
                                    Image(systemName: "calendar")
                                        .foregroundColor(.brown)
                                        .padding(.trailing, 12)
                                }
                                .frame(height: 44, alignment: .trailing)
                            }
                            .background(Color.white)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.35)))
                            .cornerRadius(8)
                            .frame(height: 44)
                            // Calendar appears directly below the textfield
                            if showDepartureDatePicker {
                                CustomCalendarPicker(
                                    date: $tempDepartureDate,
                                    minDate: Date(),
                                    maxDate: nil
                                ) {
                                    vm.departureDate = tempDepartureDate
                                    showDepartureDatePicker = false
                                }
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(radius: 8)
                                .padding(.top, 4)
                            }
                        }
                    }
                }
                // Departure Rail Line
                VStack(alignment: .leading, spacing: 6) {
                    Text(Constants.TourBookingQuestionsConstants.departureRailLine)
                        .font(.system(size: 16))
                    StyledTextField(placeholder: "Departure Rail Line", text: $vm.departureRailLine)
                }
                // Departure Rail Station
                VStack(alignment: .leading, spacing: 6) {
                    Text(Constants.TourBookingQuestionsConstants.departureRailStation)
                        .font(.system(size: 16))
                    StyledTextField(placeholder: "Departure Rail Station", text: $vm.departureRailStation)
                }
                // Cruise Ship
                VStack(alignment: .leading, spacing: 6) {
                    Text(Constants.TourBookingQuestionsConstants.cruiseShip)
                        .font(.system(size: 16))
                    StyledTextField(placeholder: "Cruise Ship", text: $vm.cruiseShip)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 16)
        }
        // Time pickers overlays
        .sheet(isPresented: $showArrivalTimePicker) {
            CustomTimePickerSheet(date: $vm.arrivalTime)
        }
        .sheet(isPresented: $showDisembarkationTimePicker) {
            CustomTimePickerSheet(date: $vm.disembarkationTime)
        }
        .sheet(isPresented: $showDepartureTimePicker) {
            CustomTimePickerSheet(date: $vm.departureTime)
        }
        .sheet(isPresented: $showBoardingTimePicker) {
            CustomTimePickerSheet(date: $vm.boardingTime)
        }
    }
    // Helper for time string
    private func timeString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    private func dateString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
}

// MARK: - Date Picker Sheet
struct DatePickerSheet: View {
    @Binding var date: Date
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            DatePicker("Select Date", selection: $date, displayedComponents: .date)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                .padding()
            Button("Done") { presentationMode.wrappedValue.dismiss() }
                .padding()
        }
    }
}

// MARK: - Standard Tour View
struct StandardTourView: View {
    @State private var specialRequest: String = ""
    var startPoint: String = "Jai Pol, 72X9+WR7, Sodagaran Mohalla, Jodhpur, Rajasthan 342001, India"
    var tourLanguage: String = "English – Guide"
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Tour Specific")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(.systemGray))
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Start Point")
                .font(.system(size: 16, weight: .semibold))
                
                HStack(alignment: .top, spacing: 10) {
                    if let mapIcon = ImageLoader.bundleImage(named: Constants.Icons.map) {
                        mapIcon
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 18, height: 18)
                            .foregroundStyle(Color.gray)
                    }
                    
                    Text(startPoint)
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                }
            }
                .padding(10)
                .background(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.35)))
            
            HStack(alignment: .center, spacing: 8) {
                Text("Tour language")
                    .font(.system(size: 16, weight: .semibold))
                Text(tourLanguage)
                    .font(.system(size: 16))
            }
            VStack(alignment: .leading, spacing: 6) {
                Text("Special Request if any (optional)")
                    .font(.system(size: 16))
                TextEditor(text: $specialRequest)
                    .frame(height: 70)
                    .padding(8)
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.35)))
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

// MARK: - Unstructured Tour View
struct UnstructuredTourView: View {
    @State private var specialRequest: String = ""
    @State private var selectedLanguage: String = "English - Audio"
    var startPoint: String = "Jai Pol, 72X9+WR7, Sodagaran Mohalla, Jodhpur, Rajasthan 342001, India"
    var tourLanguages: [String] = ["English - Audio", "French - Audio", "German - Audio"]
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Tour Specific")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(.systemGray))
            VStack(alignment: .leading, spacing: 10) {
                Text("Start Point")
                .font(.system(size: 16, weight: .semibold))
                
                HStack(alignment: .top, spacing: 10) {
                    if let mapIcon = ImageLoader.bundleImage(named: Constants.Icons.map) {
                        mapIcon
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 18, height: 18)
                            .foregroundStyle(Color.gray)
                    }
                    
                    Text(startPoint)
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                }
            }
                .padding(10)
                .background(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.35)))

            VStack(alignment: .leading, spacing: 6) {
                Text("Tour language")
                    .font(.system(size: 16, weight: .semibold))
                Menu {
                    ForEach(tourLanguages, id: \ .self) { lang in
                        Button(lang) { selectedLanguage = lang }
                    }
                } label: {
                    HStack {
                        Text(selectedLanguage)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.brown)
                    }
                    .padding(.horizontal, 12)
                    .frame(height: 44)
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.35)))
                    .cornerRadius(8)
                }
            }
            VStack(alignment: .leading, spacing: 6) {
                Text("Special Request if any (optional)")
                    .font(.system(size: 16))
                TextEditor(text: $specialRequest)
                    .frame(height: 70)
                    .padding(8)
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.35)))
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

// MARK: - Hop On Hop Off Tour View
struct HopOnHopOffTourView: View {
    @State private var specialRequest: String = ""
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Tour Specific")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(.systemGray))
            VStack(alignment: .leading, spacing: 6) {
                Text("Special Request if any (optional)")
                    .font(.system(size: 16))
                TextEditor(text: $specialRequest)
                    .frame(height: 70)
                    .padding(8)
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.35)))
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

// MARK: - Multi Day Tour Option 1 View
struct MultiDayTourOption1View: View {
    @State private var selectedOption: Int = 0
    @State private var searchLocation: String = ""
    @State private var selectedLanguage: String = "English - Audio"
    @State private var specialRequest: String = ""
    let tourLanguages = ["English - Audio", "French - Audio", "German - Audio"]
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Tour Specific")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(.systemGray))
            VStack(alignment: .leading, spacing: 8) {
                Text("Tell us where you’d like to be picked up from. If you're not sure, you can decide later.")
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
                VStack(alignment: .leading, spacing: 12) {
                    RadioButtonRow(isSelected: selectedOption == 0, label: "I’d like to be picked up") {
                        selectedOption = 0
                    }
                    if selectedOption == 0 {
                        HStack {
                            TextField("Search location", text: $searchLocation)
                                .padding(10)
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.brown)
                                .padding(.trailing, 10)
                        }
                        .background(Color.white)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.35)))
                        .cornerRadius(8)
                        .padding(.leading, 28)
                    }
                    RadioButtonRow(isSelected: selectedOption == 1, label: "I’ll make my own way to the meeting point") {
                        selectedOption = 1
                    }
                    RadioButtonRow(isSelected: selectedOption == 2, label: "I’ll decide later") {
                        selectedOption = 2
                    }
                }
                .padding(10)
                .background(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.35)))
            }
            VStack(alignment: .leading, spacing: 6) {
                Text("Tour language")
                    .font(.system(size: 16, weight: .semibold))
                Menu {
                    ForEach(tourLanguages, id: \ .self) { lang in
                        Button(lang) { selectedLanguage = lang }
                    }
                } label: {
                    HStack {
                        Text(selectedLanguage)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.brown)
                    }
                    .padding(.horizontal, 12)
                    .frame(height: 44)
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.35)))
                    .cornerRadius(8)
                }
            }
            VStack(alignment: .leading, spacing: 6) {
                Text("Special Request if any (optional)")
                    .font(.system(size: 16))
                TextEditor(text: $specialRequest)
                    .frame(height: 70)
                    .padding(8)
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.35)))
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

// MARK: - Multi Day Tour Option 2 View
struct MultiDayTourOption2View: View {
    @State private var selectedOption: Int = 1
    @State private var selectedLanguage: String = "English - Audio"
    @State private var specialRequest: String = ""
    let tourLanguages = ["English - Audio", "French - Audio", "German - Audio"]
    let meetingPoint = "Volare | Vuelos en globo, Carretera Libre a Tulancingo Km 27.5 San Francisco Mazapa, Manzana 005, 55830 de Arista, Méx., Mexico"
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Tour Specific")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(.systemGray))
            VStack(alignment: .leading, spacing: 8) {
                Text("Tell us where you’d like to be picked up from. If you're not sure, you can decide later.")
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
                VStack(alignment: .leading, spacing: 12) {
                    RadioButtonRow(isSelected: selectedOption == 0, label: "I’d like to be picked up") {
                        selectedOption = 0
                    }
                    RadioButtonRow(isSelected: selectedOption == 1, label: "I’ll make my own way to the meeting point") {
                        selectedOption = 1
                    }
                    if selectedOption == 1 {
                        HStack(alignment: .top, spacing: 8) {

                            if let mapIcon = ImageLoader.bundleImage(named: Constants.Icons.map) {
                                mapIcon
                                    .resizable()
//                                    .padding(.top, 2)
                                    .renderingMode(.template)
                                    .frame(width: 18, height: 18)
                                    .foregroundStyle(Color.gray)
                            }
                            Text(meetingPoint)
                                .font(.system(size: 15))
                                .foregroundColor(.secondary)
                        }
                        .padding(10)
                        .background(Color(.systemYellow).opacity(0.15))
                        .cornerRadius(8)
                        .padding(.leading, 28)
                    }
                    RadioButtonRow(isSelected: selectedOption == 2, label: "I’ll decide later") {
                        selectedOption = 2
                    }
                }
                .padding(10)
                .background(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.35)))
            }
            VStack(alignment: .leading, spacing: 6) {
                Text("Tour language")
                    .font(.system(size: 16, weight: .semibold))
                Menu {
                    ForEach(tourLanguages, id: \ .self) { lang in
                        Button(lang) { selectedLanguage = lang }
                    }
                } label: {
                    HStack {
                        Text(selectedLanguage)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.brown)
                    }
                    .padding(.horizontal, 12)
                    .frame(height: 44)
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.35)))
                    .cornerRadius(8)
                }
            }
            VStack(alignment: .leading, spacing: 6) {
                Text("Special Request if any (optional)")
                    .font(.system(size: 16))
                TextEditor(text: $specialRequest)
                    .frame(height: 70)
                    .padding(8)
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.35)))
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

// MARK: - Multi Day Tour Option 3 View
struct MultiDayTourOption3View: View {
    @State private var selectedOption: Int = 2
    @State private var selectedLanguage: String = "English - Audio"
    @State private var specialRequest: String = ""
    let tourLanguages = ["English - Audio", "French - Audio", "German - Audio"]
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Tour Specific")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(.systemGray))
            VStack(alignment: .leading, spacing: 8) {
                Text("Tell us where you’d like to be picked up from. If you're not sure, you can decide later.")
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
                VStack(alignment: .leading, spacing: 12) {
                    RadioButtonRow(isSelected: selectedOption == 0, label: "I’d like to be picked up") {
                        selectedOption = 0
                    }
                    RadioButtonRow(isSelected: selectedOption == 1, label: "I’ll make my own way to the meeting point") {
                        selectedOption = 1
                    }
                    RadioButtonRow(isSelected: selectedOption == 2, label: "I’ll decide later") {
                        selectedOption = 2
                    }
                }
                .padding(10)
                .background(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.35)))
            }
            VStack(alignment: .leading, spacing: 6) {
                Text("Tour language")
                    .font(.system(size: 16, weight: .semibold))
                Menu {
                    ForEach(tourLanguages, id: \ .self) { lang in
                        Button(lang) { selectedLanguage = lang }
                    }
                } label: {
                    HStack {
                        Text(selectedLanguage)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.brown)
                    }
                    .padding(.horizontal, 12)
                    .frame(height: 44)
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.35)))
                    .cornerRadius(8)
                }
            }
            VStack(alignment: .leading, spacing: 6) {
                Text("Special Request if any (optional)")
                    .font(.system(size: 16))
                TextEditor(text: $specialRequest)
                    .frame(height: 70)
                    .padding(8)
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.35)))
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

// MARK: - Radio Button Row
struct RadioButtonRow: View {
    var isSelected: Bool
    var label: String
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .stroke(isSelected ? Color.brown : Color.gray.opacity(0.5), lineWidth: 2)
                        .frame(width: 22, height: 22)
                    if isSelected {
                        Circle()
                            .fill(Color.brown)
                            .frame(width: 12, height: 12)
                    }
                }
                Text(label)
                    .font(.system(size: 16, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? .primary : .secondary)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
