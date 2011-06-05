//
//  Event.h
//  Locations
//
//  Created by Jonathon Storer on 6/5/11.
//  Copyright 2011. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Event :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSDate * creationDate;

@end



