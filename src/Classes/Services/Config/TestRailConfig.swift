//
//  TestRailConfig.swift
//  XcodeTestrail
//
//  Created by Christian Dangl on 10.10.22.
//

import Foundation


class TestRailConfig
{
    
    private var domain : String;
    private var username : String;
    private var password : String;
    
    private var runId : String;
    
    private var projectId : String;
    private var milestoneId : String;
    private var runName : String;
    private var closeRun : Bool;
    
    
    init(iniContent: String)
    {
        let iniParser = IniParser(content: iniContent);
        
        self.domain = iniParser.getValue(key: "TESTRAIL_DOMAIN");
        self.username = iniParser.getValue(key: "TESTRAIL_USER");
        self.password = iniParser.getValue(key: "TESTRAIL_PWD");
        
        self.runId = "";
        
        self.projectId = iniParser.getValue(key: "TESTRAIL_PROJECT_ID");
        self.milestoneId = iniParser.getValue(key: "TESTRAIL_MILESTONE_ID");
        self.runName = iniParser.getValue(key: "TESTRAIL_RUN_NAME");
        self.closeRun  = false;
        
        
        // now adjust a few values
        // and make sure to add custom logig after our
        // basic initializers above
        self.projectId = self.projectId.replacingOccurrences(of : "P", with: "");
        self.milestoneId = self.milestoneId.replacingOccurrences(of : "M", with: "");
        
        let closeValue = iniParser.getValue(key: "TESTRAIL_CLOSE_RUN");
        self.closeRun = (closeValue == "1" || closeValue == "true");
        
        let tmpRunID = iniParser.getValue(key: "TESTRAIL_RUN_ID");
        self.setRunId(runId: tmpRunID);
    }
    
    
    public func isCreateRunMode() -> Bool
    {
        return (self.projectId != "");
    }
    
    public func getDomain() -> String
    {
        return self.domain;
    }
    
    public func getUser() -> String
    {
        return self.username;
    }
    
    public func getPassword() -> String
    {
        return self.password;
    }
    
    public func setRunId(runId: String)
    {
        self.runId = runId.replacingOccurrences(of: "R", with: "");
    }
    
    public func getRunId() -> String
    {
        return self.runId;
    }
    
    public func getProjectId() -> String
    {
        return self.projectId;
    }
    
    public func getMilestoneId() -> String
    {
        return self.milestoneId;
    }
    
    public func getRunName() -> String
    {
        return self.runName;
    }
    
    public func isCloseRun() -> Bool
    {
        return self.closeRun;
    }
    
}
