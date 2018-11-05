//
//  AuditoriumModel.swift
//  App
//
//  Created by Yura Voevodin on 11/5/18.
//

import FluentPostgreSQL
import Vapor

final class AuditoriumModel: PostgreSQLModel {
    
    // MARK: Properties
    
    var id: Int?
    var serverID: Int
    var name: String
    var updatedAt: String
    var lowercaseName: String
    
    // MARK: - Initialization
    
    init(id: Int? = nil, serverID: Int, name: String, updatedAt: String, lowercaseName: String) {
        self.serverID = serverID
        self.name = name
        self.updatedAt = updatedAt
        self.lowercaseName = lowercaseName
    }
}

extension AuditoriumModel: Content { }
