//
//  TestRail.swift
//
//  Copyright © 2022 Christian Dangl. All rights reserved.
//

import Foundation
import XCTest

class TestRail
{

    // we must only register ourself ONCE
    // when running multiple test files of a test plan
    private static var alreadyRegistered : Bool = false;
    
    private static let STATUS_PASSED = 1;
    private static let STATUS_FAILED = 5;
    
    private var config : TestRailConfig;
    private var client : TestRailClient;
   
    
    
    init()
    {
        var configContent = Resource(name: "testrail", type: "conf").content;

        if (configContent == nil) {
            configContent = "";
        }
      
        self.config = TestRailConfig(iniContent: configContent!);
        
        
        self.client = TestRailClient(
            domain: self.config.getDomain(),
            username: self.config.getUser(),
            password: self.config.getPassword()
        );
    }

    public func register()
    {
        if (TestRail.alreadyRegistered)
        {
            return;
        }

        TestRail.alreadyRegistered = true;

        if (self.isConfigValid())
        {
            let observer = TestObserver(testrail: self);
            let observationCenter = XCTestObservationCenter.shared;
            observationCenter.addTestObserver(observer);

            print("");
            print("");
            print("TESTRAIL INTEGRATION");
            print("*******************************************");
            print("TestRail Domain: " + self.config.getDomain());
            print("TestRail User: " + self.config.getUser());
            print("Mode: Use existing Run");
            print("RunID: " + self.config.getRunId());
            print("");
            print("");
        }
    }

    public func testPassed(caseId: String, comment : String, durationS: Int)
    {
        if (!self.isConfigValid())
        {
            return;
        }

        self.client.sendResult(
            runId: self.config.getRunId(),
            caseId: caseId,
            statusId: TestRail.STATUS_PASSED,
            durationS: durationS,
            comment: comment
        );
    }

    public func testFailed(caseId: String, comment : String, durationS: Int)
    {
        if (!self.isConfigValid())
        {
            return;
        }

        self.client.sendResult(
            runId: self.config.getRunId(),
            caseId: caseId,
            statusId: TestRail.STATUS_FAILED,
            durationS: durationS,
            comment: comment);
    }

    private func isConfigValid() -> Bool
    {
        if (!self.client.isConfigValid())
        {
            return false;
        }

        if (self.config.getRunId() == "")
        {
            return false;
        }

        return true;
    }
}
