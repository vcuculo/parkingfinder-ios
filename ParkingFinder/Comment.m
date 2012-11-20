//
//  Comment.m
//  ParkingFinder
//
//  Created by Antonio Luca on 11/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Comment.h"

@implementation Comment

@synthesize idComment,text;


-(Comment*) initWithId:(int) idc andText: (NSString*) t{
    self = [super init];
    idComment=idc;
    text=t;
    return self;
}

-(NSString*) toString{
    NSString *f= @"• ";
    NSString *s=[f stringByAppendingString:text];
    return s;
}

@end
