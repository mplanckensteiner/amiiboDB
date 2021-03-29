//
//  AmiiboCollectionCell.swift
//  Amiibapp
//
//  Created by Miguel Planckensteiner on 2/10/21.
//

import UIKit


class AmiiboCollectionCell: UICollectionViewCell {
    
    static let reuseIdentifier = "AmiiboCollectionCell"
    
    let iconImageView = IconImageView(frame: .zero)
    let amiiboName = AmiiboTitleLabel(textAlignment: .center, fontSize: 12)
    
    var isEditing: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        configure()
    }
    
    override var isSelected: Bool {
        didSet {
            if isEditing {
                contentView.backgroundColor = isSelected ? UIColor.systemRed.withAlphaComponent(0.5): UIColor.systemRed
            } else {
                contentView.backgroundColor = .systemRed
            }
        }
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(item: Amiibo) {
        amiiboName.text = item.name
        iconImageView.downloadImage(fromURL: item.image)
    }
    
    private func configure() {
        contentView.addSubviews(iconImageView, amiiboName)
        contentView.backgroundColor = .systemRed
        contentView.layer.cornerRadius = 10
        amiiboName.numberOfLines = 2
        
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            iconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),
            
            amiiboName.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 12),
            amiiboName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            amiiboName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            amiiboName.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
