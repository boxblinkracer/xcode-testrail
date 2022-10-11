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
        
        XCTAssertEqual("", config.getProjectId());
        XCTAssertEqual("", config.getMilestoneId());
        XCTAssertEqual("", config.getRunName());
        XCTAssertEqual(false, config.isCloseRun());
    }
    
    public func testValidConfig()
    {
        let contentINI = """
        TESTRAIL_DOMAIN=xcode.testrail.io
        TESTRAIL_USER=myUser
        TESTRAIL_PWD=abc
        TESTRAIL_RUN_ID=123
        TESTRAIL_PROJECT_ID=14
        TESTRAIL_MILESTONE_ID=5
        TESTRAIL_RUN_NAME=XCODE RUN
        TESTRAIL_CLOSE_RUN=true
        """
        
        let config = TestRailConfig(iniContent: contentINI);
        
        XCTAssertEqual("xcode.testrail.io", config.getDomain());
        XCTAssertEqual("myUser", config.getUser());
        XCTAssertEqual("abc", config.getPassword());
        
        XCTAssertEqual("123", config.getRunId());
        
        XCTAssertEqual("14", config.getProjectId());
        XCTAssertEqual("5", config.getMilestoneId());
        XCTAssertEqual("XCODE RUN", config.getRunName());
        XCTAssertEqual(true, config.isCloseRun());
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
    
    /**
     This test verifies that our project id can also contain a "P" as prefix.
     In this case, the config should replace it, because we only need the INT value in the end.
     */
    public func testProjectIdWithPrefix()
    {
        let contentINI = """
        TESTRAIL_PROJECT_ID=P44
        """
        
        let config = TestRailConfig(iniContent: contentINI);
        
        XCTAssertEqual("44", config.getProjectId());
    }
    
    /**
     This test verifies that our milestone id can also contain a "M" as prefix.
     In this case, the config should replace it, because we only need the INT value in the end.
     */
    public func testMilestoneIdWithPrefix()
    {
        let contentINI = """
        TESTRAIL_MILESTONE_ID=M45
        """
        
        let config = TestRailConfig(iniContent: contentINI);
        
        XCTAssertEqual("45", config.getMilestoneId());
    }
    
    public func testSetRunID()
    {
        let config = TestRailConfig(iniContent: "");
        
        XCTAssertEqual("", config.getRunId());
        
        config.setRunId(runId: "R123");
        
        XCTAssertEqual("123", config.getRunId());
    }
    
    
    public func testExistingRunMode()
    {
        let config = TestRailConfig(iniContent: "");
        
        XCTAssertEqual("", config.getRunId());
        
        config.setRunId(runId: "R123");
        
        XCTAssertEqual(false, config.isCreateRunMode());
    }
    
    public func testCreateRunMode()
    {
        let contentINI = """
        TESTRAIL_PROJECT_ID=P44
        """
        
        let config = TestRailConfig(iniContent: contentINI);
        
        XCTAssertEqual("", config.getRunId());
        
        config.setRunId(runId: "R123");
        
        XCTAssertEqual(true, config.isCreateRunMode());
    }
    
}
