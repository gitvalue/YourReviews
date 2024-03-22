import Combine
import Foundation

/// Review details screen business logic
final class ReviewDetailsViewModel {
        
    // MARK: - Properties
    
    /// Review rating text
    @Published
    private(set) var rating: String
    
    /// Review author name
    @Published
    private(set) var author: String
    
    /// Review title text
    @Published
    private(set) var title: String
    
    /// Review contents text
    @Published
    private(set) var review: String
    
    // MARK: - Initialisers
    
    /// Designated initialiser
    /// - Parameter review: Review model DTO
    init(review: ReviewsFeedEntryDto) {
        let formatter = ReviewFormatter(review: review)
        rating = formatter.rating
        author = formatter.author
        title = formatter.title
        self.review = formatter.content
    }
}
