import Combine
import UIKit

/// Review details screen
final class ReviewDetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let scrollView = UIScrollView()
    private let ratingLabel = UILabel()
    private let authorLabel = UILabel()
    private let titleLabel = UILabel()
    private let contentLabel = UILabel()
    
    private var subscriptions: [AnyCancellable] = []
    private let viewModel: ReviewDetailsViewModel
    
    // MARK: - Initialiserss
    
    /// Designated initialiser
    /// - Parameter viewModel: Review details view model
    init(viewModel: ReviewDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
        
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setUpSubviews()
        setUpConstraints()
        setUpBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
        
    // MARK: - Private
    
    private func setUpSubviews() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(ratingLabel)
        ratingLabel.font = .italicSystemFont(ofSize: 18.0)
        
        scrollView.addSubview(authorLabel)
        authorLabel.font = .systemFont(ofSize: 18.0)
        
        scrollView.addSubview(titleLabel)
        titleLabel.numberOfLines = 0
        titleLabel.font = .boldSystemFont(ofSize: 22.0)
        
        scrollView.addSubview(contentLabel)
        contentLabel.numberOfLines = 0
    }
    
    private func setUpConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ratingLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 8.0),
            ratingLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            ratingLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0)
        ])

        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 8.0),
            authorLabel.leadingAnchor.constraint(equalTo: ratingLabel.leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: ratingLabel.trailingAnchor)
        ])

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 8.0),
            titleLabel.leadingAnchor.constraint(equalTo: ratingLabel.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: ratingLabel.trailingAnchor),
            titleLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 72.0)
        ])
        
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0),
            contentLabel.leadingAnchor.constraint(equalTo: ratingLabel.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: ratingLabel.trailingAnchor),
            contentLabel.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.bottomAnchor, constant: -16.0)
        ])
    }
    
    private func setUpBindings() {
        subscriptions = [
            viewModel.$rating.receive(on: DispatchQueue.main).sink { [ratingLabel] text in
                ratingLabel.text = text
            },
            viewModel.$author.receive(on: DispatchQueue.main).sink { [authorLabel] text in
                authorLabel.text = text
            },
            viewModel.$title.receive(on: DispatchQueue.main).sink { [titleLabel] text in
                titleLabel.text = text
            },
            viewModel.$review.receive(on: DispatchQueue.main).sink { [contentLabel] text in
                contentLabel.text = text
            }
        ]
    }
}
