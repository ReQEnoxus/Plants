//
//  Clients.swift
//  Plants
//
//  Created by Никита Афанасьев on 11.05.2024.
//

import OpenAPIRuntime
import OpenAPIURLSession

extension Client {
    static var main: Client = Client(
        serverURL: try! Servers.server1(),
        transport: URLSessionTransport(),
        middlewares: [AuthMiddleware()]
    )
}
