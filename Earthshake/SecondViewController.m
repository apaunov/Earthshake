//
//  SecondViewController.m
//  Earthshacker
//
//  Created by Andrey Paunov on 2016-03-23.
//  Copyright © 2016 Andrey Paunov. All rights reserved.
//

#import "SecondViewController.h"
#import "EarthshakeService.h"

#define NUMBER_OF_SECTIONS 1
#define NUMBER_OF_ROWS_IN_SECTION 20

@interface SecondViewController ()

@property (weak, nonatomic) IBOutlet UITableView *earthquakeTableView;  // 
@property (weak, nonatomic) id<EarthshakeService> earthshakeService;    // Protocal to intereact with the request service

@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSDictionary *parameters = @{
                                 @"format" : @"geojson",
                                 @"starttime" : @"2014-01-01",
                                 @"endtime" : @"2014-01-02"
                                };

    EarthshakeSuccessBlock successBlock = ^(NSURLSessionTask * task, id jsonObject)
    {
        
    };

    EarthshakeFailureBlock failureBlock = ^(NSURLSessionTask *operation, NSError *error)
    {
        
    };

    [self.earthshakeService getRequestData: parameters
                                   success: successBlock
                                   failure: failureBlock];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return NUMBER_OF_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return NUMBER_OF_ROWS_IN_SECTION;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"esCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
