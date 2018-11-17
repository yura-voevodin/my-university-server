//
//  AuditoriumsController.swift
//  App
//
//  Created by Yura Voevodin on 11/17/18.
//

import Vapor

final class AuditoriumsController {
    
    /// Returns a list of all `Auditorium`s.
    func index(_ req: Request) throws -> Future<[AuditoriumModel]> {
        return AuditoriumModel.query(on: req).all()
    }
}
