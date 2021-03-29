//
//  PlantCell.swift
//  PlantDB
//
//  Created by Miguel Planckensteiner on 2/9/21.
//

import UIKit


class AmiiboCell: UITableViewCell {
    
    var amiiboImage = IconImageView(frame: .zero)
    var amiiboTitleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(amiiboImage)
        addSubview(amiiboTitleLabel)
        
        configureTitleLabel()
        setImageConstraints()
        setTitleLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(amiibo: Amiibo) {
        amiiboImage.downloadImage(fromURL: amiibo.image)
        amiiboTitleLabel.text = amiibo.name
    }
    
    
    func configureTitleLabel() {
        amiiboTitleLabel.numberOfLines = 0
        amiiboTitleLabel.adjustsFontSizeToFitWidth = true
    }
    
    
    
    func setImageConstraints() {
        amiiboImage.translatesAutoresizingMaskIntoConstraints = false
        amiiboImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        amiiboImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        amiiboImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        amiiboImage.widthAnchor.constraint(equalTo: amiiboImage.heightAnchor).isActive = true
    }
    
    func setTitleLabelConstraints() {
        amiiboTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        amiiboTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        amiiboTitleLabel.leadingAnchor.constraint(equalTo: amiiboImage.trailingAnchor, constant: 20).isActive = true
        amiiboTitleLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        amiiboTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        
    }
}
