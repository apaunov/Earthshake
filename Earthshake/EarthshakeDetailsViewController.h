//
//  EarthshakeDetailsViewController.h
//  Earthshake
//
//  Created by Andrey Paunov on 2016-04-29.
//  Copyright © 2016 AP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EarthshakeBaseViewController.h"

@interface EarthshakeDetailsViewController : EarthshakeBaseViewController <UIWebViewDelegate>

@property (strong, nonatomic) NSString *detailURLString;

@end
