import Combine
import Foundation

protocol ReviewsFilterProtocol: AnyObject {
    var validRange: ClosedRange<Int> { get }
    var rating: Int? { get set }
}

final class ReviewsFilter: ReviewsFilterProtocol {
    
    // MARK: - Properties
    
    let validRange: ClosedRange<Int>
    
    @Published
    var rating: Int?
    
    // MARK: - Initialisers
    
    init(validRange: ClosedRange<Int>) {
        self.validRange = validRange
    }
    
    // MARK: - Public
    
    func setRating(_ rating: Int?) {
        if let rating, validRange ~= rating {
            self.rating = rating
        } else if rating == nil {
            self.rating = nil
        }
    }
}
