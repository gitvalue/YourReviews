import UIKit

/// Reviews feed list cell
final class ReviewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private let stackView = UIStackView()
    private let separatorView = UIView()
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let textPreviewLabel = UILabel()
    private let ratingVersionLabel = UILabel()
    
    // MARK: - Initialisers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpSubviews()
        setUpConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    /// Displays rating text
    /// - Parameter text: Rating text
    func setRating(_ text: String) {
        ratingVersionLabel.text = text
    }
    
    /// Displays author name
    /// - Parameter text: Author name
    func setAuthor(_ text: String) {
        authorLabel.text = text
    }
    
    /// Displays review title
    /// - Parameter text: Review title text
    func setTitle(_ text: String) {
        titleLabel.text = text
    }
    
    /// Displays review contents
    /// - Parameter text: Review contents text
    func setReview(_ text: String) {
        textPreviewLabel.text = text
    }
    
    // MARK: - Private
    
    private func setUpSubviews() {
        contentView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.spacing = 8.0
                
        stackView.addArrangedSubview(ratingVersionLabel)
        ratingVersionLabel.font = .italicSystemFont(ofSize: 18.0)
        
        stackView.addArrangedSubview(authorLabel)
        authorLabel.font = .italicSystemFont(ofSize: 18.0)
        
        stackView.addArrangedSubview(titleLabel)
        titleLabel.font = .boldSystemFont(ofSize: 18.0)
        titleLabel.numberOfLines = 2
        
        stackView.addArrangedSubview(textPreviewLabel)
        textPreviewLabel.font = .systemFont(ofSize: 14.0)
        textPreviewLabel.numberOfLines = 3
    }
    
    private func setUpConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.0),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.0)
        ])
    }
}
