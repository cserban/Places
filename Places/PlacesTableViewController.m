//
//  PlacesTableViewController.m
//  Places
//
//  Created by Serban Chiricescu on 08/07/15.
//  Copyright (c) 2015 Qualitance. All rights reserved.
//

#import "PlacesTableViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "PlacesTableViewCell.h"
#import "DetailsViewController.h"

@interface PlacesTableViewController ()
@property (atomic,strong) NSMutableDictionary *resultDictionary;
@property (atomic,strong) GMSPlacesClient *placesClient;
@property (atomic,strong) NSMutableArray *keys;
@property (atomic,strong) GMSPlace *place;
@property (nonatomic, strong) PositionManager *positionmanager;
@end

@implementation PlacesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.resultDictionary = [[NSMutableDictionary alloc] init];
    _placesClient = [[ GMSPlacesClient alloc] init];
    _keys = [[NSMutableArray alloc] init];
    for (char a = 'a'; a <= 'z'; a++)
    {
       [_keys addObject:[NSString stringWithFormat:@"%c", a]];
    }
    self.positionmanager = [PositionManager sharedInstance];
    self.positionmanager.delegate = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(reloadLocations)
                  forControlEvents:UIControlEventValueChanged];
}

-(void)reloadLocations
{
    [self.positionmanager requestLocation];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.positionmanager requestLocation];
}

-(void)myPosition:(CLLocation *)currentLocation
{
    [self.refreshControl endRefreshing];
    for (char a = 'a'; a <= 'z'; a++)
    {
        [self placeAutocompleteForLocation:currentLocation andKey:[NSString stringWithFormat:@"%c", a]];
    }
}



- (BOOL)hidesBottomBarWhenPushed {
    return NO;
}

- (void)placeAutocompleteForLocation:(CLLocation *)location andKey:(NSString *)key {
    
    CLLocationCoordinate2D left = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    CLLocationCoordinate2D right = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:left coordinate:right];
    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    filter.type = kGMSPlacesAutocompleteTypeFilterNoFilter;
    
    
    
    [_placesClient autocompleteQuery:key
                              bounds:bounds
                              filter:nil
                            callback:^(NSArray *results, NSError *error) {
                                if (error != nil) {
                                    NSLog(@"Autocomplete error %@", [error localizedDescription]);
                                    return;
                                }
                                [self.resultDictionary setObject:results forKey:key];
                                [self.tableView reloadData];
                            }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [_keys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[self.resultDictionary objectForKey:[_keys objectAtIndex:section]] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifierOdd = @"oddCell";
        static NSString *CellIdentifierEven = @"evenCell";
    NSArray *forKey = [self.resultDictionary objectForKey:[_keys objectAtIndex:indexPath.section]];
    PlacesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:(indexPath.row % 2 == 0) ? CellIdentifierOdd : CellIdentifierEven];
    if (cell == nil) {
        cell = [[PlacesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:(indexPath.row % 2 == 0) ? CellIdentifierOdd : CellIdentifierEven];
    }
    GMSAutocompletePrediction *object = [forKey objectAtIndex:indexPath.row];
    cell.label.text = object.attributedFullText.string;
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_keys objectAtIndex:section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20.0;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DetailsViewController *detailsViewController = segue.destinationViewController;
    detailsViewController.place = self.place;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *forKey = [self.resultDictionary objectForKey:[_keys objectAtIndex:indexPath.section]];
    GMSAutocompletePrediction *object = [forKey objectAtIndex:indexPath.row];
    [_placesClient lookUpPlaceID:object.placeID callback:^(GMSPlace *place, NSError *error) {
        if (error != nil) {
            NSLog(@"Place Details error %@", [error localizedDescription]);
            return;
        }
        
        if (place != nil) {
            self.place = place;
            [self performSegueWithIdentifier:@"showDetails" sender:self];
        }
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }];
}

@end
