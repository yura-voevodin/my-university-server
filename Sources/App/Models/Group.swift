//
//  Group.swift
//  App
//
//  Created by Yura Voevodin on 11/17/18.
//

import FluentPostgreSQL
import Vapor

final class Group: PostgreSQLModel {
    
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

// MARK: - Relations

extension Group {
    var records: Children<Group, Record> {
        return children(\.groupID)
    }
}

/// Allows to be encoded to and decoded from HTTP messages.
extension Group: Content { }

/// Allows to be used as a dynamic migration.
extension Group: Migration { }

extension Group: Parameter { }
