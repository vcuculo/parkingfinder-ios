//
//  ParkingOverlayView.m
//  ParkingFinder
//
//  Created by Vittorio Cuculo on 04/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ParkingView.h"

@implementation ParkingView

- (id)initWithAnnotation:(id <MKAnnotation>)annotation 
         reuseIdentifier:(NSString *)reuseIdentifier {
    
    if(self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setAnnotation:(id <MKAnnotation>)annotation {
    super.annotation = annotation;
    
    if([annotation isMemberOfClass:[ParkingAnnotation class]]) {
        parking = (ParkingAnnotation *)annotation;
        self.image = [UIImage imageNamed:@"car_icon.png"]; 
    } else {
        self.image = [UIImage imageNamed:@"undefined_park.png"];
    }
}

- (void)dealloc {
    [parking release];
    [super dealloc];
}

@end
