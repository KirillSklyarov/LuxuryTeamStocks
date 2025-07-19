//
//  ViewController.swift
//  LuxuryTeamStocks
//
//  Created by Kirill Sklyarov on 19.07.2025.
//

import UIKit

final class MainViewController: UIViewController {

    // MARK: - UI Properties
//    private lazy var stockCategory = AppLabel(type: .category)
//    private lazy var favoriteCategory = AppLabel(type: .category)
//
//    private lazy var categoriesStackView = AppStackView([stockCategory, favoriteCategory, UIView()], axis: .horizontal, spacing: 20)

    private lazy var contentTableView = StocksTableView()

//    private lazy var contentStackView = AppStackView([categoriesStackView, contentTableView], axis: .vertical, spacing: 20)

    private lazy var activityIndicator = AppActivityIndicator()

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
//        configureUI()
    }

    func setupInitialState() {
        configureUI()
    }

    func configureUI() {
        view.backgroundColor = .systemBackground
        configureContentStackView()
        configureActivityIndicator()
        setupAction()
    }

    func configureContentStackView() {
//        categoryStackConfigure()

        view.addSubviews(contentTableView)
        contentTableView.setConstraints(isSafeArea: true, allInsets: 20)
    }

    func setupAction() {
        contentTableView.tabSelected = { [weak self] tag in
            self?.viewModel.tabSelected(tag)
        }
    }

//    func categoryStackConfigure() {
//        stockCategory.text = "Stocks"
//        favoriteCategory.text = "Favorites"
//    }

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

    func loading() {
        activityIndicator.startAnimating()
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            isHideContent(true)
        }
    }

    func isHideContent(_ isHide: Bool) {
        contentTableView.alpha = isHide ? 0 : 1

//        switch isHide {
//        case true:
//            contentStackView.alpha = 0
//        case false:
//            contentStackView.alpha = 1
//        }
    }

    func configure(with data: [StockModel], _ isFavoritesChosen: Bool) {
        print(#function)

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            isHideContent(false)
        }

//        isHideContent(false)
        activityIndicator.stopAnimating()
        updateUI(with: data, isFavoritesChosen: isFavoritesChosen)
    }

    func updateUI(with data: [StockModel], isFavoritesChosen: Bool) {
        print(#function)
        contentTableView.updateUI(with: data, isFavoriteChosen: isFavoritesChosen)
    }

}

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
