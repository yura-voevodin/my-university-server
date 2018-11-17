//
//  TeachersController.swift
//  App
//
//  Created by Yura Voevodin on 11/17/18.
//

import Vapor

final class TeachersController {
    
    /// Returns a list of all `Teacher`s.
    func index(_ req: Request) throws -> Future<[TeacherModel]> {
        return TeacherModel.query(on: req).all()
    }
}

