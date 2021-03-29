//
//  AmiiboRoundedContainterView.swift
//  Amiibapp
//
//  Created by Miguel Planckensteiner on 2/15/21.
//

import UIKit

class AmiiboRoundedContainterView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    override func layoutSubviews() {
      super.layoutSubviews()
      layer.cornerRadius = frame.size.width/2
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
   
    
    private func configure() {
        
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        backgroundColor = UIColor.systemRed.withAlphaComponent(0.7)
    }
}
