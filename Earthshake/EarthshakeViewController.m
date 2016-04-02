//
//  SecondViewController.m
//  Earthshacker
//
//  Created by Andrey Paunov on 2016-03-23.
//  Copyright © 2016 Andrey Paunov. All rights reserved.
//

#import "EarthshakeViewController.h"
#import "EarthshakeCell.h"
#import "EarthshakeAppDelegate.h"
#import "EarthshakeService.h"
#import "EarthshakeItemBuilder.h"

#define NUMBER_OF_SECTIONS 1
#define NUMBER_OF_ROWS_IN_SECTION 20

@interface EarthshakeViewController ()

// UI properties
@property (weak, nonatomic) IBOutlet UITableView *earthshakeTable;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

// Local properties
@property (strong, nonatomic) id<EarthshakeService> earthshakeService; // Protocal to interact with the request service
@property (strong, nonatomic) NSMutableArray *earthshakeItems;

@end

@implementation EarthshakeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.earthshakeTable.hidden = YES;
    [self.spinner startAnimating];

    NSDictionary *parameters = @{
                                 @"format" : @"geojson",
                                 @"starttime" : @"2016-03-31",
                                 @"endtime" : @"2016-04-02",
                                 @"limit" : @20
                                };

    self.earthshakeService = [(EarthshakeAppDelegate *)[[UIApplication sharedApplication] delegate] earthshakeService];

    [self.earthshakeService getRequestData:parameters
                                   success:^(NSArray * earthshakeItems)
    {
        self.earthshakeTable.hidden = NO;
        [self.spinner stopAnimating];

        self.earthshakeItems = [earthshakeItems copy];
        [self.earthshakeTable reloadData];
    }
                                   failure:^(NSError *error)
    {
        [self.spinner stopAnimating];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error description]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return NUMBER_OF_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.earthshakeItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"esCell";

    EarthshakeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    EarthshakeItem *earthshakeItem = [self.earthshakeItems objectAtIndex:indexPath.row];

    if (!cell)
    {
        cell = [[EarthshakeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    cell.place.text = earthshakeItem.place;
    cell.magnitude.text = [earthshakeItem.magnitude stringValue];
    cell.date.text = earthshakeItem.date;
    cell.time.text = earthshakeItem.time;
    cell.featureType.text = earthshakeItem.featureType;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 99;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
