import Combine
import Foundation

final class ReviewDetailsViewModel {
        
    // MARK: - Properties
    
    @Published
    private(set) var rating: String
    
    @Published
    private(set) var author: String
    
    @Published
    private(set) var title: String
    
    @Published
    private(set) var review: String
    
    // MARK: - Initialisers
    
    init(review: ReviewsFeedEntryDto) {
        let formatter = ReviewFormatter(review: review)
        rating = formatter.rating
        author = formatter.author
        title = formatter.title
        self.review = formatter.content
    }
}
