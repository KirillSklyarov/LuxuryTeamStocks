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

    private lazy var searchHeaderView = SearchHeaderView()

    private lazy var contentTableView = StocksTableView()
    private lazy var searchPlaceholderCollectionView = SearchCollectionView()
    private lazy var activityIndicator = AppActivityIndicator()

    private lazy var headerAndTableViewStack = AppStackView([ categoryHeader, contentTableView], axis: .vertical)

    private lazy var contentStack = AppStackView([searchBar, headerAndTableViewStack], axis: .vertical, spacing: 20)

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
        searchPlaceholderCollectionView.alpha = 0

        NSLayoutConstraint.activate([
            searchPlaceholderCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 32),
            searchPlaceholderCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchPlaceholderCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchPlaceholderCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func setupAction() {
        categoryHeader.tabSelected = { [weak self] tag in
            self?.viewModel.eventHandler(.categoryChanged(tag))
        }

        contentTableView.onAddToFavButtonTapped = { [weak self] stock in
            self?.viewModel.eventHandler(.addToFavoriteButtonTapped(stock))
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
            swapHeaders(with: text)
            hideSearchPlaceholder()

            viewModel.eventHandler(.filteringModeStarted(text))
        }

        searchBar.onBeginEditing = { [weak self] in
            guard let self else { return }
            showSearchPlaceholder()
        }

        searchPlaceholderCollectionView.onCellTapped = { [weak self]
            stockName in
            guard let self else { return }
            searchBar.setQueryText(stockName)

            swapHeaders(with: stockName)
            hideSearchPlaceholder()

            viewModel.eventHandler(.filteringModeStarted(stockName))
        }

        searchHeaderView.onShowMoreButtonTapped = { [weak self] in
            self?.viewModel.eventHandler(.showMoreButtonTapped)
        }
    }

    private func swapHeaders(with text: String) {
        if !text.isEmpty {
            swapHeadersToSearching()
        } else {
            swapHeadersToBaseMode()
        }
    }

    private func swapHeadersToSearching() {
        guard let index = headerAndTableViewStack.arrangedSubviews.firstIndex(of: self.categoryHeader) else { return }
        headerAndTableViewStack.removeArrangedSubview(categoryHeader)
        categoryHeader.removeFromSuperview()
        headerAndTableViewStack.insertArrangedSubview(self.searchHeaderView, at: index)

        contentStack.spacing = 32
    }

    private func swapHeadersToBaseMode() {
        guard let index = headerAndTableViewStack.arrangedSubviews.firstIndex(of: self.searchHeaderView) else { print("stockTitle not found"); return }
        headerAndTableViewStack.removeArrangedSubview(searchHeaderView)
        searchHeaderView.removeFromSuperview()
        headerAndTableViewStack.insertArrangedSubview(self.categoryHeader, at: index)
        contentStack.spacing = 20
    }

    private func showSearchPlaceholder() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            searchPlaceholderCollectionView.alpha = 1
            [categoryHeader, contentTableView].forEach { $0.alpha = 0 }
        }
    }

    private func hideSearchPlaceholder() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            searchPlaceholderCollectionView.alpha = 0
            [categoryHeader, contentTableView].forEach { $0.alpha = 1 }
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

    func configure(with data: [StockModel], _ isFavoritesChosen: Bool, _ isFilteringMode: Bool, animate: Bool = true) {

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            isHideContent(false)
        }

        activityIndicator.stopAnimating()
        updateUI(with: data, isFavoritesChosen: isFavoritesChosen, isFilteringMode: isFilteringMode, animate: animate)
    }

    func updateUI(with data: [StockModel], isFavoritesChosen: Bool, isFilteringMode: Bool, animate: Bool) {
        contentTableView.updateUI(with: data, isFavoriteChosen: isFavoritesChosen, isFilteringMode: isFilteringMode, animate: animate)

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

// MARK: - Hide the keeboard
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
