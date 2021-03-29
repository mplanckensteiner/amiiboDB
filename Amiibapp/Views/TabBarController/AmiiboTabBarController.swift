//
//  PlantTabBarController.swift
//  PlantDB
//
//  Created by Miguel Planckensteiner on 2/9/21.
//

import UIKit

class AmiiboTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemRed
        viewControllers = [createHome(), createCollection()]
    }
    
    
    func createHome() -> UINavigationController {

        let layout = UIHelper.createThreeColumnFlowLayout(in: view)
        let homeVC = HomeVC(collectionViewLayout: layout)
        homeVC.tabBarItem = UITabBarItem(title: "Amiibos", image: UIImage(systemName: "person.fill"), tag: 0)
        
        return UINavigationController(rootViewController: homeVC)
    }
    
    func createCollection() -> UINavigationController {
        
        let collection = CollectionVC()
        collection.tabBarItem = UITabBarItem(title: "Collection", image: UIImage(systemName: "star.fill"), tag: 1)
        
        return UINavigationController(rootViewController: collection)
    }
}
