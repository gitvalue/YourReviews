import Foundation

final class ReviewFormatter {
    
    // MARK: - Properties
    
    var rating: String {
        let numberOfStars = Int(review.rating) ?? 0
        let ratingPrefix = Array<String>(repeating: "⭐️", count: numberOfStars).joined()
        let ratingSuffix = "(ver: \(review.version))"
        return ratingPrefix + ratingSuffix
    }
    
    var author: String { "from: \(review.author.name)" }
    var title: String { review.title }
    var content: String { review.content }
    
    private let review: ReviewsFeedEntryDto
    
    // MARK: - Initialisers
    
    init(review: ReviewsFeedEntryDto) {
        self.review = review
    }
}
