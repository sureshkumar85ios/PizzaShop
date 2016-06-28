//
//  PizzaTestTests.swift
//  PizzaTestTests
//
//  Created by ADDC on 6/25/16.
//  Copyright © 2016 sureshkumar. All rights reserved.
//

import XCTest
@testable import PizzaTest

class PizzaTestTests: XCTestCase {
    
    var vc: MasterViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

            
            let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
      //  let splitViewController = self.window!.rootViewController as! UISplitViewController

            vc = storyboard.instantiateInitialViewController() as! MasterViewController
        
    }
    

    func testTableViewOutlet() {
        XCTAssertNotNil(vc.tableView)
    }
    
    func testTableViewCellForRowAtIndexPath() {
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        
        let cell = vc.tableView(vc.tableView, cellForRowAtIndexPath: indexPath)
        
        XCTAssertEqual((cell.contentView.viewWithTag(20) as! UILabel).text!, "Pizza Hut")
        XCTAssertEqual((cell.contentView.viewWithTag(21) as! UILabel).text!, "Washington,USA, D.C.")
    }
    
    func testWebServiceURLConnection() {
        let URL = NSURL(string: "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20local.search%20where%20zip%3D'78759'%20and%20query%3D'pizza'&format=json&diagnostics=true&callback=")!
        let expectation = expectationWithDescription("GET \(URL)")
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(URL) { data, response, error in
            XCTAssertNotNil(data, "data should not be nil")
            XCTAssertNil(error, "error should be nil")
            
            if let HTTPResponse = response as? NSHTTPURLResponse,
                responseURL = HTTPResponse.URL,
                MIMEType = HTTPResponse.MIMEType
            {
                XCTAssertEqual(responseURL.absoluteString, URL.absoluteString, "HTTP response URL should be equal to original URL")
                XCTAssertEqual(HTTPResponse.statusCode, 200, "HTTP response status code should be 200")
                XCTAssertEqual(MIMEType, "text/html", "HTTP response content type should be text/html")
            } else {
                XCTFail("Response was not NSHTTPURLResponse")
            }
            
            expectation.fulfill()
        }
        
        task.resume()
        
        waitForExpectationsWithTimeout(task.originalRequest!.timeoutInterval) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            task.cancel()
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
