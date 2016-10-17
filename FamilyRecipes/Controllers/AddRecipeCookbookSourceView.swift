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
    private let addCookbookButton = UIButton(type: .roundedRect)
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

        cookbookTextField.inputView = cookbookPicker
        cookbookTextField.borderStyle = .roundedRect
        cookbookTextField.tintColor = UIColor.clear

        addCookbookButton.setTitle("Add Cookbook", for: .normal)
        addCookbookButton.addTarget(self, action: #selector(AddRecipeCookbookSourceView.addCookbookTouched), for: .touchUpInside)

        pageNumberLabel.text = "Page Number"

        pageNumberField.delegate = self
        pageNumberField.borderStyle = .roundedRect
        pageNumberField.keyboardType = .numberPad
        
        setupViews()
    }

    private func setupViews() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.alignment = .fill
        addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        stackView.addArrangedSubview(cookbookLabel)
        stackView.addArrangedSubview(cookbookTextField)
        stackView.addArrangedSubview(addCookbookButton)
        stackView.addArrangedSubview(pageNumberLabel)
        stackView.addArrangedSubview(pageNumberField)

        // add padding to gobble up the rest of the space at the bottom of the stack view
        let padding = UIView()
        padding.setContentHuggingPriority(1, for: .vertical)
        padding.setContentCompressionResistancePriority(1, for: .vertical)
        stackView.addArrangedSubview(padding)
    }

    @objc private func addCookbookTouched() {
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
