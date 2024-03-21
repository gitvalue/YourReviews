import UIKit

final class ReviewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private let stackView = UIStackView()
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
    
    func setTitle(_ text: String) {
        titleLabel.text = text
    }
    
    func setRating(_ text: String) {
        ratingVersionLabel.text = text
    }
    
    func setAuthor(_ text: String) {
        authorLabel.text = text
    }
    
    func setReview(_ text: String) {
        textPreviewLabel.text = text
    }
    
    // MARK: - Private
    
    private func setUpSubviews() {
        contentView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        
        stackView.addArrangedSubview(titleLabel)
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.numberOfLines = 2

        stackView.addArrangedSubview(ratingVersionLabel)
        ratingVersionLabel.font = .italicSystemFont(ofSize: 18)
        
        stackView.addArrangedSubview(authorLabel)
        authorLabel.font = .italicSystemFont(ofSize: 18)
        
        stackView.addArrangedSubview(textPreviewLabel)
        textPreviewLabel.font = .systemFont(ofSize: 14)
        textPreviewLabel.numberOfLines = 3
    }
    
    private func setUpConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let margin: CGFloat = 8.0
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin)
        ])
    }
}