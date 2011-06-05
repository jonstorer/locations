//
//  RootViewController.m
//  Locations
//
//  Created by Jonathon Storer on 6/4/11.
//  Copyright 2011. All rights reserved.
//

#import "RootViewController.h"


@implementation RootViewController

@synthesize eventsArray;
@synthesize managedObjectContext;
@synthesize addButton;
@synthesize locationManager;

- (CLLocationManager *)locationManager {
	
	if (locationManager != nil) {
		return locationManager;
	}
	
	locationManager =[[CLLocationManager alloc] init];

	locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
	locationManager.delegate = self;
	
	return locationManager;
	
}
	
	
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation {
	addButton.enabled = YES;
}

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error {
	addButton.enabled = NO;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// Set the title.
	self.title = @"Locations";
	
	//Set up the buttons.
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
	
	addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
															  target:self
															  action:@selector(addEvent)];
	addButton.enabled = NO;
	self.navigationItem.rightBarButtonItem = addButton;
	
	// Start the location manager.
	[[self locationManager] startUpdatingLocation];
}

- (void)viewDidUnload {
	self.eventsArray = nil;
	self.locationManager = nil;
	self.addButton = nil;
}

- (void)dealloc {
	[managedObjectContext release];
	[eventsArray release];
	[locationManager release];
	[addButton release];
    [super dealloc];
}

@end
