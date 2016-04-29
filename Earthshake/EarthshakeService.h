//
//  EarthshakeRequest.h
//  Earthshake
//
//  Created by Andrey Paunov on 2016-03-24.
//  Copyright © 2016 Andrey Paunov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EarthshakeItemBuilder;

typedef NS_OPTIONS(NSUInteger, MethodType)
{
    GET,
    POST
};
typedef void (^ HTTPSuccessBlock)(NSURLSessionTask *task, id jsonObject);
typedef void (^ HTTPFailureBlock)(NSURLSessionTask *operation, NSError *error);
typedef void (^ EarthshakeSuccessBlock)(NSArray *earthshakeItems);
typedef void (^ EarthshakeFailureBlock)(NSError *error);

@protocol EarthshakeService <NSObject>

// Properties
@property (strong, nonatomic) EarthshakeItemBuilder *earthshakeItemBuilder;

// Methods
- (NSURLSessionTask *) getRequestData:(NSMutableDictionary *)parameters success:(EarthshakeSuccessBlock)success failure:(EarthshakeFailureBlock)failure;

@end
