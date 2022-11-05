//
//  APIRequestProtocol.swift
//  Tantei
//
//  Created by Randell on 5/11/22.
//

import Foundation

protocol APIRequestProtocol {
    func get(request: URLRequest) async throws -> Result<Data, Error>
}
