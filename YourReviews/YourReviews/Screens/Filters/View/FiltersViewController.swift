import Combine
import UIKit

final class FiltersViewController: UIViewController {
    
    // MARK: - Events
    
    private let starImageSelectionEventPublisher = PassthroughSubject<Int, Never>()
    private let applyButtonPressEventPublisher = PassthroughSubject<Void, Never>()
    
    // MARK: - Properties
        
    private let numberOfStarsTitleLabel = UILabel()
    private let starsStackView = UIStackView()
    private let applyButton = UIButton()
    
    private var subscriptions: [AnyCancellable] = []
    private let viewModel: FiltersViewModel
    
    // MARK: - Initialisers
    
    init(viewModel: FiltersViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        preferredContentSize = CGSize(width: super.preferredContentSize.width, height: 200.0)
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
    
    // MARK: - Private
    
    private func setUpSubviews() {
        view.addSubview(numberOfStarsTitleLabel)
        numberOfStarsTitleLabel.font = .systemFont(ofSize: 24.0)
        
        view.addSubview(starsStackView)
        starsStackView.axis = .horizontal
        
        view.addSubview(applyButton)
        applyButton.backgroundColor = .systemBlue
        applyButton.clipsToBounds = true
        applyButton.layer.cornerRadius = 8.0
        applyButton.setTitle(viewModel.applyButtonTitle, for: .normal)
        applyButton.addTarget(self, action: #selector(onApplyButtonPress), for: .touchUpInside)
    }
    
    private func setUpConstraints() {
        numberOfStarsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            numberOfStarsTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16.0),
            numberOfStarsTitleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            numberOfStarsTitleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0)
        ])
        
        starsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            starsStackView.topAnchor.constraint(equalTo: numberOfStarsTitleLabel.bottomAnchor, constant: 16.0),
            starsStackView.leadingAnchor.constraint(equalTo: numberOfStarsTitleLabel.leadingAnchor),
            starsStackView.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0)
        ])
        
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            applyButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            applyButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0),
            applyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16.0),
            applyButton.heightAnchor.constraint(equalToConstant: 50.0)
        ])
    }
    
    private func setUpBindings() {
        viewModel.subscribeToStarSelectionEvent(starImageSelectionEventPublisher.eraseToAnyPublisher())
        viewModel.subscribeToApplyButtonPressEvent(applyButtonPressEventPublisher.eraseToAnyPublisher())
        
        subscriptions = [
            viewModel.$starsFilterModel.receive(on: DispatchQueue.main).sink { [weak self] model in
                guard let self else { return }
                
                self.numberOfStarsTitleLabel.text = model.title
                self.starsStackView.arrangedSubviews.forEach {
                    self.starsStackView.removeArrangedSubview($0)
                    $0.removeFromSuperview()
                }
                
                model.stars.forEach {
                    self.addImage(with: $0, to: self.starsStackView)
                }
            }
        ]
    }
    
    private func addImage(with model: FiltersViewModel.StarsFilterModel.StarModel, to stackView: UIStackView) {
        let image = UIImage(systemName: model.isFilled ? "star.fill" : "star")
        let imageView = UIImageView(image: image)
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onStarImageViewPress(_:))))
        stackView.addArrangedSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 30.0),
            imageView.heightAnchor.constraint(equalToConstant: 30.0)
        ])
    }
    
    @objc
    private func onStarImageViewPress(_ recognizer: UITapGestureRecognizer) {
        if let view = recognizer.view, let index = starsStackView.arrangedSubviews.firstIndex(of: view) {
            starImageSelectionEventPublisher.send(index)
        }
    }
    
    @objc
    private func onApplyButtonPress() {
        applyButtonPressEventPublisher.send()
    }
}
