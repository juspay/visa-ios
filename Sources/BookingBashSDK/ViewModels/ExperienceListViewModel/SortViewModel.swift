import Foundation
import SwiftUI
import Combine

class SortViewModel: ObservableObject {
    @Published var selectedOption: SortOption?
    // Remove isLoading and errorMessage from here, rely on ExperienceListViewModel's state
    
    private var viewModel: ExperienceListViewModel
    
    let options: [SortOption] = [
        SortOption(title: "Price - Low to high"),
        SortOption(title: "Price - High to low")
    ]
    
    init(viewModel: ExperienceListViewModel) {
        self.viewModel = viewModel
        self.selectedOption = options.first
    }
    
    func select(_ option: SortOption) {
        selectedOption = option
        applySort()
    }
    
    private func applySort() {
        guard let selectedOption = selectedOption else { return }
        
        let updatedSortBy: SortBy = {
            switch selectedOption.title {
            case "Price - Low to high": return SortBy(name: "price", type: "ASC")
            case "Price - High to low": return SortBy(name: "price", type: "DESC")
            default: return SortBy(name: "price", type: "ASC")
            }
        }()
        
        // Delegate the work to the main ViewModel
        viewModel.updateSortOrder(sortBy: updatedSortBy)
    }
}
