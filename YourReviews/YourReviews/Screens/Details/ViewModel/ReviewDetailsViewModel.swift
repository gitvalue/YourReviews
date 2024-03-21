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
    
    init(rating: String, author: String, title: String, review: String) {
        self.rating = rating
        self.author = author
        self.title = title
        self.review = review
    }
}
