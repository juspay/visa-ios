
struct ConfirmationRequest: Codable {
    let orderNo: String
    

    enum CodingKeys: String, CodingKey {
        case orderNo = "order_no"
       
    }
}
