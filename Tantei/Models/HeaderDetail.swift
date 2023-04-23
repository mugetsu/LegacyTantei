//
//  HeaderDetail.swift
//  Tantei
//
//  Created by Randell on 30/10/22.
//

import Foundation

struct HeaderDetail {
    let title: String
    let subTitle: String?
    
    init(title: String, subTitle: String? = nil) {
        self.title = title
        self.subTitle = subTitle
    }
}
