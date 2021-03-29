//
//  InfoAmiiboVC.swift
//  Amiibapp
//
//  Created by Miguel Planckensteiner on 2/10/21.
//

import UIKit
import WidgetKit

class InfoAmiiboVC: UIViewController {
    
    var amiibo: Amiibo!
    var filteredAmiibo: Amiibo!
    
    //var fornite: fortnite_api!
    
    
    
    
    let amiiboImageView = IconImageView(frame: .zero)
    let amiiboTitleLabel = AmiiboTitleLabel(textAlignment: .center, fontSize: 30)
    let amiiboGameSeries = AmiiboTitleLabel(textAlignment: .justified, fontSize: 20)
    
    
    let addToCollectionButton = AmiiboButton(backgroundColor: .systemGray, title: "Add To My Collection")
    let addToMyWidget = AmiiboButton(backgroundColor: .systemGray, title: "Add To My Widget")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(amiibo.name)
        configureUIElements()
        layoutUI()
        
        
   
    }
    override func viewWillAppear(_ animated: Bool) {
        setGradientBackground()
        super.viewWillAppear(animated)
    }
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
                
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    func configureUIElements() {
        view.backgroundColor = .red

        
        amiiboImageView.downloadImage(fromURL: amiibo.image)
        amiiboTitleLabel.text = amiibo.name
        amiiboGameSeries.text = ("🎮: \(amiibo.gameSeries.uppercased())")
        
        addToCollectionButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        addToMyWidget.addTarget(self, action: #selector(addToWidgetTapped), for: .touchUpInside)
    }
    
    func layoutUI() {
        
        view.addSubviews(amiiboImageView, amiiboTitleLabel, amiiboGameSeries, addToCollectionButton, addToMyWidget)
        
        
        
        NSLayoutConstraint.activate([
            amiiboImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            amiiboImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            amiiboImageView.widthAnchor.constraint(equalToConstant: 200),
            amiiboImageView.heightAnchor.constraint(equalToConstant: 200),
            
            amiiboTitleLabel.topAnchor.constraint(equalTo: amiiboImageView.bottomAnchor, constant: 25),
            amiiboTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            amiiboTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        
            amiiboGameSeries.topAnchor.constraint(equalTo: amiiboTitleLabel.bottomAnchor, constant: 20),
            amiiboGameSeries.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            amiiboGameSeries.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            
            addToMyWidget.bottomAnchor.constraint(equalTo: addToCollectionButton.topAnchor, constant: -10),
            addToMyWidget.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            addToMyWidget.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            addToMyWidget.heightAnchor.constraint(equalToConstant: 50),
            
            addToCollectionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            addToCollectionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            addToCollectionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            addToCollectionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    @objc func addButtonTapped() {
        configureSaveToCollection(amiibo: amiibo)
        
    }
    
    @objc func addToWidgetTapped() {
        
        let userDefaults = UserDefaults(suiteName: "group.amiiboWidget")
        userDefaults?.setValue(amiibo.name, forKey: "name")
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func configureSaveToCollection(amiibo: Amiibo) {
        
        let item = Amiibo(amiiboSeries: amiibo.amiiboSeries, character: amiibo.character, gameSeries: amiibo.gameSeries, image: amiibo.image, name: amiibo.name, tail: amiibo.tail, type: amiibo.type)
        
        PersistanceManager.updateWith(item: item, actionType: .add) { [weak self] error in
            
            guard let self = self else { return }
            
            guard let error = error else {
                self.dismiss(animated: true)
                return
            }
            print(error.rawValue)
        }
        
    }
}
