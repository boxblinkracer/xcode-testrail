//
//  TestRailConfigTest.swift
//  UnitTests
//
//  Created by Christian Dangl on 10.10.22.
//

import XCTest
@testable import XcodeTestrail


class TestRailConfigTest : XCTestCase
{
    
    
    public func testEmptyConfig()
    {
        let config = TestRailConfig(iniContent: "");
        
        XCTAssertEqual("", config.getDomain());
        XCTAssertEqual("", config.getUser());
        XCTAssertEqual("", config.getPassword());
        
        XCTAssertEqual("", config.getRunId());
    }
    
    public func testValidConfig()
    {
        let contentINI = """
        TESTRAIL_DOMAIN=xcode.testrail.io
        TESTRAIL_USER=myUser
        TESTRAIL_PWD=abc
        TESTRAIL_RUN_ID=123
        """
        
        let config = TestRailConfig(iniContent: contentINI);
        
        XCTAssertEqual("xcode.testrail.io", config.getDomain());
        XCTAssertEqual("myUser", config.getUser());
        XCTAssertEqual("abc", config.getPassword());
        
        XCTAssertEqual("123", config.getRunId());
    }
    
    /**
     This test verifies that our run id can also contain a "R" as prefix.
     In this case, the config should replace it, because we only need the INT value in the end.
     */
    public func testRunIdWithPrefix()
    {
        let contentINI = """
        TESTRAIL_RUN_ID=R44
        """
        
        let config = TestRailConfig(iniContent: contentINI);
        
        XCTAssertEqual("44", config.getRunId());
    }
    
}
