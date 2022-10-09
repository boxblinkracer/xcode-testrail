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
    static var alreadyRegistered : Bool = false;


    private var client : TestRailClient;

    private var domain : String;
    private var username : String;
    private var password : String;
    private var runId : String;


    init()
    {

        self.domain = "";
        self.username = "";
        self.password = "";
        self.runId = "";


        let configContent = Resource(name: "testrail", type: "conf").content;

        if (configContent != nil) {

            let iniParser = IniParser(content: configContent!);

            self.domain = iniParser.getValue(key: "TESTRAIL_DOMAIN");
            self.username = iniParser.getValue(key: "TESTRAIL_USER");
            self.password = iniParser.getValue(key: "TESTRAIL_PWD");
            self.runId = iniParser.getValue(key: "TESTRAIL_RUN_ID");
        }

        self.client = TestRailClient(
            domain: domain,
            username: username,
            password: password
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
            print("TestRail Domain: " + domain);
            print("TestRail User: " + username);
            print("Mode: Use existing Run");
            print("RunID: " + runId);
            print("");
            print("");
        }
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
        if (!self.client.isConfigValid())
        {
            return false;
        }

        if (self.runId == "")
        {
            return false;
        }

        return true;
    }
}
