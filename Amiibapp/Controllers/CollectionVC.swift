//
//  CollectionVC.swift
//  Amiibapp
//
//  Created by Miguel Planckensteiner on 2/12/21.
//

import UIKit


class CollectionVC: UIViewController {
    
    var tableView = UITableView()
    var collection: [Amiibo] = []
    
    var counterBackground = AmiiboRoundedContainterView(frame: .zero)
    var counterAmiibos = AmiiboTitleLabel(textAlignment: .center, fontSize: 25)
    var eraseButton = AmiiboButton(backgroundColor: .clear, title: "🗑")
    
    struct Cells {
        static let amiiboCell = "AmiiboCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        configureUI()
        configureTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCollection()
        counterAmiibos.text = "\(collection.count)"
        
    }
    
    //MARK: - CONFIGURE UI
    
    func configureUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "My Amiibo Collection"
        navigationController?.navigationBar.tintColor = .red
        navigationItem.rightBarButtonItem = editButtonItem
        

    }
    
    //MARK: - CONFIGURE TABLE VIEW
    
    func configureTableView() {
        view.backgroundColor = .red
        view.addSubview(tableView)
        setTableViewDelegate()
        tableView.rowHeight = 100
        tableView.register(AmiiboCell.self, forCellReuseIdentifier: Cells.amiiboCell)
        tableView.pinToEdges(of: view)
        tableView.backgroundColor = .systemBackground
        tableView.removeExcessCells()
        
        
        
        
        configureElementsUI()
    }
    
    func setTableViewDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //MARK: - CONFIGURE ELEMENTS
    
    
    func configureElementsUI() {
        
        tableView.addSubview(counterBackground)
        counterBackground.addSubview(eraseButton)
        counterBackground.addSubview(counterAmiibos)
        
        //CounterContainer
        counterBackground.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        counterBackground.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        counterBackground.heightAnchor.constraint(equalToConstant: 60).isActive = true
        counterBackground.widthAnchor.constraint(equalTo: counterBackground.heightAnchor).isActive = true
        
        //EraseButton
        eraseButton.isHidden = true
        eraseButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        eraseButton.widthAnchor.constraint(equalTo: eraseButton.heightAnchor).isActive = true
        eraseButton.centerXAnchor.constraint(equalTo: counterBackground.centerXAnchor).isActive = true
        eraseButton.centerYAnchor.constraint(equalTo: counterBackground.centerYAnchor).isActive = true
        

        //CounterLabel
        counterAmiibos.isHidden = false
        counterAmiibos.heightAnchor.constraint(equalToConstant: 40).isActive = true
        counterAmiibos.widthAnchor.constraint(equalTo: counterAmiibos.heightAnchor).isActive = true
        counterAmiibos.centerXAnchor.constraint(equalTo: counterBackground.centerXAnchor).isActive = true
        counterAmiibos.centerYAnchor.constraint(equalTo: counterBackground.centerYAnchor).isActive = true
        
        
        
        
        counterAmiibos.textColor = .white
    }
    
    //MARK: - GET DATA

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
            self.tableView.reloadData()
            self.view.bringSubviewToFront(self.tableView)
            self.counterAmiibos.reloadInputViews()
        }
        
        if self.collection.isEmpty {
            print("No hay nada collection")
        }
    }
}

extension CollectionVC: UITableViewDelegate, UITableViewDataSource {
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing == true {
            eraseButton.isHidden = false
            counterAmiibos.isHidden = true
        } else {
            eraseButton.isHidden = true
            counterAmiibos.isHidden = false
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                
        return collection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.amiiboCell) as! AmiiboCell
                
        let amiibo = collection[indexPath.row]
        
        cell.set(amiibo: amiibo)
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete else { return }
        
        PersistanceManager.updateWith(item: collection[indexPath.row], actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else {
                self.collection.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
                
                return
            }
            
            print(error.rawValue)
        }
    }
}
