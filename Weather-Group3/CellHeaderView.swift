//
//  CellHeaderView.swift
//  Weather-Group3
//
//  Created by Woojun Lee on 2023/09/27.
//

import UIKit

protocol CellHeaderViewDelegate: AnyObject {
    func cellHeaderViewTapped(sectionIndex: Int)
}

class CellHeaderView: UICollectionReusableView {
    
    static let identifier = "CellHeaderView"
    
    var delegate: CellHeaderViewDelegate?
    
    var sectionIndex: Int?
    
    private let iconImageView: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(systemName: "calendar")
        return iv
    }()
    
    private let label: UILabel = {
       let label = UILabel()
        label.text = "10-DAY FORECAST"
        
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        addGesture()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubviews()
        configureIconImageView()
        configureLabel()
    }
    
    @objc func tapped() {
        delegate?.cellHeaderViewTapped(sectionIndex: sectionIndex!)
    }
    
    private func addGesture() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
    }
    
    private func addSubviews() {
        [iconImageView, label].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
    }
    
    private func configureIconImageView() {
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: topAnchor,constant: 2),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            iconImageView.widthAnchor.constraint(equalToConstant: 15),
            iconImageView.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
    
    private func configureLabel() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 5),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
