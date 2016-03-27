//
//  EarthshakeBuilderFactory.h
//  Earthshake
//
//  Created by Andrey Paunov on 2016-03-26.
//  Copyright © 2016 Andrey Paunov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EarthshakeItemBuilder.h"

@interface EarthshakeModelFactory : NSObject

@property (strong, nonatomic) EarthshakeItemBuilder *earthshakeItemBuilder;

- (EarthshakeItemBuilder *) createEarthshakeItemBuilder;

@end
