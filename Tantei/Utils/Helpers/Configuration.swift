//
//  Configuration.swift
//  Tantei
//
//  Created by Randell on 1/4/23.
//

import Foundation

enum Configuration {
    static private func getValue(for key: String) -> String {
        Bundle.main.infoDictionary?[key] as! String
    }
}

extension Configuration {
    static var supabaseURL: URL {
        URL(string: getValue(for: "SUPABASE_URL"))!
    }
    
    static var supabaseKey: String {
        getValue(for: "SUPABASE_KEY")
    }
    
    static var jikanURL: URL {
        URL(string: getValue(for: "JIKAN_URL"))!
    }
    
    static var traceURL: URL {
        URL(string: getValue(for: "TRACE_URL"))!
    }
}
