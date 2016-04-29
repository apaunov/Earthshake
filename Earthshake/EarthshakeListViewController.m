//
//  SecondViewController.m
//  Earthshacker
//
//  Created by Andrey Paunov on 2016-03-23.
//  Copyright © 2016 Andrey Paunov. All rights reserved.
//

#import "EarthshakeListViewController.h"
#import "EarthshakeCell.h"
#import "EarthshakeAppDelegate.h"
#import "EarthshakeService.h"
#import "EarthshakeItemBuilder.h"

#define NUMBER_OF_SECTIONS 1
#define NUMBER_OF_ROWS_IN_SECTION 20

@interface EarthshakeListViewController ()

// UI properties
@property (weak, nonatomic) IBOutlet UITableView *earthshakeTable;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

// Local properties
@property (strong, nonatomic) id<EarthshakeService> earthshakeService;  // Protocal to interact with the request service
@property (strong, nonatomic) NSArray *earthshakeItems;                 // All accuired items
@property (strong, nonatomic) NSArray *earthshakeItemsSearchResults;    // Search results on specific search criteria

@end

@implementation EarthshakeListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.earthshakeTable.hidden = YES;
    [self.spinner startAnimating];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];

    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay: -7];

    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDate *endTime = [NSDate date];
    NSDate *startTime = [calender dateByAddingComponents:dateComponents toDate:endTime options:0];

    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[dateFormatter stringFromDate:startTime] forKey:kStartTime];
    [parameters setObject:[dateFormatter stringFromDate:endTime] forKey:kEndTime];
    [parameters setObject:@"2.5" forKey:kMinMagnitude];

    self.earthshakeService = [(EarthshakeAppDelegate *)[[UIApplication sharedApplication] delegate] earthshakeService];

    [self.earthshakeService getRequestData: parameters
                                   success: ^(NSArray * earthshakeItems)
    {
        [self.spinner stopAnimating];
        self.earthshakeTable.hidden = NO;

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
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [self.earthshakeItemsSearchResults count];
    }
    else
    {
        return [self.earthshakeItems count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"earthshakeCell";

    EarthshakeCell *cell = [self.earthshakeTable dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell)
    {
        cell = [[EarthshakeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    EarthshakeItem *earthshakeItem = nil;

    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        // From search results
        earthshakeItem = [self.earthshakeItemsSearchResults objectAtIndex:indexPath.row];
    }
    else
    {
        // Initial data acquired
        earthshakeItem = [self.earthshakeItems objectAtIndex:indexPath.row];
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
    return 100;
}

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    NSPredicate *resultPredecate = [NSPredicate predicateWithFormat:@"place contains[c] %@", searchText];
    self.earthshakeItemsSearchResults = [self.earthshakeItems filteredArrayUsingPredicate:resultPredecate];
}

#pragma mark - Searching methods

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
