//
//  ProfileImageView.swift
//  GraySky
//
//  Created by Umut Konmuş on 6.01.2025.
//

import UIKit

class ProfileImageView: UIImageView {
    
    // Bu sınıfı initialize ettiğinizde otomatik olarak yuvarlak maskeyi ve border'ı uygular.
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProfileImageView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupProfileImageView()
    }
    
    // Profile ImageView için gerekli ayarları yapıyoruz
    private func setupProfileImageView() {
        // Yuvarlak yapalım
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
        
        // Arka plan rengi varsa border rengini ona göre ayarlayalım
        if let backgroundColor = self.backgroundColor {
            self.layer.borderColor = backgroundColor.cgColor
        } else {
            self.layer.borderColor = UIColor.systemBackground.cgColor // Varsayılan arka plan rengi
        }
        
        // Border genişliğini ayarlayalım (isteğe bağlı)
        //self.layer.borderWidth = 2.0
    }
    
    // Border genişliğini güncelleyebilmek için bir fonksiyon ekleyelim
    func updateBorderWidth(_ width: CGFloat) {
        self.layer.borderWidth = width
    }
}
