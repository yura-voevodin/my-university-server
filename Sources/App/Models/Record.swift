//
//  Record.swift
//  App
//
//  Created by Yura Voevodin on 12/23/18.
//

import FluentPostgreSQL
import Vapor

final class Record: PostgreSQLModel {
    
    // MARK: Properties
    
    var id: Int?
    
    var auditoriumID: Int?
    var groupID: Int?
    var teacherID: Int?
    
    var date: Date
    var dateString: String
    var pairName: String
    
    var name: String?
    var reason: String?
    var type: String?
    var time: String
    
    // MARK: - Initialization
    
    init(id: Int? = nil, auditoriumID: Int?, groupID: Int?, teacherID: Int?, date: Date, dateString: String, pairName: String, name: String?, reason: String?, type: String?, time: String) {
        
        self.auditoriumID = auditoriumID
        self.groupID = groupID
        self.teacherID = teacherID
        self.date = date
        self.dateString = dateString
        self.pairName = pairName
        self.name = name
        self.reason = reason
        self.type = type
        self.time = time
    }
}

// MARK: - Relations

extension Record {
    
    var auditorium: Parent<Record, Auditorium>? {
        return parent(\.auditoriumID)
    }
    
    var group: Parent<Record, Group>? {
        return parent(\.groupID)
    }
    
    var teacher: Parent<Record, Teacher>? {
        return parent(\.teacherID)
    }
}

/// Allows to be encoded to and decoded from HTTP messages.
extension Record: Content { }

/// Allows to be used as a dynamic migration.
extension Record: Migration { }

extension Record: Parameter { }
