//
//  EarthshakeServiceFactory.m
//  Earthshake
//
//  Created by Andrey Paunov on 2016-03-26.
//  Copyright © 2016 Andrey Paunov. All rights reserved.
//

#import "EarthshakeServiceFactory.h"
#import "EarthshakeModelFactory.h"
#import "EarthshakeServiceImpl.h"

@implementation EarthshakeServiceFactory
{
    id<EarthshakeService> earthshakeService;
}

- (id<EarthshakeService>) createEarthshakeService
{
    if (!earthshakeService)
    {
        earthshakeService = [[EarthshakeServiceImpl alloc] init]; // EarthshakeServiceImpl complies with the EarthshakeService protocol
        earthshakeService.earthshakeItemBuilder = [self.earthshakeModelFactory createEarthshakeItemBuilder];
    }

    return earthshakeService;
}

@end
