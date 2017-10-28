//
//  CloudLogicAPIFactory.swift
//  MySampleApp
//
//
// Copyright 2017 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.19
//

import Foundation
import AWSCore
import AWSAuthCore

class CloudLogicAPIFactory {
    static var supportedCloudLogicAPIs: [CloudLogicAPI] {
        
        return [
            CloudLogicAPI(displayName: "ConsenstSys API",
                apiDescription: "",
                paths: [
                 "/transaction", "/transaction/123",                ],
                endPoint: "https://q0fkju3xj7.execute-api.us-east-1.amazonaws.com/Development",
                apiClient: AWSAPI_Q0FKJU3XJ7_ConsenstSysAPIMobileHubClient(forKey: AWSCloudLogicDefaultConfigurationKey)
            ),
        ]
    }
    
    
    static func setupCloudLogicAPIs() {
        let serviceConfiguration = AWSServiceConfiguration(region: AWSCloudLogicDefaultRegion, credentialsProvider: AWSIdentityManager.default().credentialsProvider)
        AWSAPI_Q0FKJU3XJ7_ConsenstSysAPIMobileHubClient.register(with: serviceConfiguration!, forKey: AWSCloudLogicDefaultConfigurationKey)
    }
}
