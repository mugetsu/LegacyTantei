//
//  HTTPRequest.swift
//  Tantei
//
//  Created by Randell on 5/11/22.
//

import Foundation

enum RequestType {
    case data
}

enum ResponseType {
    case json
}

enum RequestMethod: String {
    case get = "GET"
}

typealias ReaquestHeaders = [String: String]

typealias RequestParameters = [String: String]
