//
//  EarthshakeViewControllerFactory.h
//  Earthshake
//
//  Created by Andrey Paunov on 2016-03-26.
//  Copyright © 2016 Andrey Paunov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EarthshakeService;

@interface EarthshakeViewControllerFactory : NSObject

@property (weak, nonatomic) id<EarthshakeService> earthshakeService;

@end
