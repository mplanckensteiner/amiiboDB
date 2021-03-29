//
//  Plant.swift
//  PlantDB
//
//  Created by Miguel Planckensteiner on 2/9/21.
//

import UIKit

struct AmiiboList : Codable {
    let amiibo: [Amiibo]
}


struct Amiibo: Codable, Hashable {
    
    let amiiboSeries: String
    let character: String
    let gameSeries: String
    let image: String
    let name: String
    //let release: AmiiboRelease
    let tail: String
    let type: String
    
}

struct AmiiboRelease: Codable {
    
    let au: String?
    let eu: String?
    let jp: String?
    let na: String?
}
