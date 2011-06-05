//
//  RootViewController.m
//  Locations
//
//  Created by Jonathon Storer on 6/4/11.
//  Copyright 2011. All rights reserved.
//

#import "RootViewController.h"
#import "Event.h"


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

- (void)addEvent {
	CLLocation *location = [locationManager location];
	if(!location){
		return;
	}
	
	Event *event = (Event *)[NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:managedObjectContext];
	
	CLLocationCoordinate2D coordinate = [location coordinate];
	
	[event setLatitude:[NSNumber numberWithDouble:coordinate.latitude]];
	[event setLongitude:[NSNumber numberWithDouble:coordinate.longitude]];
	[event setCreationDate:[NSDate date]];
	
	NSError *error = nil;
	if (![managedObjectContext save:&error]) {
		// Handle the error
	}
	
	[eventsArray insertObject:event atIndex:0];
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
						  withRowAnimation:UITableViewRowAnimationFade];
	[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] 
						  atScrollPosition:UITableViewScrollPositionTop animated:YES];
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [eventsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// A date formatter for the time stamp.
	static NSDateFormatter *dateFormatter = nil;
	if (dateFormatter == nil){
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	}
	
	// A number formatter for the latitude and longitude.
	static NSNumberFormatter *numberFormatter = nil;
	if (numberFormatter == nil) {
		numberFormatter = [[NSNumberFormatter alloc] init];
		[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
		[numberFormatter setMaximumFractionDigits:3];
	}
	
	
	static NSString *CellIdentifier = @"Cell";
	
	// Dequeue or create a new cell.
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
	
	Event *event =(Event *)[eventsArray objectAtIndex:indexPath.row];
	
	cell.textLabel.text =[dateFormatter stringFromDate:[event creationDate]];
	
	NSString *string = [NSString stringWithFormat:@"%@, %@",
						[numberFormatter stringFromNumber:[event latitude]],
						[numberFormatter stringFromNumber:[event longitude]]];
	
	cell.detailTextLabel.text = string;
	
	return cell;
}

@end
