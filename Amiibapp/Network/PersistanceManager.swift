//
//  PersistanceManager.swift
//  Amiibapp
//
//  Created by Miguel Planckensteiner on 2/10/21.
//

import UIKit

enum PersistanceActionType {
    
    case add, remove
}

enum PersistanceManager {
    
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let collection = "collection"
    }
    
    static func updateWith(item: Amiibo, actionType: PersistanceActionType, completed: @escaping (AMError?) -> Void) {
        retrieveCollection { result in
            switch result {
            case .success(var collection):
                switch actionType {
                case .add:
                    
                    guard !collection.contains(item) else {
                        completed(.alreadyInFavorites)
                        return
                    }
                    
                    collection.append(item)
                    
                case .remove:
                    
                    collection.removeAll { $0.name == item.name }
                    
                }
                
                completed(save(collection: collection))
                
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    static func retrieveCollection(completed: @escaping (Result<[Amiibo], AMError>) -> Void) {
        
        guard let collectionData = defaults.object(forKey: Keys.collection) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let collection = try decoder.decode([Amiibo].self, from: collectionData)
            completed(.success(collection))
        } catch {
            completed(.failure(.invalidAmiibo))
        }
    }
    
    
    static func save(collection: [Amiibo]) -> AMError? {
        
        do {
            let enconder = JSONEncoder()
            let encodedCollection = try enconder.encode(collection)
            defaults.set(encodedCollection, forKey: Keys.collection)
            return nil
        } catch {
            return .invalidAmiibo
        }
    }
}
