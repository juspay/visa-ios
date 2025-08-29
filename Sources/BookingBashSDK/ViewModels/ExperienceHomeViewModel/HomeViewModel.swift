//
//  ViewModel.swift
//  VisaActivity
//
//  Created by Apple on 29/07/25.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var destinations: [Destination] = []
    @Published var experiences: [Experience] = []

    private var allExperiences: [Experience] = []
    private let loadCount = 5

    init() {
        loadMockData()
    }

    func loadMoreExperiences() {
        let remaining = allExperiences.dropFirst(experiences.count)
        let nextChunk = remaining.prefix(loadCount)
        experiences.append(contentsOf: nextChunk)
    }

    private func loadMockData() {
        destinations = [
            Destination(name: "Singapore", imageName: "Birds"),
            Destination(name: "UAE", imageName: "Birds"),
            Destination(name: "Turkey", imageName: "Birds"),
            Destination(name: "China", imageName: "Birds"),
            Destination(name: "India", imageName: "Birds")
        ]

        allExperiences = [
            Experience(imageName: "Sky", country: "Dubai", title: "Dubai Red Dunes ATV", originalPrice: 300, discount: 5, finalPrice: 295),
            Experience(imageName: "Sky", country: "Egypt", title: "Temple of Horus at Edfu", originalPrice: 300, discount: 5, finalPrice: 295),
            Experience(imageName: "Nature", country: "Bangkok", title: "Safari World Tickets", originalPrice: 300, discount: 5, finalPrice: 295),
            Experience(imageName: "Sky", country: "Turkey", title: "Land of Legends Night Show", originalPrice: 300, discount: 5, finalPrice: 295),
            Experience(imageName: "Sky", country: "Brazil", title: "Christ the Redeemer Tickets", originalPrice: 300, discount: 5, finalPrice: 295),
            Experience(imageName: "Nature", country: "Japan", title: "Mount Fuji Day Trip", originalPrice: 400, discount: 10, finalPrice: 360)
        ]

        loadMoreExperiences()
    }
}
