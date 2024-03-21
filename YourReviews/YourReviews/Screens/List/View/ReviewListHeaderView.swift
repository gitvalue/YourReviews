import UIKit

final class ReviewListHeaderView: UICollectionReusableView {
    
    // MARK: - Properties
    
    override var reuseIdentifier: String? { String(describing: self) }
    
    private let stackView = UIStackView()
    
    private let filterImageView = UIImageView()
    private let filterTitleLabel = UILabel()
    
    private let topWordsTitleLabel = UILabel()
    private let topWordsLabel = UILabel()
    
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
    
    func setFilterTitle(_ text: String) {
        filterTitleLabel.text = text
    }
    
    func setTopWordsTitle(_ text: String) {
        topWordsTitleLabel.text = text
    }
    
    func setTopWords(_ text: String) {
        topWordsLabel.text = text
    }
    
    // MARK: - Private
    
    private func setUpSubviews() {
        addSubview(stackView)
        stackView.axis = .vertical
        stackView.alignment = .center
        
        let filterStackView = UIStackView()
        filterStackView.axis = .horizontal
        stackView.addArrangedSubview(filterStackView)
        
        filterStackView.addArrangedSubview(filterImageView)
        filterImageView.image = UIImage(systemName: "slider.horizontal.3")
        filterStackView.addArrangedSubview(filterTitleLabel)
        
        stackView.addArrangedSubview(topWordsTitleLabel)
        stackView.addArrangedSubview(topWordsLabel)
        topWordsLabel.numberOfLines = 0
    }
    
    private func setUpConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
