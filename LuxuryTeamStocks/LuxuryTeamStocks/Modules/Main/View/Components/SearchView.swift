//
//  SearchView.swift
//  LuxuryTeamStocks
//
//  Created by Kirill Sklyarov on 19.07.2025.
//

import UIKit

final class SearchView: UIView {

    // MARK: - Properties
    private lazy var roundContainer: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.setBorder(AppConstants.Colors.black, borderWidth: 1)
        view.backgroundColor = .clear
        return view
    }()
    private lazy var glassImageView = AppImageView(type: .glass)
    private lazy var glassImageContainer: UIView = {
        let view = UIView()
        view.addSubviews(glassImageView)
        glassImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            glassImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            glassImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        view.widthAnchor.constraint(equalToConstant: 20).isActive = true
         view.backgroundColor = .clear
        return view
    }()

    private let textField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Find company or ticker",
            attributes: [
                .foregroundColor: AppConstants.Colors.black,
                .font: AppConstants.Fonts.searchBar ?? .boldSystemFont(ofSize: 30)
            ])
        textField.clearButtonMode = .never
        textField.font = AppConstants.Fonts.searchBar
        textField.tintColor = AppConstants.Colors.black
        textField.backgroundColor = .clear
        return textField
    }()

    private lazy var clearTextButton = AppButton(style: .textFieldClear, isSelected: false)

    private lazy var clearButtonContainer: UIView = {
        let view = UIView()
        view.addSubviews(clearTextButton)
        clearTextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            clearTextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            clearTextButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        return view
    }()

    private lazy var searchStackView = AppStackView([glassImageContainer, textField], axis: .horizontal, spacing: 10)

    private var searchHeightConstraint: NSLayoutConstraint!

    var onTextChanged: ((String) -> Void)?
    var onBeginEditing: (() -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        roundContainer.layer.cornerRadius = roundContainer.frame.height / 2
        clearButtonContainer.widthAnchor.constraint(equalToConstant: 30).isActive = true
        searchStackView.heightAnchor.constraint(equalTo: roundContainer.heightAnchor, multiplier: 0.8).isActive = true
    }

    func isNeedToHideSearchBar(_ bool: Bool) {
        searchHeightConstraint.constant = bool ? 0 : 48
    }

    func setQueryText(_ text: String) {
        textField.text = text
    }
}

// MARK: - UITextFieldDelegate
extension SearchView: UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        showOrHideClearTextFieldButton(text)
        onTextChanged?(textField.text ?? "")
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideClearTextFieldButton()

        textField.placeholder = ""
        changeLeftImage(.leftArrow)
        onBeginEditing?()
    }
}

// MARK: - Supporting methods
private extension SearchView {
    func showOrHideClearTextFieldButton(_ text: String) {
        !text.isEmpty ? showClearTextFieldButton() : hideClearTextFieldButton()
    }

    func hideClearTextFieldButton() {
        textField.rightView = nil
        textField.rightViewMode = .never
    }

    func showClearTextFieldButton() {
        textField.rightView = clearButtonContainer
        textField.rightViewMode = .whileEditing
    }

    enum LeftImages: String {
        case glass
        case leftArrow
    }

    func changeLeftImage(_ imageType: LeftImages) {
        glassImageView.image = UIImage(named: imageType.rawValue)
        let tap = UITapGestureRecognizer(target: self, action: #selector(backToTableView))
        glassImageContainer.addGestureRecognizer(tap)
    }

    @objc  func backToTableView() {
        exitSearchMode()
    }
}

// MARK: - Private methods
private extension SearchView {
    func setupUI() {
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField.rightView = clearButtonContainer
        textField.delegate = self

        configureGlassImageView()

        addSubviews(roundContainer)
        roundContainer.setConstraints()

        searchHeightConstraint = heightAnchor.constraint(equalToConstant: 48)
        searchHeightConstraint.isActive = true

    }

    func configureGlassImageView() {
        roundContainer.addSubviews(searchStackView)
        NSLayoutConstraint.activate([
            searchStackView.centerYAnchor.constraint(equalTo: roundContainer.centerYAnchor),
            searchStackView.leadingAnchor.constraint(equalTo: roundContainer.leadingAnchor, constant: 16),
            searchStackView.trailingAnchor.constraint(equalTo: roundContainer.trailingAnchor, constant: -16),
        ])
    }

    func setupActions() {
        clearTextButton.onClearTextButtonTapped = { [weak self] in
            guard let self else { return }
            exitSearchMode()
        }
    }

    func exitSearchMode() {
        textField.resignFirstResponder()
        textField.text = ""
        textField.placeholder = "Find company or ticker"
        changeLeftImage(.glass)
        onTextChanged?(textField.text ?? "")
    }
}
