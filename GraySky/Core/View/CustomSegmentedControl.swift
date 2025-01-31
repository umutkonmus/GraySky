//
//  CustomSegmentedControl.swift
//  GraySky
//
//  Created by Umut Konmuş on 30.01.2025.
//

import UIKit

protocol CustomSegmentedControlDelegate: AnyObject {
    func segmentTapped(at index: Int)
}
class CustomSegmentedControl: UIView {

    weak var delegate: CustomSegmentedControlDelegate?

    private var segments: [String]
    private var selectedIndex: Int = 0
    private var indicatorView: UIView!
    private var segmentButtons: [UIButton] = []

    init(segments: [String]) {
        self.segments = segments
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        // Arka plan rengi (isteğe bağlı)
        backgroundColor = .systemGray6

        // Köşe yuvarlama (isteğe bağlı)
        layer.cornerRadius = 8
        layer.masksToBounds = true

        // Segment butonlarını oluştur
        for (index, segment) in segments.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(segment, for: .normal)
            button.setTitleColor(.gray, for: .normal)
            button.setTitleColor(.black, for: .selected)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.addTarget(self, action: #selector(segmentTapped(_:)), for: .touchUpInside)
            segmentButtons.append(button)
            addSubview(button)
        }

        // Gösterge çizgisini oluştur
        indicatorView = UIView()
        indicatorView.backgroundColor = .systemBlue // Çizgi rengi
        indicatorView.frame = CGRect(x: 0, y: frame.height - 2, width: 0, height: 2) // Başlangıç pozisyonu
        addSubview(indicatorView)
    }


    override func layoutSubviews() {
        super.layoutSubviews()

        let segmentWidth = frame.width / CGFloat(segments.count)
        for (index, button) in segmentButtons.enumerated() {
            button.frame = CGRect(x: CGFloat(index) * segmentWidth, y: 0, width: segmentWidth, height: frame.height)
        }

        // Gösterge çizgisinin genişliğini ayarla (ilk segment için)
        if indicatorView.frame.width == 0 {
             indicatorView.frame.size.width = segmentWidth
        }

    }

    @objc private func segmentTapped(_ sender: UIButton) {
        delegate?.segmentTapped(at: selectedIndex)
        guard let index = segmentButtons.firstIndex(of: sender) else { return }
        selectedIndex = index

        // Tüm butonların seçili durumunu sıfırla
        for button in segmentButtons {
            button.isSelected = false
        }

        // Tıklanan butonu seç
        sender.isSelected = true

        // Gösterge çizgisini hareket ettir ve animasyon ekle
        let segmentWidth = frame.width / CGFloat(segments.count)
        UIView.animate(withDuration: 0.3) {
            self.indicatorView.frame.origin.x = CGFloat(index) * segmentWidth
        }
    }

    // Segment başlıklarını değiştirme (isteğe bağlı)
    func updateSegments(newSegments: [String]) {
        self.segments = newSegments
        for (index, segment) in newSegments.enumerated() {
            segmentButtons[index].setTitle(segment, for: .normal)
        }
        setNeedsLayout() // Yeniden boyutlandırma için
    }
}
