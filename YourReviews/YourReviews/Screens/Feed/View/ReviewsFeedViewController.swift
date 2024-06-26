import Combine
import UIKit

/// Reviews feed screen
final class ReviewsFeedViewController: UIViewController {
    
    // MARK: - Model
    
    private typealias CellModel = ReviewsFeedViewModel.ReviewCellModel
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, CellModel>
    private typealias SearchResultCellRegistration = UICollectionView.CellRegistration<ReviewCell, CellModel>
    
    // MARK: - Events
    
    private let pullToRefreshEventPublisher = PassthroughSubject<Void, Never>()
    private let cellSelectionEventPublisher = PassthroughSubject<CellModel, Never>()
    
    // MARK: - Properties
    
    private let headerView = ReviewsFeedHeaderView()
    
    private lazy var dataSource: DataSource = createDataSource()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    private let sectionHeaderElementKind = "ReviewsFeedViewController.sectionHeaderElementKind"
    
    private var subscriptions: [AnyCancellable] = []
    
    private let viewModel: ReviewsFeedViewModel
    
    // MARK: - Initialisers
    
    /// Designated initialiser
    /// - Parameter viewModel: Reviews feed view model
    init(viewModel: ReviewsFeedViewModel) {
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
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerView.layer.shadowColor = UIColor.systemGray.cgColor
        headerView.layer.shadowOpacity = 0.2
        headerView.layer.shadowOffset = CGSize(width: 0, height: 3)
        headerView.layer.shadowRadius = 1
        headerView.layer.shadowPath = UIBezierPath(rect: headerView.bounds).cgPath
    }
    
    // MARK: - Private
    
    private func setUpSubviews() {
        view.addSubview(headerView)
        
        view.addSubview(collectionView)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    private func setUpConstraints() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setUpBindings() {
        viewModel.subscribeToPullToRefreshEvent(pullToRefreshEventPublisher.eraseToAnyPublisher())
        viewModel.subscribeToCellSelectionEvent(cellSelectionEventPublisher.eraseToAnyPublisher())
        
        subscriptions = [
            viewModel.refreshEndEventPublisher.receive(on: DispatchQueue.main).sink { [collectionView] in
                collectionView.refreshControl?.endRefreshing()
            },
            viewModel.alertEventPublisher.receive(on: DispatchQueue.main).sink { [weak self] model in
                self?.showAlert(model.title, model.mesage, model.action)
            },
            viewModel.$header.receive(
                on: DispatchQueue.main
            ).compactMap {
                $0
            }.sink { [headerView] model in
                headerView.setFilterButtonTitle(model.filterButtonTitle)
                headerView.setTopWordsTitle(model.topWordsTitle)
                headerView.setTopWords(model.topWords)
                headerView.setFilterButtonPressEventPublisher(model.filterButtonPressEventPublisher)
            },
            viewModel.$reviews.receive(on: DispatchQueue.main).sink { [dataSource] reviews in
                var snapshot = NSDiffableDataSourceSnapshot<Int, CellModel>()
                snapshot.appendSections([0])
                snapshot.appendItems(reviews, toSection: 0)

                dataSource.apply(snapshot)
            }
        ]
    }
    
    private func createDataSource() -> DataSource {
        let cellRegistration = SearchResultCellRegistration { cell, _, model in
            cell.setRating(model.rating)
            cell.setAuthor(model.author)
            cell.setTitle(model.title)
            cell.setReview(model.review)
        }
        
        let result = DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        return result
    }
    
    private func createLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.backgroundColor = .clear
        
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    private func showAlert(_ title: String, _ message: String, _ dismissButtonTitle: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: dismissButtonTitle, style: .default))
        present(alertController, animated: true, completion: nil)
    }
    
    @objc
    private func onRefresh(_ sender: UIRefreshControl) {
        pullToRefreshEventPublisher.send()
    }
}

// MARK: - UICollectionViewDelegate

extension ReviewsFeedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let model = dataSource.itemIdentifier(for: indexPath) {
            cellSelectionEventPublisher.send(model)
        }
    }
}
