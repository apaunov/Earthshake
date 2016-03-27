//
//  EarthshakeServiceFactory.h
//  Earthshake
//
//  Created by Andrey Paunov on 2016-03-26.
//  Copyright © 2016 Andrey Paunov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EarthshakeModelFactory;

@protocol EarthshakeService;

@interface EarthshakeServiceFactory : NSObject

@property (strong, nonatomic) EarthshakeModelFactory *earthshakeModelFactory;

- (id<EarthshakeService>) createEarthshakeService;

@end
