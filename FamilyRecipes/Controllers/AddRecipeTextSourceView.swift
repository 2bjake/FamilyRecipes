//
//  AddRecipeTextSourceView.swift
//  FamilyRecipes
//
//  Created by Foster, Jake on 10/17/16.
//  Copyright © 2016 SideBuild. All rights reserved.
//

import UIKit

class AddRecipeTextSourceView: UIView {
    private let recipeTextLabel = UILabel()
    private let recipeTextView = UITextView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        didLoad()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didLoad()
    }

    var recipeText: String {
        return recipeTextView.text
    }

    private func didLoad() {
        recipeTextLabel.text = "Recipe Text"
        setupView()
    }

    private func setupView() {
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

        stackView.addArrangedSubview(recipeTextLabel)
        stackView.addArrangedSubview(recipeTextView)
        recipeTextView.setContentHuggingPriority(1, for: .vertical)
        recipeTextView.setContentCompressionResistancePriority(1, for: .vertical)
        recipeTextView.layer.borderColor = UIColor.lightGray.cgColor
        recipeTextView.layer.borderWidth = 0.33
        recipeTextView.layer.cornerRadius = 5
    }
}
