//
//  EarthshakeSettingsViewController.m
//  Earthshake
//
//  Created by Andrey Paunov on 2016-05-11.
//  Copyright © 2016 AP. All rights reserved.
//

#import "EarthshakeSettingsViewController.h"

@interface EarthshakeSettingsViewController ()

@property (strong, nonatomic) NSDictionary *sectionTitles;

@end

@implementation EarthshakeSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sectionTitles = @{NSLocalizedString(@"Notifications", nil) : @[NSLocalizedString(@"Notifications Settings", nil)],
                           NSLocalizedString(@"Measurements", nil) : @[]
                           };
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.sectionTitles allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sectionTitles objectForKey:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return ;
            break;

        case 1:
            return NSLocalizedString(@"About", nil);
            break;

        default:
            return @"";
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    cell.textLabel.text = @"Test";

    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
