//
//  AuditoriumController.swift
//  App
//
//  Created by Yura Voevodin on 11/17/18.
//

import FluentPostgreSQL
import Vapor

final class AuditoriumController: RouteCollection {
    
    func boot(router: Router) throws {
        let auditoriums = router.grouped("auditoriums")
        auditoriums.get(use: index)
        auditoriums.get(Auditorium.parameter, use: show)
    }
    
    /// Returns a list of all `Auditorium`s.
    func index(_ req: Request) throws -> Future<[Auditorium]> {
        return Auditorium.query(on: req).all()
    }
    
    func show(_ request: Request) throws -> Future<Auditorium> {
        let auditorium = Auditorium.query(on: request).first().map(to: Auditorium.self, { auditorium in
            guard let auditorium = auditorium else {
                throw Abort(.notFound)
            }
            return auditorium
        })
        return auditorium.map { auditorium in
            return try auditorium.updateRecords(request: request).map(to: Auditorium.self, { auditorium in
                return auditorium
            })
        }
    }
}
