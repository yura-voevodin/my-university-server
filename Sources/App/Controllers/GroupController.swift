//
//  GroupController.swift
//  App
//
//  Created by Yura Voevodin on 11/17/18.
//

import FluentPostgreSQL
import Vapor

final class GroupController: RouteCollection {
    
    func boot(router: Router) throws {
        let groups = router.grouped("groups")
        groups.get(use: index)
        groups.get(Group.parameter, use: show)
    }
    
    /// Returns a list of all `Group`s.
    func index(_ req: Request) throws -> Future<[Group]> {
        return Group.query(on: req).all()
    }
    
    func show(_ request: Request)throws -> Future<Group> {
        return try request.parameters.next(Group.self)
    }
}

