//
//  FastlaneScreenshotsTestCase.swift
//  FastlaneScreenshots
//
//  Created by Randell on 6/10/22.
//

import XCTest

class FastlaneScreenshotsTestCase: XCTestCase {

    var app: XCUIApplication?

    override func setUp() {
        app = XCUIApplication()
        guard let app = app else { return }
        setupSnapshot(app)
        app.launch()
    }

    override func tearDown() {
        app = nil
    }
}
