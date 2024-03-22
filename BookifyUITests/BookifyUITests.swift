//
//  BookifyUITests.swift
//  BookifyUITests
//
//  Created by Ami Intwala on 22/03/24.
//

import XCTest

class BookifyUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // Test whether ContentView appears and displays book list
    func testContentViewAppearsAndDisplaysBookList() {
        let app = XCUIApplication()
        app.launch()

        // Wait for the navigation title "Books" to appear
        let navigationTitle = app.navigationBars["Books"]
        XCTAssertTrue(navigationTitle.waitForExistence(timeout: 5))

        // Check if the list of books is displayed
        let booksList = app.tables["booksList"]
        XCTAssertTrue(booksList.exists)

        // Check if at least one cell is displayed
        XCTAssertTrue(booksList.cells.count > 0)
    }

    func testNavigateToDetailView() {
        let app = XCUIApplication()
        app.launch()

        // Wait for the list to appear
        let booksList = app.tables["booksList"]
        XCTAssertTrue(booksList.waitForExistence(timeout: 5))

        // Tap on the first cell to navigate to the detail view
        if booksList.cells.count > 0 {
            let firstCell = booksList.cells.element(boundBy: 0)
            firstCell.tap()

            // Wait for the navigation bar in the detail view to exist
            let detailViewNavigationBar = app.navigationBars["Book Details"]
            XCTAssertTrue(detailViewNavigationBar.waitForExistence(timeout: 5))

            // Assert that the detail view title is correct
            XCTAssertEqual(detailViewNavigationBar.identifier, "Book Details")
        }
    }
}
