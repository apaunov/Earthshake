//
//  EarthshakeRequestImpl.m
//  Earthshacker
//
//  Created by Andrey Paunov on 2016-03-24.
//  Copyright © 2016 Andrey Paunov. All rights reserved.
//

#import "EarthshakeServiceImpl.h"
#import "AFHTTPSessionManager.h"
#import "EarthshakeItemBuilder.h"

#define USGS_END_EVENT_POINT @"http://earthquake.usgs.gov/fdsnws/event/1/"

@implementation EarthshakeServiceImpl

@synthesize earthshakeItemBuilder;

- (NSURLSessionTask *)getRequestData:(NSDictionary *)parameters success:(EarthshakeSuccessBlock)success failure:(EarthshakeFailureBlock)failure
{
    NSString *endPoint = [NSString stringWithFormat: @"%@query", USGS_END_EVENT_POINT];
    NSURL *url = [NSURL URLWithString: endPoint];
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];

    HTTPSuccessBlock successBlock = ^(NSURLSessionTask * task, id jsonObject)
    {
        NSArray *earthshakeItems = [self.earthshakeItemBuilder buildAllEarthshakeItems:(NSDictionary *)jsonObject];

        if (success)
        {
            success(earthshakeItems);
        }
    };

    HTTPFailureBlock failureBlock = ^(NSURLSessionTask *operation, NSError *error)
    {
        if (failure)
        {
            failure(error);
        }
    };

    return [sessionManager GET:url.absoluteString parameters:parameters progress:nil success:successBlock failure:failureBlock];
}

@end