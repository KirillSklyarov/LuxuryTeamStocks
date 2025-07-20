//
//  ViewController.swift
//  LuxuryTeamStocks
//
//  Created by Kirill Sklyarov on 19.07.2025.
//

import UIKit

final class MainViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var searchBar = SearchView()
    private lazy var categoryHeader = CategoryHeaderView()
    private lazy var contentTableView = StocksTableView()
    private lazy var searchPlaceholderCollectionView = SearchCollectionView()
    private lazy var activityIndicator = AppActivityIndicator()

    private lazy var contentStack = AppStackView([searchBar, categoryHeader, contentTableView], axis: .vertical, spacing: 5)

    var onAddToFavButtonTapped: ((StockModel) -> Void)?

    let viewModel: MainViewModelling

    // MARK: - Init
    init(viewModel: MainViewModelling) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewLoaded()
    }


    func configureUI() {
        view.backgroundColor = .systemBackground

        configureContentStack()
        setupSearchPlaceholder()
        configureActivityIndicator()
        setupDismissKeyboardGesture()
        setupAction()
    }

    func configureContentStack() {
        view.addSubviews(contentStack)
        contentStack.setConstraints(isSafeArea: true, allInsets: 16)
    }

    func setupSearchPlaceholder() {
        view.addSubviews(searchPlaceholderCollectionView)
        searchPlaceholderCollectionView.setConstraints(isSafeArea: true, allInsets: 16)
    }

    func setupAction() {
        categoryHeader.tabSelected = { [weak self] tag in
            self?.viewModel.tabSelected(tag)
        }

        contentTableView.onAddToFavButtonTapped = { [weak self] stock in
            self?.viewModel.addOrRemoveFromFavorites(stock)
        }

        contentTableView.onHideSearchBar = { [weak self] bool in
            guard let self else { return }
            UIView.animate(withDuration: 0.3) {
                self.searchBar.isNeedToHideSearchBar(bool)
                self.contentStack.layoutIfNeeded()
            }
        }

        searchBar.onTextChanged = { [weak self] text in
            guard let self else { return }
            viewModel.filterStocks(by: text)
        }
    }

    func configureActivityIndicator() {
        view.addSubviews(activityIndicator)
        setupActivityIndicatorLayout()
    }

    func setupActivityIndicatorLayout() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func setupInitialState() {
        configureUI()
    }

    func loading() {
        activityIndicator.startAnimating()
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            isHideContent(true)
        }
    }

    func isHideContent(_ isHide: Bool) {
        contentTableView.alpha = isHide ? 0 : 1
    }

    func configure(with data: [StockModel], _ isFavoritesChosen: Bool, animate: Bool = true) {

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            isHideContent(false)
        }

//        isHideContent(false)
        activityIndicator.stopAnimating()
        updateUI(with: data, isFavoritesChosen: isFavoritesChosen, animate: animate)
    }

    func updateUI(with data: [StockModel], isFavoritesChosen: Bool, animate: Bool) {
        contentTableView.updateUI(with: data, isFavoriteChosen: isFavoritesChosen, animate: animate)

    }
}

// MARK: - Error handler
extension MainViewController {
    func showError() {
        activityIndicator.stopAnimating()
        showAlert()
    }

    private func showAlert() {
        let alert = AppAlert.create()
        present(alert, animated: true)
    }
}


private extension MainViewController {
    func setupDismissKeyboardGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
