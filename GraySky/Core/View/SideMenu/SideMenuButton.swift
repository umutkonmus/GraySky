//
//  SideMenuButton.swift
//  GraySky
//
//  Created by Umut Konmuş on 21.01.2025.
//

import UIKit

class SideMenuButton: UIButton {
    private let iconImageView = UIImageView()
    private let customTitle = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        // Icon ImageView
        iconImageView.contentMode = .scaleToFill
        addSubview(iconImageView)

        // Label
        customTitle.textAlignment = .left
        customTitle.font = UIFont.systemFont(ofSize: 18)
        customTitle.textColor = .label
        addSubview(customTitle)

        // Constraints
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        customTitle.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            customTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            customTitle.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 22),
            customTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22)
        ])
    }

    func configure(icon: UIImage?, title: String) {
        iconImageView.image = icon
        customTitle.text = title
    }
}
