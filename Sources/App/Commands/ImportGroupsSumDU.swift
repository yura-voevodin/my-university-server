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
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let client = FoundationClient(session, on: context.container)
        _ = loadingBar.start(on: context.container)
        
        let url: String = "http://schedule.sumdu.edu.ua/index/json?method=getAuditoriums"
        let request = Request(http: .init(method: .GET, url: url), using: context.container)
        
        return client.send(request).map(to: Void.self) { response in
            
            if let data = response.http.body.data {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                print(json ?? "Empty")
            }
            }.always {
                loadingBar.succeed()
        }
    }
}
