//
//  Comment.h
//  ParkingFinder
//
//  Created by Antonio Luca on 11/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject{
    int idComment;
    NSString *text;
}

-(Comment*) initWithId:(int) idc andText: (NSString*) t;
-(NSString*) toString;
@property int idComment;
@property (nonatomic,retain) NSString *text;
@end
