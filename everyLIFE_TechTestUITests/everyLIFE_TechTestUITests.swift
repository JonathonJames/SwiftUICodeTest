//
//  everyLIFE_TechTestUITests.swift
//  everyLIFE_TechTestUITests
//
//  Created by Jonathon James on 31/08/2021.
//

import XCTest

class everyLIFE_TechTestUITests: XCTestCase {
    
    #warning("TODO: These are very unfinished. Need to setup a 'mock' app, rather than the actual app, so that we can have more fine-grained control over what the app does and when, without necessarily needing to hit the API.")

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let navBar: XCUIElement = app.navigationBars.element
        XCTAssert(navBar.exists)

        let tasksHeaderText: XCUIElement = app.staticTexts["Tasks"]
        XCTAssert(tasksHeaderText.exists)
        
        let taskListView: XCUIElement = app.otherElements["TaskListView"]
        XCTAssert(taskListView.exists)
        
        
        #warning("TODO: This fails. Not sure why. Accessibility inspector just picks up the parent 'Group'. Perhaps need to hide that somehow.)
        let filterView: XCUIElement = app.otherElements["FilterView"]
        XCTAssert(filterView.exists)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
