//
//  NetManager.swift
//  Amiibapp
//
//  Created by Miguel Planckensteiner on 2/15/21.
//

import UIKit

class NetManager {
    
    
    static let shared  = NetManager()
    private let baseURL = "https://www.amiiboapi.com/api/amiibo"
    let cache = NSCache<NSString, UIImage>()
    
    
    private init() {}
    
    func getAmiiboList(onCompletion: @escaping ([Amiibo]) -> Void)  {
        guard let url = URL(string: baseURL) else { return }
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            
            guard let data = data else {
                print("data was nil")
                return
            }
            guard let amiiboList = try? JSONDecoder().decode(AmiiboList.self, from: data) else {
                print("couldnt decode json")
                return
            }
            onCompletion(amiiboList.amiibo)
            //print(amiiboList.amiibo)
            
        }
        
        task.resume()
    }
    
    func downloadImage(from urlString: String, onCompletion: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            onCompletion(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            onCompletion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            guard let self = self, error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                onCompletion(nil)
                return
            }
            self.cache.setObject(image, forKey: cacheKey)
            onCompletion(image)
            
        }
        task.resume()
    }
}

