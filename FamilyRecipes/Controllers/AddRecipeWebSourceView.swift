//
//  AddRecipeWebSourceView.swift
//  FamilyRecipes
//
//  Created by Foster, Jake on 10/17/16.
//  Copyright © 2016 SideBuild. All rights reserved.
//

import UIKit

class AddRecipeWebSourceView: UIView, UITextFieldDelegate {
    //TODO: move these to a view
    private let urlLabel = UILabel()
    private let urlTextField = UITextField()

    var urlString: String {
        return urlTextField.text ?? ""
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        didLoad()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didLoad()
    }

    private func didLoad() {
        urlLabel.text = "Web Address"
        urlTextField.delegate = self
        urlTextField.borderStyle = .roundedRect
        urlTextField.keyboardType = .URL
        urlTextField.autocapitalizationType = .none
        setupViews()
    }

    private func setupViews() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = ViewConstants.StackSpacing
        stackView.distribution = .fill
        stackView.alignment = .fill
        addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        let urlStack = UIStackView()
        urlStack.axis = .horizontal
        urlStack.spacing = ViewConstants.StackSpacing
        urlStack.addArrangedSubview(urlLabel)
        urlStack.addArrangedSubview(urlTextField)
        stackView.addArrangedSubview(urlStack)
        urlTextField.widthAnchor.constraint(equalToConstant: ViewConstants.FieldWidth).isActive = true

        // add padding to gobble up the rest of the space at the bottom of the stack view
        let padding = UIView()
        padding.setContentHuggingPriority(1, for: .vertical)
        padding.setContentCompressionResistancePriority(1, for: .vertical)
        stackView.addArrangedSubview(padding)
    }

    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
