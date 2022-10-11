//
//  TestRail.swift
//
//  Copyright © 2022 Christian Dangl. All rights reserved.
//

import Foundation
import XCTest


class TestObserver: NSObject, XCTestObservation
{
    var failedTC = 0

    private var testrail : TestRail;


    init(testrail : TestRail)
    {
        self.testrail = testrail;
    }


    public func testCaseDidFinish(_ testCase: XCTestCase)
    {
        let functionName = testCase.name;

        let regex = try! NSRegularExpression(pattern: "([_]+[C]+\\d+)")

        let matches = regex.matches(in: functionName, range: NSMakeRange(0, functionName.count));

        if (matches.isEmpty) {
            return;
        }

        let parts = functionName.components(separatedBy: "_C")
        let caseId = parts[1]

        var caseIdNumber = caseId.replacingOccurrences(of: "C", with: "")
        caseIdNumber = caseIdNumber.replacingOccurrences(of: "]", with: "")

        let hasSucceeded = (testCase.testRun?.hasSucceeded)!;
        let durationS = Int((testCase.testRun?.testDuration)!);

        // actually only PASSED is in this function
        // but better double check
        if (hasSucceeded) {
            self.testrail.testPassed(
                caseId: caseIdNumber,
                comment: "Tested by Xcode: " + functionName,
                durationS: durationS
            );
        }
    }

    public func testCase(_ testCase: XCTestCase, didFailWithDescription description: String, inFile filePath: String?, atLine lineNumber: Int)
    {
        let functionName = testCase.name;

        let regex = try! NSRegularExpression(pattern: "([_]+[C]+\\d+)")

        let matches = regex.matches(in: functionName, range: NSMakeRange(0, functionName.count));

        if (matches.isEmpty) {
            return;
        }

        let parts = functionName.components(separatedBy: "_C")
        let caseId = parts[1]

        var caseIdNumber = caseId.replacingOccurrences(of: "C", with: "")
        caseIdNumber = caseIdNumber.replacingOccurrences(of: "]", with: "")

        let durationS = Int((testCase.testRun?.testDuration)!);

        self.testrail.testFailed(
            caseId: caseIdNumber,
            comment: "Tested by Xcode: \n" + functionName + "\n" + description,
            durationS: durationS
        );

        failedTC += 1
    }

    public func testSuiteDidFinish(_ testSuite: XCTestSuite)
    {
        self.testrail.onTestRunFinished();
    }

    
}

