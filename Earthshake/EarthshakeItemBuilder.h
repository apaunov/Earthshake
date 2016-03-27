//
//  EarthshakerItemBuilder.h
//  Earthshake
//
//  Created by Andrey Paunov on 2016-03-24.
//  Copyright © 2016 Andrey Paunov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EarthshakeItem.h"

@interface EarthshakeItemBuilder : NSObject

- (NSArray *) buildAllEarthshakeItems:(id)json;

@end
