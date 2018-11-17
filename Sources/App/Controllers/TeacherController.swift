//
//  TeacherController.swift
//  App
//
//  Created by Yura Voevodin on 11/17/18.
//

import FluentPostgreSQL
import Vapor

final class TeacherController: RouteCollection {
    
    func boot(router: Router) throws {
        let teachers = router.grouped("teachers")
        teachers.get(use: index)
        teachers.get(Teacher.parameter, use: show)
    }
    
    /// Returns a list of all `Teacher`s.
    func index(_ req: Request) throws -> Future<[Teacher]> {
        return Teacher.query(on: req).all()
    }
    
    func show(_ request: Request)throws -> Future<Teacher> {
        return try request.parameters.next(Teacher.self)
    }
}

