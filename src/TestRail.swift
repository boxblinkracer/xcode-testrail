//
//  TestRail.swift
//
//  Copyright © 2022 Christian Dangl. All rights reserved.
//

import Foundation
import XCTest


class TestRail
{

    private var client : TestRailClient;

    private var runId : String;


    init()
    {

        let domain = ProcessInfo.processInfo.environment["TESTRAIL_DOMAIN"] ?? "";
        let username = ProcessInfo.processInfo.environment["TESTRAIL_USER"] ?? "";
        let password = ProcessInfo.processInfo.environment["TESTRAIL_PWD"] ?? "";

        self.client = TestRailClient(
            domain: domain,
            username: username,
            password: password
        );

        self.runId = ProcessInfo.processInfo.environment["TESTRAIL_RUN_ID"] ?? "";

        if (self.isConfigValid())
        {
            print("TestRail Configuration is valid.");
        }
        else
        {
            print("TestRail Configuration is invalid. Skipping integration...");
        }
    }

    public func register()
    {
        let observer = TestObserver(testrail: self);
        let observationCenter = XCTestObservationCenter.shared;

        observationCenter.addTestObserver(observer);
    }

    public func testPassed(caseId: Int, comment : String, durationS: Int)
    {
        if (!self.isConfigValid())
        {
            return;
        }

        self.client.sendResult(runId: Int(self.runId)!, caseId: caseId, statusId: 1, durationS: durationS, comment: comment);
    }

    public func testFailed(caseId: Int, comment : String, durationS: Int)
    {
        if (!self.isConfigValid())
        {
            return;
        }

        self.client.sendResult(runId: Int(self.runId)!, caseId: caseId, statusId: 5, durationS: durationS, comment: comment);
    }

    private func isConfigValid() -> Bool
    {
        if (self.runId == "")
        {
            return false;
        }

        return true;
    }
}
