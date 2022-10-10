//
//  TestRail.swift
//
//  Copyright © 2022 Christian Dangl. All rights reserved.
//
import Foundation

class TestRailClient
{

    private var baseUrl : String;
    private var domain : String;
    private var username : String;
    private var password : String;



    init(domain : String, username : String, password : String)
    {
        self.domain = domain;
        self.username = username;
        self.password = password;

        self.baseUrl = "https://" + domain + "/index.php?/api/v2";
    }


    public func isConfigValid() -> Bool
    {
        if (self.domain == "")
        {
            return false;
        }

        if (self.username == "")
        {
            return false;
        }

        if (self.password == "")
        {
            return false;
        }

        return true;
    }

    public func sendResult(runId : String, caseId: String, statusId : Int, durationS : Int, comment : String)
    {
        do {

            var result :Dictionary<String, Any> = Dictionary<String,Any>();

            if (durationS > 0) {
                result =  [
                    "results" : [
                        [
                            "case_id" : caseId,
                            "status_id" : statusId,
                            "comment" : comment,
                            "elapsed" : (String(durationS) + "s")
                        ]
                    ]
                ]
            } else {
                result = [
                    "results" : [
                        [
                            "case_id" : caseId,
                            "status_id" : statusId,
                            "comment" : comment,
                        ]
                    ]
                ]
            }


            try self.postRequest(slug: "/add_results_for_cases/" + String(runId), body: result);

            print ("TestRail Result sent for case C" + String(caseId));

        } catch {
            print(error)
        }
    }

    private func postRequest(slug : String, body: Dictionary<String, Any>) throws {

        let fullUrl = self.baseUrl + slug;

        let url = URL(string: fullUrl)!
        let authData = (self.username + ":" + self.password).data(using: .utf8)!.base64EncodedString()

        let finalBody = try? JSONSerialization.data(withJSONObject: body)

        var request = URLRequest(url: url)
        request.addValue("Basic " + authData, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST";
        request.httpBody = finalBody;

        let semaphore = DispatchSemaphore(value: 0)

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

            if let error = error {
                print("TestRail Response Error: \(error)")
                return
            }

            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("TestRail Response: \(dataString)")
            }

            semaphore.signal();
        }

        task.resume();
        _ = semaphore.wait(timeout: DispatchTime.distantFuture);
    }

}
