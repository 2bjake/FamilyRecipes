//
//  AddRecipeCookbookSourceView.swift
//  FamilyRecipes
//
//  Created by Foster, Jake on 10/14/16.
//  Copyright © 2016 SideBuild. All rights reserved.
//

import UIKit

protocol AddRecipeCookbookSourceViewDelegate {
    func cookbookValues() -> [Cookbook]
    func addCookbookTouched(addCompletion: @escaping (Cookbook) -> Void)
}

class AddRecipeCookbookSourceView: UIView, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    private let cookbookLabel = UILabel()
    private let cookbookTextField = UITextField()
    private let cookbookPicker = UIPickerView()
    private let pageNumberLabel = UILabel()
    private let pageNumberField = UITextField()

    var delegate : AddRecipeCookbookSourceViewDelegate?

    var cookbook : Cookbook? {
        let index = cookbookPicker.selectedRow(inComponent: 0)
        return delegate?.cookbookValues()[index]
    }

    var pageNumber : String {
        return pageNumberField.text ?? ""
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
        cookbookLabel.text = "Cookbook Name"

        cookbookPicker.dataSource = self
        cookbookPicker.delegate = self

        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        let addButton = UIBarButtonItem()
        addButton.target = self
        addButton.action = #selector(AddRecipeCookbookSourceView.addCookbookTouched)
        addButton.title = "Add new cookbook"
        toolBar.setItems([addButton], animated: false)

        cookbookTextField.inputView = cookbookPicker
        cookbookTextField.inputAccessoryView = toolBar
        cookbookTextField.borderStyle = .roundedRect
        cookbookTextField.tintColor = UIColor.clear

        pageNumberLabel.text = "Page Number"

        pageNumberField.delegate = self
        pageNumberField.borderStyle = .roundedRect
        pageNumberField.keyboardType = .numberPad
        
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

        let cookbookStack = UIStackView()
        cookbookStack.axis = .horizontal
        cookbookStack.spacing = ViewConstants.StackSpacing
        cookbookStack.addArrangedSubview(cookbookLabel)
        cookbookStack.addArrangedSubview(cookbookTextField)
        stackView.addArrangedSubview(cookbookStack)
        cookbookTextField.widthAnchor.constraint(equalToConstant: ViewConstants.FieldWidth).isActive = true

        let pageNumStack = UIStackView()
        pageNumStack.axis = .horizontal
        pageNumStack.spacing = ViewConstants.StackSpacing
        pageNumStack.addArrangedSubview(pageNumberLabel)
        pageNumStack.addArrangedSubview(pageNumberField)
        pageNumberField.widthAnchor.constraint(equalToConstant: ViewConstants.FieldWidth).isActive = true
        stackView.addArrangedSubview(pageNumStack)

        // add padding to gobble up the rest of the space at the bottom of the stack view
        let padding = UIView()
        padding.setContentHuggingPriority(1, for: .vertical)
        padding.setContentCompressionResistancePriority(1, for: .vertical)
        stackView.addArrangedSubview(padding)
    }

    @objc private func addCookbookTouched() {
        endEditing(true)
        delegate?.addCookbookTouched { cookbook in
            self.cookbooksUpdated()
            let index = self.delegate?.cookbookValues().index(of: cookbook)
            self.cookbookPicker.selectRow(index ?? 0, inComponent: 0, animated: false)
            self.updateCookbookTextField()
        }
    }

    private func updateCookbookTextField() {
        let index = cookbookPicker.selectedRow(inComponent: 0)
        cookbookTextField.text = delegate?.cookbookValues()[index].name
    }

    func cookbooksUpdated() {
        if let cookbooks = delegate?.cookbookValues() {
            if cookbooks.count == 0 {
                cookbookPicker.isHidden = true
            } else {
                cookbookPicker.isHidden = false
                cookbookPicker.reloadAllComponents()
                updateCookbookTextField()
            }
        }
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
        return delegate?.cookbookValues().count ?? 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return delegate?.cookbookValues()[row].name
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("cookbook \(delegate?.cookbookValues()[row].name) was selected") //TODO: remove me
        updateCookbookTextField()
        endEditing(true)
    }

}
