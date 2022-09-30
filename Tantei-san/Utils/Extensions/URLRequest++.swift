//
//  URLRequest++.swift
//  Tantei-san
//
//  Created by Randell on 30/9/22.
//

import Foundation

extension URLRequest {
    func processRequest(body: [String: String]? = nil) -> URLRequest {
        var request = self
        request.httpMethod = "GET"
        if let body = body {
            let bodyData = try? JSONSerialization.data(
                withJSONObject: body,
                options: []
            )
            request.httpMethod = "POST"
            request.httpBody = bodyData
        }
        return request
    }
}
