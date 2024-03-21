import Combine
import UIKit

final class ReviewsListViewController: UIViewController {
    
    // MARK: - Model
    
    private typealias CellModel = ReviewsListViewModel.ReviewCellModel
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, CellModel>
    private typealias SearchResultCellRegistration = UICollectionView.CellRegistration<ReviewCell, CellModel>
    private typealias SearchResultsHeaderRegistration = UICollectionView.SupplementaryRegistration<ReviewListHeaderView>
    
    // MARK: - Events
    
    private let cellSelectionEventPublisher = PassthroughSubject<CellModel, Never>()
    
    // MARK: - Properties
    
    private lazy var dataSource: DataSource = createDataSource()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    private let sectionHeaderElementKind = "ReviewsListViewController.sectionHeaderElementKind"
    
    private var subscriptions: [AnyCancellable] = []
    
    private let viewModel: ReviewsListViewModel
    
    // MARK: - Initialisers
    
    init(viewModel: ReviewsListViewModel) {
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
    
    // MARK: - Private
    
    private func setUpSubviews() {
        view.addSubview(collectionView)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
    }
    
    private func setUpConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setUpBindings() {
        viewModel.subscribeOnCellSelectionEvent(cellSelectionEventPublisher.eraseToAnyPublisher())
        
        subscriptions = [
            viewModel.$header.receive(on: DispatchQueue.main).sink { [collectionView] _ in
                collectionView.reloadData()
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
        let headerRegistration = SearchResultsHeaderRegistration(elementKind: sectionHeaderElementKind) { [weak self] header, _, _ in
            guard let model = self?.viewModel.header else { return }
            
            header.setFilterTitle(model.filterTitle)
            header.setTopWordsTitle(model.topWordsTitle)
            header.setTopWords(model.topWords)
            header.setFilterButtonPressEventPublisher(model.filterButtonPressEventPublisher)
        }
        
        let cellRegistration = SearchResultCellRegistration { cell, _, model in
            cell.setRating(model.rating)
            cell.setAuthor(model.author)
            cell.setTitle(model.title)
            cell.setReview(model.review)
        }
        
        let result = DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        result.supplementaryViewProvider = { view, _, index in
            return view.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
        }
        
        return result
    }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout() { [sectionHeaderElementKind] sectionIndex, layoutEnvironment in
            var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
            configuration.headerMode = .supplementary
            configuration.backgroundColor = .clear
            
            let section = NSCollectionLayoutSection.list(
                using: configuration,
                layoutEnvironment: layoutEnvironment
            )
            
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(61.0)
            )
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: sectionHeaderElementKind,
                alignment: .top
            )
            sectionHeader.pinToVisibleBounds = true
            section.boundarySupplementaryItems = [sectionHeader]
            
            return section
        }
    }
}

// MARK: - UICollectionViewDelegate

extension ReviewsListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let model = dataSource.itemIdentifier(for: indexPath) {
            cellSelectionEventPublisher.send(model)
        }
    }
}
