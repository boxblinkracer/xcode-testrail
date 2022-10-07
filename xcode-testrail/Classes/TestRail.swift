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

        var domain = "";
        var username = "";
        var password = "";
        var runId = "";


        let configContent = Resource(name: "testrail", type: "conf").content;

        if (configContent != nil) {

            let iniParser = IniParser(content: configContent!);

             domain = iniParser.getValue(key: "TESTRAIL_DOMAIN");
             username = iniParser.getValue(key: "TESTRAIL_USER");
             password = iniParser.getValue(key: "TESTRAIL_PWD");
             runId = iniParser.getValue(key: "TESTRAIL_RUN_ID");
        }


        self.runId = runId;

        self.client = TestRailClient(
            domain: domain,
            username: username,
            password: password
        );


        if (self.isConfigValid())
        {
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
