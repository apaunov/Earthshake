//
//  EarthshakeBuilderFactory.m
//  Earthshake
//
//  Created by Andrey Paunov on 2016-03-26.
//  Copyright © 2016 Andrey Paunov. All rights reserved.
//

#import "EarthshakeModelFactory.h"

@implementation EarthshakeModelFactory

- (EarthshakeItemBuilder *) createEarthshakeItemBuilder
{
    if (self.earthshakeItemBuilder)
    {
        return self.earthshakeItemBuilder;
    }

    self.earthshakeItemBuilder = [[EarthshakeItemBuilder alloc] init];

    return self.earthshakeItemBuilder;
}

@end
