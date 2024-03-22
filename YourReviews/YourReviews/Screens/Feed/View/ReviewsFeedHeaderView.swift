import Combine
import UIKit

/// Reviews feed screen header
final class ReviewsFeedHeaderView: UIView {
    
    // MARK: - Properties
    
    private let stackView = UIStackView()
    
    private let filterButton = UIButton()
    
    private let topWordsTitleLabel = UILabel()
    private let topWordsLabel = UILabel()
    
    private var filterButtonPressEventPublisher: PassthroughSubject<Void, Never>?
    
    // MARK: - Initialisers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        
        setUpSubviews()
        setUpConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        filterButton.layer.cornerRadius = filterButton.frame.height / 2
    }
    
    /// Displays filter button title
    /// - Parameter text: Filter button title text
    func setFilterButtonTitle(_ text: String) {
        filterButton.setTitle(text, for: .normal)
    }
    
    /// Displays top occuring words title text
    /// - Parameter text: Top words title text
    func setTopWordsTitle(_ text: String) {
        topWordsTitleLabel.text = text
    }
    
    /// Displays top occuring words
    /// - Parameter text: Top occuring words
    func setTopWords(_ text: String) {
        topWordsLabel.text = text
    }
    
    /// Assigns filter button press event publisher
    /// - Parameter publisher: Filter button press event publisher
    func setFilterButtonPressEventPublisher(_ publisher: PassthroughSubject<Void, Never>) {
        filterButtonPressEventPublisher = publisher
    }
    
    // MARK: - Private
    
    private func setUpSubviews() {
        addSubview(stackView)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10.0
        
        let labelsStackView = UIStackView()
        labelsStackView.axis = .vertical
        labelsStackView.alignment = .center
        stackView.addArrangedSubview(labelsStackView)
        
        labelsStackView.addArrangedSubview(topWordsTitleLabel)
        topWordsLabel.font = .systemFont(ofSize: 24.0, weight: .semibold)
        labelsStackView.addArrangedSubview(topWordsLabel)
        topWordsLabel.numberOfLines = 0

        let filterStackView = UIStackView()
        filterStackView.axis = .horizontal
        stackView.addArrangedSubview(filterStackView)
        
        filterStackView.addArrangedSubview(filterButton)
        filterButton.setTitleColor(.link, for: .normal)
        filterButton.layer.borderColor = UIColor.link.cgColor
        filterButton.layer.borderWidth = 2.0
        filterButton.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        filterButton.addTarget(self, action: #selector(onFilterButtonPress), for: .touchUpInside)
    }
    
    private func setUpConstraints() {
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            filterButton.widthAnchor.constraint(equalToConstant: 90.0),
            filterButton.heightAnchor.constraint(equalToConstant: 30.0)
        ])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10.0)
        ])
    }
    
    @objc
    private func onFilterButtonPress() {
        filterButtonPressEventPublisher?.send()
    }
}
