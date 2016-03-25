//
//  EarthshakeRequest.h
//  Earthshake
//
//  Created by Andrey Paunov on 2016-03-24.
//  Copyright © 2016 Andrey Paunov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, MethodType)
{
    GET,
    POST
};

typedef void (^ EarthshakeSuccessBlock)(NSURLSessionTask *task, id jsonObject);
typedef void (^ EarthshakeFailureBlock)(NSURLSessionTask *operation, NSError *error);

@protocol EarthshakeService <NSObject>

- (NSURLSessionTask *) getRequestData: (NSDictionary *) parameters
                           success: (EarthshakeSuccessBlock) success
                           failure: (EarthshakeFailureBlock) failure;

@end
