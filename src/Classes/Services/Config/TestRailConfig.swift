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
    
    
    init(iniContent: String)
    {
        let iniParser = IniParser(content: iniContent);
        
        self.domain = iniParser.getValue(key: "TESTRAIL_DOMAIN");
        self.username = iniParser.getValue(key: "TESTRAIL_USER");
        self.password = iniParser.getValue(key: "TESTRAIL_PWD");
        self.runId = iniParser.getValue(key: "TESTRAIL_RUN_ID");
        
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
    
    public func getRunId() -> String
    {
        return self.runId;
    }
    
}
