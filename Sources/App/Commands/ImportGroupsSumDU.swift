//
//  ImportGroupsSumDU.swift
//  App
//
//  Created by Yura Voevodin on 11/4/18.
//

import FluentPostgreSQL
import Vapor

/// swift run Run import-auditoriums-sumdu
struct ImportGroupsSumDU: Command {
    
    var arguments: [CommandArgument] {
        return []
    }
    
    var options: [CommandOption] {
        return []
    }
    
    var help: [String] {
        return ["Import groups of SumDU"]
    }
    
    func run(using context: CommandContext) throws -> EventLoopFuture<Void> {
        let terminal = try context.container.make(Terminal.self)
        let loadingBar = terminal.loadingBar(title: "Loading")
        
        // Client
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let client = FoundationClient(session, on: context.container)
        _ = loadingBar.start(on: context.container)
        
        // Request
        let url: String = "http://schedule.sumdu.edu.ua/index/json?method=getGroups"
        let request = Request(http: .init(method: .GET, url: url), using: context.container)
        
        // Response & JSON
        let response = client.send(request)
        
        let result = response.map { (response) -> [String : Any] in
            if let data = response.http.body.data {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                return json ?? [:]
            } else {
                return [:]
            }
            
            }.map(to: [Group].self) { json in
                
                var groups: [Group] = []
                if let dictionary = json as? [String: String] {
                    
                    for item in dictionary {
                        // Get ID and name
                        guard let id = Int(item.key) else { continue }
                        let name = item.value
                        
                        // Validation
                        guard name.count > 0 && id != 0 else { continue }
                        
                        groups.append(Group(serverID: id, name: name, updatedAt: "", lowercaseName: name.lowercased()))
                    }
                }
                
                return groups
        }
        
        return result.flatMap { groups in

            context.container.withNewConnection(to: .psql, closure: { conn in

                PostgreSQLDatabase.transactionExecute({ tran in

                    groups.map { group in

                        group.create(on: tran)
                            .transform(to: ())
                            .catchMap { _ in () }
                    }
                    .flatten(on: tran)

                }, on: conn)
            })
            }.map(to: Void.self) { _ in }.always {
                loadingBar.succeed()
        }
    }
}
