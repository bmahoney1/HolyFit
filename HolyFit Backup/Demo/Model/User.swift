//
//  User.swift
//  Demo
//
//  Created by Brennan Mahoney on 5/21/23.
//

import SwiftUI
import FirebaseFirestoreSwift

struct User: Identifiable,Codable {
    @DocumentID var id: String?
    var username: String
    var userBio: String
    var userBioLink: String
    var userID: String
    var userEmail: String
    var userProfileURL: URL
    
    enum CodingKeys: CodingKey {
        case id
        case username
        case userBio
        case userBioLink
        case userID
        case userEmail
        case userProfileURL
    }
    
}
