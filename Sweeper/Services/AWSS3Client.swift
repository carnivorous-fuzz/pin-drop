//
//  AWSS3Client.swift
//  Sweeper
//
//  Created by Raina Wang on 10/14/17.
//  Copyright © 2017 team11. All rights reserved.
//

import AWSS3

class AWSS3Client {
    let transferUtility = AWSS3TransferUtility.default()

    class var sharedInstance: AWSS3Client {
        struct Static {
            static let instance = AWSS3Client()
        }
        return Static.instance
    }

    func uploadImage(for key: String, with data: Data, completionHandler: @escaping AWSS3TransferUtilityUploadCompletionHandlerBlock) {
        let expression = AWSS3TransferUtilityUploadExpression()
        
        transferUtility.uploadData(
            data,
            bucket: AWSConstans.S3BucketName,
            key: key,
            contentType: "image/png",
            expression: expression,
            completionHandler: completionHandler
        )
    }
}
