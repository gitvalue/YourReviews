import UIKit

final class ReviewDetailsViewControllerFactory {
    func create(withReview review: ReviewsFeedEntryDto) -> UIViewController {
        let viewModel = ReviewDetailsViewModel(review: review)
        let result = ReviewDetailsViewController(viewModel: viewModel)
        
        return result
    }
}
