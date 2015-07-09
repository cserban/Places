//
//  PlacesTableViewController.m
//  Places
//
//  Created by Serban Chiricescu on 08/07/15.
//  Copyright (c) 2015 Qualitance. All rights reserved.
//

#import "PlacesTableViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface PlacesTableViewController ()
@property (atomic,strong) NSMutableDictionary *resultDictionary;
@property (atomic,strong) GMSPlacesClient *placesClient;
@end

@implementation PlacesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.resultDictionary = [[NSMutableDictionary alloc] init];
    _placesClient = [[ GMSPlacesClient alloc] init];
}

-(void)viewDidAppear:(BOOL)animated
{
    for (char a = 'a'; a <= 'z'; a++)
    {
        [self placeAutocomplete:[NSString stringWithFormat:@"%c", a]];
    }
    
}

- (void)placeAutocomplete:(NSString *)key {
    
    CLLocationCoordinate2D left = CLLocationCoordinate2DMake(44.437714, 26.070900);
    CLLocationCoordinate2D right = CLLocationCoordinate2DMake(44.431278, 26.082401);
    
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
    return [[self.resultDictionary allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[self.resultDictionary objectForKey:[[self.resultDictionary allKeys] objectAtIndex:section]] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    NSArray *forKey = [self.resultDictionary objectForKey:[[self.resultDictionary allKeys] objectAtIndex:indexPath.section]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    GMSAutocompletePrediction *object = [forKey objectAtIndex:indexPath.row];
    cell.textLabel.text = object.attributedFullText.string;
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self.resultDictionary allKeys] objectAtIndex:section];
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
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *forKey = [self.resultDictionary objectForKey:[[self.resultDictionary allKeys] objectAtIndex:indexPath.section]];
    GMSAutocompletePrediction *object = [forKey objectAtIndex:indexPath.row];
    [_placesClient lookUpPlaceID:object.placeID callback:^(GMSPlace *place, NSError *error) {
        if (error != nil) {
            NSLog(@"Place Details error %@", [error localizedDescription]);
            return;
        }
        
        if (place != nil) {
            [self performSegueWithIdentifier:@"showDetails" sender:self];
        }
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
