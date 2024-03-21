import UIKit

final class ReviewDetailsViewControllerFactory {
    func create(withRating rating: String, author: String, title: String, review: String) -> UIViewController {
        let viewModel = ReviewDetailsViewModel(rating: rating, author: author, title: title, review: review)
        let result = ReviewDetailsViewController(viewModel: viewModel)
        
        return result
    }
}
