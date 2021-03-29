//
//  AMerror.swift
//  Amiibapp
//
//  Created by Miguel Planckensteiner on 2/10/21.
//

import Foundation

enum AMError: String, Error {
    case invalidAmiibo = "this amiibo doesn't exist"
    case invalidResponse = "Invalid response from the server"
    case alreadyInFavorites = "you already have this amiibo in your list"
}
