//
//  Auditorium.swift
//  App
//
//  Created by Yura Voevodin on 11/5/18.
//

import FluentPostgreSQL
import Vapor

final class Auditorium: PostgreSQLModel {
    
    // MARK: Properties
    
    var id: Int?
    var serverID: Int
    var name: String
    var updatedAt: Date?
    var lowercaseName: String
    
    // MARK: - Initialization
    
    init(id: Int? = nil, serverID: Int, name: String, updatedAt: Date?, lowercaseName: String) {
        self.serverID = serverID
        self.name = name
        self.updatedAt = updatedAt
        self.lowercaseName = lowercaseName
    }
}

// MARK: - Relations

extension Auditorium {
    var records: Children<Auditorium, Record> {
        return children(\.auditoriumID)
    }
}

/// Allows to be encoded to and decoded from HTTP messages.
extension Auditorium: Content { }

/// Allows to be used as a dynamic migration.
extension Auditorium: Migration { }

extension Auditorium: Parameter { }

// MARK: - Get records

extension Auditorium {
    
    func updateRecords(request: Request) throws -> Future<Auditorium> {
        // Check if need to update
        let currentDate = Date()
        let oneHour: TimeInterval = 60 * 60
        var shouldUpdateRecords = false
        if let updatedAt = updatedAt {
            if currentDate > updatedAt.addingTimeInterval(oneHour) {
                shouldUpdateRecords = true
            }
        } else {
            shouldUpdateRecords = true
        }
        
        if shouldUpdateRecords {
            // Try to delete old records
            return try records.query(on: request).delete().flatMap({ _ in
                
                // TODO: Try to import schedule
                
                // Update date and save
                self.updatedAt = Date()
                return self.save(on: request)
            })
        } else {
            return self
        }
    }
}
