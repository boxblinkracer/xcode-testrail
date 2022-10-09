//
//  xcode_testrailTests.swift
//  xcode-testrailTests
//
//  Created by Christian Dangl on 09.10.22.
//

import XCTest
@testable import XcodeTestrail


final class IniParserTests: XCTestCase
{
    
    
    func testExistingKeyIsFound() throws
    {
        let contentINI = """
        TESTRAIL_DOMAIN=xcode.testrail.io
        """
        
        let parser = IniParser(content: contentINI);

        let value = parser.getValue(key: "TESTRAIL_DOMAIN");
        
        XCTAssertEqual("xcode.testrail.io", value);
    }
    
    func testUnknownKeyReturnsEmptyString() throws
    {
        let contentINI = """
        TESTRAIL_DOMAIN=xcode.testrail.io
        """
        
        let parser = IniParser(content: contentINI);

        let value = parser.getValue(key: "TESTRAIL_USER");
        
        XCTAssertEqual("", value);
    }
    
    func testEmptyFileReturnsEmptyString() throws
    {
        let contentINI = ""
        
        let parser = IniParser(content: contentINI);

        let value = parser.getValue(key: "TESTRAIL_USER");
        
        XCTAssertEqual("", value);
    }
    
}
