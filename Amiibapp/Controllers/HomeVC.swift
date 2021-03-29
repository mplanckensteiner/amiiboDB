//
//  HomeAmiibosVC.swift
//  Amiibapp
//
//  Created by Miguel Planckensteiner on 2/12/21.
//

import UIKit


class HomeVC: UICollectionViewController {
    
    var amiibos: [Amiibo] = []
    var filteredAmiibos: [Amiibo] = []
    
    
    let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    struct Cells {
        static let amiiboCell = "AmiiboCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        configureCollectionViewController()
        getAmiibos()
    }
    
    
    
    func configureCollectionViewController() {
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Amiibo"
        navigationItem.searchController = searchController

        navigationController?.navigationBar.prefersLargeTitles = true
        collectionView.backgroundColor = .systemBackground
        navigationItem.title = "Amiibo DB"
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        collectionView.register(AmiiboCollectionCell.self, forCellWithReuseIdentifier: AmiiboCollectionCell.reuseIdentifier)

    }
    
    //MARK: - SEARCH BAR FUNCTION
    func filterContentForSearchText(_ searchText: String) {
        filteredAmiibos = amiibos.filter { (amiibo: Amiibo) -> Bool in
            return amiibo.name.lowercased().contains(searchText.lowercased())
        }
        
        collectionView.reloadData()
    }
    
    // MARK: - GET AMIIBOS
    
    func getAmiibos() {
        
        let amiiboList = { (fetchedAmiiboList: [Amiibo]) in
            DispatchQueue.main.async {
                self.amiibos = fetchedAmiiboList
                self.collectionView.reloadData()
            }
        }
        
        NetworkManager.shared.getAmiiboList(onCompletion: amiiboList)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return amiibos.count
        
        if isFiltering {
            return filteredAmiibos.count
        }
        
        return amiibos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AmiiboCollectionCell.reuseIdentifier, for: indexPath) as! AmiiboCollectionCell
        
        //let item = amiibos[indexPath.item]
        
        let amiibo: Amiibo
        
        if isFiltering {
            amiibo = filteredAmiibos[indexPath.item]
        } else {
            amiibo = amiibos[indexPath.item]
        }
        
        cell.set(item: amiibo)
                
        return cell
    }
    
    //Selection
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isFiltering {
            let data = filteredAmiibos[indexPath.row]
            let destinationVC = InfoAmiiboVC()
            destinationVC.amiibo = data
            
            collectionView.deselectItem(at: indexPath, animated: true)
            present(destinationVC, animated: true)
            
        } else {
            
            let data = amiibos[indexPath.row]
            let destinationVC = InfoAmiiboVC()
            destinationVC.amiibo = data
            
            collectionView.deselectItem(at: indexPath, animated: true)
            present(destinationVC, animated: true)
        }
    }
}

extension HomeVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
}
