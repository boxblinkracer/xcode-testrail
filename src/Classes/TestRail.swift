//
//  TestRail.swift
//
//  Copyright © 2022 Christian Dangl. All rights reserved.
//

import Foundation
import XCTest


class TestRail
{
    
    private static let STATUS_PASSED = 1;
    private static let STATUS_FAILED = 5;
    
    
    // we must only register ourself ONCE
    // when running multiple test files of a test plan
    private static var alreadyRegistered : Bool = false;
    
    private static var executedCaseIDs : Array<String> = [];
    
    
    
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
        
        // only the first time, clean our list
        // and make sure its a full history of the full test suite
        TestRail.executedCaseIDs = [];
        
        
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
            
            if (self.config.isCreateRunMode()) {
                
                print("Mode: Create new Run");
                print("Projecct: " + self.config.getProjectId());
                print("Milestone: " + self.config.getMilestoneId());
                print("Name: " + self.config.getRunName());
                print("Close Run: " + String(self.config.isCloseRun()));
                
                var name = self.config.getRunName()
                
                if (name == "") {
                    name = "Xcode Test Run";
                }
                
                let newRunID = self.client.createRun(
                    projectId: self.config.getProjectId(),
                    milestoneId: self.config.getMilestoneId(),
                    name: name,
                    description: ""
                );
                
                self.config.setRunId(runId: newRunID);
                
            } else {
                
                print("Mode: Use existing Run");
                print("RunID: " + self.config.getRunId());
            }
            
            print("");
            print("");
        }
    }
    
    public func testPassed(caseId: String, comment : String, durationS: Int)
    {
        self.sendResult(
            caseId: caseId,
            statusId: TestRail.STATUS_PASSED,
            comment: comment,
            durationS: durationS
        );
    }
    
    public func testFailed(caseId: String, comment : String, durationS: Int)
    {
        self.sendResult(
            caseId: caseId,
            statusId: TestRail.STATUS_FAILED,
            comment: comment,
            durationS: durationS
        );
    }
    
    public func onTestRunFinished()
    {
        if (self.config.isCreateRunMode() && self.config.isCloseRun())
        {
            self.client.closesRun(runId: self.config.getRunId());
        }
    }
    
    
    private func isConfigValid() -> Bool
    {
        if (!self.client.isConfigValid())
        {
            return false;
        }
        
        if (self.config.getRunId() == "" && self.config.getProjectId() == "")
        {
            return false;
        }
        
        return true;
    }
    
    
    private func sendResult(caseId: String, statusId : Int, comment : String, durationS: Int)
    {
        // add new case ID to list
        TestRail.executedCaseIDs.append(caseId);
        
        
        if (!self.isConfigValid())
        {
            return;
        }
        
        
        if (self.config.isCreateRunMode())
        {
            // we have a new test run
            // so first add that test case to the run
            self.client.updateRun(runId: self.config.getRunId(), caseIds: TestRail.executedCaseIDs);
        }
        
        self.client.sendResult(
            runId: self.config.getRunId(),
            caseId: caseId,
            statusId: statusId,
            durationS: durationS,
            comment: comment
        );
    }
    
}
