//
//  GroupsController.swift
//  App
//
//  Created by Yura Voevodin on 11/17/18.
//

import Vapor

final class GroupsController {
    
    /// Returns a list of all `Group`s.
    func index(_ req: Request) throws -> Future<[GroupModel]> {
        return GroupModel.query(on: req).all()
    }
}

