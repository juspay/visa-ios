
import Foundation

struct InitBookRequest: Codable {
    let booking_details: InitBookingDetails
    let contact_details: InitContactDetails
//    let earning_details: InitEarningDetails
//    let gst_details: InitGSTDetails
//    let pickup_details: InitPickupDetails
    let language_details: InitLanguageDetails
    let booking_question: InitBookingQuestion
}

struct InitBookingDetails: Codable {
    let uid: String
    let quotation_id: String
    let coupon_code: String
    let applied_bounz: Int
    let pg_mode: String
    let special_request: String
    let local_taxes_fee: Int
}

struct InitContactDetails: Codable {
    let title: String
    let first_name: String
    let last_name: String
    let email: String
    let code: String
    let mobile: String
}

struct InitEarningDetails: Codable {
    let agent_markup: Int
    let total_amount: Int
    let type: String
    let display_markup: [String: String]
}

struct InitGSTDetails: Codable {
    let addr: String
    let org_name: String
    let email: String
    let gst_no: String
    let contact_no: String
    let isd_code: String
}

struct InitPickupDetails: Codable {
    let provider: String
    let reference: String
    let name: String
    let address: String
    let city: String
    let country: String
    let pickup_type: String
    let type: String
}

struct InitLanguageDetails: Codable {
    let type: String
    let language: String
    let legacy_guide: String
    let name: String
}

struct InitBookingQuestion: Codable {
    let traveller_details: [InitTravellerDetail]
    let booking_questions_answers: [bookingQuestionsDetails]
}

struct bookingQuestionsDetails: Codable {
    let question: String
    let answer: String
    var unit: String? = nil
    var travelerNum: Int? = nil
}

struct InitTravellerDetail: Codable {
    let title: String
    let show_title: Bool
    let first_name: String
    let last_name: String
    let dob: String
    let height: String
    let weight: String
    let weight_unit: String
    let height_unit: String
    let age_band: String
    let passport_no: String
    let passport_exp: String
    let passport_nationality: String
    let passport_nationality_name: String
}

struct InitTravelDetail: Codable {
    let mode: String
    let name: String
    let airline: String
    let flight_number: String
    let rail_line: String
    let station: String
    let port_name: String
    let terminal: String
    let hotel_name: String
    let address: String
    let date: String
    let time: String
    let reference_value: String
    let remarks: String
}

// MARK: - Init Book Response
struct InitBookResponse: Codable {
    let status: Bool?
    let status_code: Int?
    let data: InitBookData?
    let error: InitBookAPIError?
}

struct InitBookData: Codable {
    let pg_token: String?
    let booking_id: String?
    let msg: String?
    let price_changed: String?
    let success_url: String?
    let pg_type: String?
    let mop: Int?
    let pg_bypass: Bool?
}

struct InitBookAPIError: Codable {
    let type: String
    let details: String
}
