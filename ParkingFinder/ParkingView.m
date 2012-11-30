//
//  ParkingOverlayView.m
//  ParkingFinder
//
//  Created by Vittorio Cuculo on 04/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ParkingView.h"
#define FIVE_MINUTES 300000
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
            long time = [p time];

            if (time <= FIVE_MINUTES)
                self.alpha = 1;
            else if(time > FIVE_MINUTES && time <= FIVE_MINUTES * 2)
                self.alpha = 0.5f;
            else if (time > FIVE_MINUTES * 2)       
                self.alpha = 0.3f;
            
            NSInteger type = [p type];
            switch (type) {
                case 1:
                    self.image = [UIImage imageNamed:@"free_park.png"];
                    break;
                case 2:
                    self.image = [UIImage imageNamed:@"toll_park.png"];
                    break;
                case 3:
                    self.image = [UIImage imageNamed:@"reserved_park.png"]; 
                    break;
                case 4:
                    self.image = [UIImage imageNamed:@"disabled_park.png"]; 
                    break;
                case 5:
                    self.image = [UIImage imageNamed:@"timed_park.png"]; 
                    break;
                default:
                    self.image = [UIImage imageNamed:@"undefined_park.png"]; 
                    break;

            }
        }
    }
}

- (void)dealloc {
    [parkingAnnotation release];
    [super dealloc];
}

@end
