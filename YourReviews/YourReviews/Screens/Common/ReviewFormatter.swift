import Foundation

/// Review details formatter
final class ReviewFormatter {
    
    // MARK: - Properties
    
    /// Formatted rating text
    var rating: String {
        let numberOfStars = Int(review.rating) ?? 0
        let ratingPrefix = Array<String>(repeating: "⭐️", count: numberOfStars).joined()
        let ratingSuffix = "(ver: \(review.version))"
        return ratingPrefix + ratingSuffix
    }
    
    /// Formatted author name
    var author: String { "from: \(review.author.name)" }
    /// Formatted review title text
    var title: String { review.title }
    /// Formatted review content text
    var content: String { review.content }
    
    private let review: ReviewsFeedEntryDto
    
    // MARK: - Initialisers
    
    /// Designated initialiser
    /// - Parameter review: Review model DTO
    init(review: ReviewsFeedEntryDto) {
        self.review = review
    }
}
