//
//  SecondViewController.m
//  Earthshacker
//
//  Created by Andrey Paunov on 2016-03-23.
//  Copyright © 2016 Andrey Paunov. All rights reserved.
//

#import "EarthshakeListViewController.h"
#import "EarthshakeDetailsViewController.h"
#import "EarthshakeCell.h"
#import "EarthshakeItemBuilder.h"

#define NUMBER_OF_SECTIONS 1
#define NUMBER_OF_ROWS_IN_SECTION 20

@interface EarthshakeListViewController ()

// UI properties
@property (weak, nonatomic) IBOutlet UITableView *earthshakeTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

// Local properties
@property (strong, nonatomic) NSArray *earthshakeItems;                         // All accuired items
@property (strong, nonatomic) NSArray *earthshakeItemsSearchResults;            // Search results on specific search criteria
@property (strong, nonatomic) NSString *showEarthshakeDetailsSegueIdentifier;   // Identifier to help distinguish between segues

@end

@implementation EarthshakeListViewController

#pragma mark - Delegate methods

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.showEarthshakeDetailsSegueIdentifier = @"ShowEarthshakeDetails";

    [self loadTableData];
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

    EarthshakeCell *cell = [self.earthshakeTableView dequeueReusableCellWithIdentifier:cellIdentifier];

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
    cell.magnitude.text = [self.decimalFormatter stringFromNumber:earthshakeItem.magnitude];
    cell.magnitude.backgroundColor = [self determineMagnitudeColor:earthshakeItem.magnitude];
    cell.date.text = earthshakeItem.date;
    cell.time.text = earthshakeItem.time;

    if ([earthshakeItem isEarthquake])
    {
        [cell.earthshakeImageView setImage:[UIImage imageNamed:@"Earthquake"]];
    }
    else if ([earthshakeItem isQuarry])
    {
        [cell.earthshakeImageView setImage:[UIImage imageNamed:@"Explosion"]];
    }

    if ([earthshakeItem.tsunami intValue] == 1)
    {
        [cell.tsunamiImageView setImage:[UIImage imageNamed:@"Tsunami"]];
    }
    else
    {
        cell.tsunamiImageView.image = nil;
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    EarthshakeCell *cell = [[EarthshakeCell alloc] init];
//    EarthshakeItem *earthshakeItem = [self.earthshakeItems objectAtIndex:indexPath.row];
//
//    // Initial height
//    CGFloat height = 30.0f;
//
//    height += [cell.magnitude.text sizeWithAttributes:@{NSFontAttributeName: cell.magnitude.font}].height;
//
//    NSLog(@"Total height: %f", height);

//    if ([earthshakeItem.tsunami intValue] == 1)
//    {
//        return 116;
//    }

    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    NSPredicate *resultPredecate = [NSPredicate predicateWithFormat:@"place contains[c] %@", searchText];
    self.earthshakeItemsSearchResults = [self.earthshakeItems filteredArrayUsingPredicate:resultPredecate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Searching methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    if ([segue.identifier isEqualToString:self.showEarthshakeDetailsSegueIdentifier])
    {
        if ([segue.destinationViewController isKindOfClass:[EarthshakeDetailsViewController class]])
        {
            EarthshakeDetailsViewController *destinationViewController = segue.destinationViewController;
            EarthshakeItem *earthshakeItem;

            if (self.searchDisplayController.active)
            {
                earthshakeItem = [self.earthshakeItemsSearchResults objectAtIndex:self.searchDisplayController.searchResultsTableView.indexPathForSelectedRow.row];
            }
            else
            {
                earthshakeItem = [self.earthshakeItems objectAtIndex:self.earthshakeTableView.indexPathForSelectedRow.row];
            }

            destinationViewController.detailURLString = earthshakeItem.detailURLString;
        }
    }
}

#pragma mark - Helper methods

- (UIColor *)determineMagnitudeColor:(NSNumber *)magnitude
{
    float mag = [magnitude floatValue];
    UIColor *color = [UIColor whiteColor];

    if (1.0 < mag && mag < 3.0)
    {
        color = [UIColor colorWithRed:(255.0 / 255.0) green:(230.0 / 255.0) blue:(230.0 / 255.0) alpha:1.0];
    }
    else if (3.0 <= mag && mag < 4.0)
    {
        color = [UIColor colorWithRed:(255.0 / 255.0) green:(204.0 / 255.0) blue:(204.0 / 255.0) alpha:1.0];
    }
    else if (4.0 <= mag && mag < 5.0)
    {
        color = [UIColor colorWithRed:(255.0 / 255.0) green:(153.0 / 255.0) blue:(153.0 / 255.0) alpha:1.0];
    }
    else if (5.0 <= mag && mag < 6.0)
    {
        color = [UIColor colorWithRed:(255.0 / 255.0) green:(128.0 / 255.0) blue:(128.0 / 255.0) alpha:1.0];
    }
    else if (6.0 <= mag && mag < 7.0)
    {
        color = [UIColor colorWithRed:(255.0 / 255.0) green:(102.0 / 255.0) blue:(102.0 / 255.0) alpha:1.0];
    }
    else if (7.0 <= mag)
    {
        color = [UIColor colorWithRed:(255.0 / 255.0) green:0.0 blue:0.0 alpha:1.0];
    }

    return color;
}

- (void)loadTableData
{
    self.earthshakeTableView.hidden = YES;
    [self.spinner startAnimating];

    [super getRequestDataSuccess:^(NSArray * earthshakeItems)
    {
        [self.spinner stopAnimating];

        self.earthshakeItems = [earthshakeItems copy];
        self.earthshakeTableView.hidden = NO;

        [self.earthshakeTableView reloadData];
    }
                         failure:^(NSError *error)
    {
        [self.spinner stopAnimating];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error"
                                                        message: error.localizedDescription
                                                       delegate: self
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles: nil, nil];
        [alert show];
    }];
}

- (void)didSelectRefresh
{
    [super didSelectRefresh];

    [self loadTableData];
}

@end
