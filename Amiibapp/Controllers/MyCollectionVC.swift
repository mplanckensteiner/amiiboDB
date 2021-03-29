//
//  MyCollectionVC.swift
//  Amiibapp
//
//  Created by Miguel Planckensteiner on 2/10/21.
//

import UIKit


class MyCollectionVC: UICollectionViewController {
    
    var collection: [Amiibo] = []
    var eraseButton = AmiiboButton(backgroundColor: UIColor.black.withAlphaComponent(0.5), title: "Erase")
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        configureCollectionViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCollection()
    }
    
    func configureCollectionViewController() {
        
        navigationController?.navigationBar.prefersLargeTitles = true
        collectionView.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = editButtonItem
        title = "My Collection"
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.addSubview(eraseButton)
        eraseButton.isHidden = true
        eraseButton.addTarget(self, action: #selector(deleteSelectedAmiibo), for: .touchUpInside)
        eraseButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        eraseButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        eraseButton.widthAnchor.constraint(equalTo: eraseButton.heightAnchor).isActive = true
        eraseButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        
        collectionView.register(AmiiboCollectionCell.self, forCellWithReuseIdentifier: AmiiboCollectionCell.reuseIdentifier)

    }
    
    
    func getCollection() {
        PersistanceManager.retrieveCollection { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let collection):
                self.updateUI(with: collection)
                
            case .failure(let error):
                return
                    print(error.rawValue)
            }
        }
    }
    
    func updateUI(with collection: [Amiibo]) {
        self.collection = collection
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.view.bringSubviewToFront(self.collectionView)
        }
        
        if self.collection.isEmpty {
            print("No hay nadacollection")
        }
        
    }
    
    @objc func deleteSelectedAmiibo(_ sender: UIButton) {
        if let selectedItems = collectionView.indexPathsForSelectedItems {

            let items = selectedItems.map{$0.item}.sorted().reversed()
            
            for item in items {

                collection.remove(at: item)
            }
            collectionView.deleteItems(at: selectedItems)
        }
    }

    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        collectionView.allowsMultipleSelection = editing
        
        if editing == true {
            eraseButton.isHidden = false
        } else {
            eraseButton.isHidden = true
        }
        
        collectionView.indexPathsForSelectedItems?.forEach({ (indexPath) in
            collectionView.deselectItem(at: indexPath, animated: false)
        })
        
        collectionView.indexPathsForVisibleItems.forEach { (indexPath) in
            let cell = collectionView.cellForItem(at: indexPath) as! AmiiboCollectionCell
            
            cell.isEditing = editing
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collection.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AmiiboCollectionCell.reuseIdentifier, for: indexPath) as! AmiiboCollectionCell
        
        let item = collection[indexPath.item]
        
        cell.set(item: item)
       
        cell.isEditing = isEditing
        
        
        
        return cell
    }
    //Selection
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        

    }
}
