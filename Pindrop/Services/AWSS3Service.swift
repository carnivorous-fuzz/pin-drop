//
//  AWSS3Service.swift
//  Pindrop
//
//  Created by Raina Wang on 10/14/17.
//  Copyright © 2017 team11. All rights reserved.
//

import AWSS3

class AWSS3Service {
    let transferUtility = AWSS3TransferUtility.default()

    class var sharedInstance: AWSS3Service {
        struct Static {
            static let instance = AWSS3Service()
        }
        return Static.instance
    }

    func uploadImage(for key: String, with data: Data, completion: @escaping AWSS3TransferUtilityUploadCompletionHandlerBlock) {
        let expression = AWSS3TransferUtilityUploadExpression()
        
        transferUtility.uploadData(
            data,
            bucket: AWSConstants.S3BucketName,
            key: key,
            contentType: "image/png",
            expression: expression,
            completionHandler: completion
        )
    }
}
