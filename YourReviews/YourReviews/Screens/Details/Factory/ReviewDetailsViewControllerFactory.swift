import UIKit

/// Review details view controller factory
final class ReviewDetailsViewControllerFactory {
    /// Creates review details view controller
    /// - Parameter review: Review model DTO
    /// - Returns: Review details view controller
    func create(withReview review: ReviewsFeedEntryDto) -> UIViewController {
        let viewModel = ReviewDetailsViewModel(review: review)
        let result = ReviewDetailsViewController(viewModel: viewModel)
        
        return result
    }
}
