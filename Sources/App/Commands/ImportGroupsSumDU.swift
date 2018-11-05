//
//  ImportGroupsSumDU.swift
//  App
//
//  Created by Yura Voevodin on 11/4/18.
//

import Vapor

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
        let url: String = "http://schedule.sumdu.edu.ua/index/json?method=getAuditoriums"
        let request = Request(http: .init(method: .GET, url: url), using: context.container)
        
        // Response & JSON
        let response = client.send(request)
        let json = response.map { (response) -> [String : Any] in
            if let data = response.http.body.data {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                return json ?? [:]
            } else {
                return [:]
            }
        }
        
        let result = json.map(to: Void.self) { json in
            
            if let dictionary = json as? [String: String] {
                for item in dictionary {
                    // Get ID and name
                    guard let id = Int(item.key) else { continue }
                    let name = item.value
                    
                    // Validation
                    guard name.count > 0 && id != 0 else { continue }
                    
                    print("ID = ", id)
                    print("Name = ", name)
                }
            }
        }
        return result.always {
            loadingBar.succeed()
        }
    }
}
