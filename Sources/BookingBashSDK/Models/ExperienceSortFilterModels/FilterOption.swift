import Foundation

struct FilterOption: Identifiable, Decodable, Hashable {
    let id: String
    let label: String
    let value: String
}

struct FilterGroup: Identifiable, Decodable {
    let id: String
    let title: String
    let options: [FilterOption]
}

