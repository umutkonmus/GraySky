//
//  SearchViewController.swift
//  GraySky
//
//  Created by Umut Konmuş on 31.01.2025.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var trendForYouLabel: UILabel!
    @IBOutlet weak var noNewTrendsForYouLabel: UILabel!
    @IBOutlet weak var nothingToShowLabel: UILabel!
    @IBOutlet weak var changeLocationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    func setupView() {
        setupChangeLocationButton()
        setupNavigationBar()
    }
    
    func setupChangeLocationButton() {
        changeLocationButton.setTitle("Change Location", for: .normal)
        changeLocationButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        changeLocationButton.tintColor = .white
        changeLocationButton.backgroundColor = ThemeManager.primaryColor
        changeLocationButton.layer.borderColor = ThemeManager.primaryColor.cgColor
        changeLocationButton.layer.borderWidth = 1
        changeLocationButton.layer.cornerRadius = 16
    }
    
    func setupNavigationBar(){
        let appIconImageView = UIImageView(image: UIImage(named: "graysky"))
        appIconImageView.contentMode = .scaleAspectFit

        // Auto layout
        appIconImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            appIconImageView.widthAnchor.constraint(equalToConstant: 22),
            appIconImageView.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        
        let settingsButton = UIButton(type: .custom)
        settingsButton.setImage(UIImage(named: "SettingsStrokeIcon"), for: .normal)
        settingsButton.contentMode = .scaleAspectFit
        
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingsButton.widthAnchor.constraint(equalToConstant: 27),
            settingsButton.heightAnchor.constraint(equalToConstant: 27)
        ])
       
        settingsButton.addTarget(self, action: #selector(settingsClicked), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settingsButton)
        self.navigationItem.titleView = appIconImageView
        //self.navigationItem.leftBarButtonItem = profileButton
    }
    
    @objc func settingsClicked(){
        print("Settings clicked")
    }
}
