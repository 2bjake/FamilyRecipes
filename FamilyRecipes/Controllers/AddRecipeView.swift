//
//  AddRecipeView.swift
//  FamilyRecipes
//
//  Created by Foster, Jake on 10/14/16.
//  Copyright © 2016 SideBuild. All rights reserved.
//

import UIKit

protocol AddRecipeViewDelegate {
    func addRecipeDone()
    func addRecipeCancel()
    func recipeSourceValues() -> [String]
    func recipeSourceIndexChanged(_ newIndex: Int)
}

class AddRecipeView: UIView, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    private let nameLabel = UILabel()
    private let nameTextField = UITextField()
    private let sourceLabel = UILabel()
    private let sourceTextField = UITextField()
    private let sourcePicker = UIPickerView()

    var recipeName: String {
        return nameTextField.text ?? ""
    }

    var delegate : AddRecipeViewDelegate? {
        didSet {
            sourceTextField.text = delegate?.recipeSourceValues()[recipeSourceIndex]
        }
    }

    var recipeSourceIndex = 0 {
        didSet {
            sourceTextField.text = delegate?.recipeSourceValues()[recipeSourceIndex]
            delegate?.recipeSourceIndexChanged(recipeSourceIndex)
        }
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
        backgroundColor = UIColor.white

        sourcePicker.delegate = self
        sourcePicker.dataSource = self

        nameLabel.text = "Recipe name"
        nameTextField.delegate = self
        nameTextField.borderStyle = .roundedRect
        sourceLabel.text = "Source"

        sourceTextField.inputView = sourcePicker
        sourceTextField.borderStyle = .roundedRect
        sourceTextField.tintColor = UIColor.clear

        setupViews()
    }

    private func setupViews() {
        let navBar = createNavBar()
        addSubview(navBar)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.topAnchor.constraint(equalTo: topAnchor).isActive = true
        navBar.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        navBar.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        navBar.heightAnchor.constraint(equalToConstant: 65).isActive = true

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true

        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(sourceLabel)
        stackView.addArrangedSubview(sourceTextField)

        //TODO: instead of this, put this and the detail view inside another stack frame?
        let elementHeight = nameLabel.frame.height + nameTextField.frame.height + sourceLabel.frame.height + sourceTextField.frame.height
        stackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: elementHeight + stackView.spacing * 3)
    }

    private func createNavBar() -> UINavigationBar {
        let navBar = UINavigationBar()
        let navItem = UINavigationItem(title: "Add Recipe")
        navItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTouched))
        navItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTouched))
        navBar.pushItem(navItem, animated: false)
        return navBar
    }

    @objc private func doneTouched() {
        delegate?.addRecipeDone()
    }

    @objc private func cancelTouched() {
        delegate?.addRecipeCancel()
    }

    func setRecipeSourceView(_ recipeSourceView: UIView) {
        let anchor = subviews.last!.bottomAnchor

        addSubview(recipeSourceView)
        recipeSourceView.translatesAutoresizingMaskIntoConstraints = false
        recipeSourceView.topAnchor.constraint(equalTo: anchor, constant: 8).isActive = true
        recipeSourceView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
        recipeSourceView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        recipeSourceView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        setNeedsDisplay()
    }

    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // MARK: - UIPickerView Delegate & DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return delegate?.recipeSourceValues().count ?? 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return delegate?.recipeSourceValues()[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("source \(delegate?.recipeSourceValues()[row]) was selected") //TODO: remove me
        recipeSourceIndex = row
        endEditing(true)
    }
}
