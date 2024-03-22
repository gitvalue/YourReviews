import Combine
import Foundation

/// Reviews filter settings interface
/// sourcery: AutoMockable
protocol ReviewsFilterProtocol: AnyObject {
    /// Range of acceptable rating values
    var validRange: ClosedRange<Int> { get }
    
    /// Current rating filter setting
    var rating: Int? { get set }
}

/// Reviews filter settings
final class ReviewsFilter: ReviewsFilterProtocol {
    
    // MARK: - Properties
    
    let validRange: ClosedRange<Int>
    
    @Published
    var rating: Int?
    
    // MARK: - Initialisers
    
    /// Designated initialiser
    /// - Parameter validRange: Range of acceptable rating values
    init(validRange: ClosedRange<Int>) {
        self.validRange = validRange
    }
    
    // MARK: - Public
    
    /// Saves rating setting
    /// - Parameter rating: Rating setting value
    func setRating(_ rating: Int?) {
        if let rating, validRange ~= rating {
            self.rating = rating
        } else if rating == nil {
            self.rating = nil
        }
    }
}
