//
//  AppDelegate.h
//  Earthshake
//
//  Created by Andrey Paunov on 2016-03-24.
//  Copyright © 2016 Andrey Paunov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EarthshakeViewControllerFactory.h"

@interface EarthshakeAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) id<EarthshakeService> earthshakeService;

@end

