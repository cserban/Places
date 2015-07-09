//
//  DetailsViewController.m
//  Places
//
//  Created by Serban Chiricescu on 09/07/15.
//  Copyright (c) 2015 Qualitance. All rights reserved.
//

#import "DetailsViewController.h"
#define METERS_PER_MILE 1609.344

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {

    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.place.coordinate, 1*METERS_PER_MILE, 1*METERS_PER_MILE);
    [_mapView setRegion:viewRegion animated:YES];
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:self.place.coordinate];
    [annotation setTitle:self.place.name]; //You can set the subtitle too
    [self.mapView addAnnotation:annotation];
}



- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}

@end
