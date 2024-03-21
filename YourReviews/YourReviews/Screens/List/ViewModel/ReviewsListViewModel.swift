import Combine
import Foundation

final class ReviewsListViewModel {
    
    // MARK: - Model
    
    struct ReviewsListHeaderModel {
        let filterTitle: String
        let topWordsTitle: String
        let topWords: String
    }
    
    struct ReviewCellModel: Hashable {
        let title: String
        let rating: String
        let author: String
        let review: String
    }
    
    // MARK: - Properties
    
    @Published
    private(set) var header = ReviewsListHeaderModel(filterTitle: "Filters", topWordsTitle: "Top words:", topWords: "Best, bank, ever")
    
    @Published
    private(set) var reviews: [ReviewCellModel] = [.init(title: "Title", rating: "⭐️⭐️⭐️", author: "Me", review: "Good")]
    
    // MARK: - Initialisers
    
    init() {
        
    }
}
