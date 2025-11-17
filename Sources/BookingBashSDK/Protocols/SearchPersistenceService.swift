import Foundation

protocol SearchPersistenceService {
    func saveRecentSearches(_ searches: [SearchDestinationModel])
    func loadRecentSearches() -> [SearchDestinationModel]
    func clearRecentSearches()
}

final class UserDefaultsSearchPersistenceService: SearchPersistenceService {
    private let key = "recentSearches_v2"
    
    func saveRecentSearches(_ searches: [SearchDestinationModel]) {
        do {
            let data = try JSONEncoder().encode(searches)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
        }
    }
    
    func loadRecentSearches() -> [SearchDestinationModel] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        return (try? JSONDecoder().decode([SearchDestinationModel].self, from: data)) ?? []
    }
    
    func clearRecentSearches() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
