//
//  ViewController.swift
//  LuxuryTeamStocks
//
//  Created by Kirill Sklyarov on 19.07.2025.
//

import UIKit

final class MainViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var stockCategory = AppLabel(type: .category)
    private lazy var favoriteCategory = AppLabel(type: .category)

    private lazy var categoriesStackView = AppStackView([stockCategory, favoriteCategory, UIView()], axis: .horizontal, spacing: 20)

    private lazy var contentTableView = StocksTableView()

    private lazy var contentStackView = AppStackView([categoriesStackView, contentTableView], axis: .vertical, spacing: 20)

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
        view.backgroundColor = .systemRed
        configureContentStackView()
        configureActivityIndicator()
    }

    func configureContentStackView() {
        categoryStackConfigure()

        view.addSubviews(contentStackView)
        contentStackView.setConstraints(isSafeArea: true, allInsets: 20)
    }

    func categoryStackConfigure() {
        stockCategory.text = "Stocks"
        favoriteCategory.text = "Favorites"
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

    func loading() {
        activityIndicator.startAnimating()
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            isHideContent(true)
        }
    }

    func isHideContent(_ isHide: Bool) {
        contentStackView.alpha = isHide ? 0 : 1
//        switch isHide {
//        case true:
//            contentStackView.alpha = 0
//        case false:
//            contentStackView.alpha = 1
//        }
    }

}

//MARK: - SwiftUI
import SwiftUI
struct MyProvider : PreviewProvider {
    static var previews: some View {
        ContainterView().edgesIgnoringSafeArea(.all)
    }

    struct ContainterView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            return MainViewController(viewModel: MainViewModel())
        }

        typealias UIViewControllerType = UIViewController


        let viewController = MainViewController(viewModel: MainViewModel())
        func makeUIViewController(context: UIViewControllerRepresentableContext<MyProvider.ContainterView>) -> MainViewController {
            return viewController
        }

        func updateUIViewController(_ uiViewController: MyProvider.ContainterView.UIViewControllerType, context: UIViewControllerRepresentableContext<MyProvider.ContainterView>) {

        }
    }
}

