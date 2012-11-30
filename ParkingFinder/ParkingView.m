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
        parkingAnnotation = (ParkingAnnotation *)annotation;
        
        if([parkingAnnotation mycar])
            //releasing parking
            self.image = [UIImage imageNamed:@"car_icon.png"]; 
        else{
            //check parking type
            Parking* p = [parkingAnnotation parking];
            NSInteger type = [p type];
            // switch..case
        }
    }
}

- (void)dealloc {
    [parkingAnnotation release];
    [super dealloc];
}

@end
