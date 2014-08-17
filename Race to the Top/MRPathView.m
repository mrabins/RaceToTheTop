//
//  MRPathView.m
//  Race to the Top
//
//  Created by Mark Rabins on 7/17/14.
//  Copyright (c) 2014 edu.self.edu. All rights reserved.
//

#import "MRPathView.h"
#import "MRMountainPath.h"

@implementation MRPathView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self setup];
    }
    return self;
}

-(void)setup
{
    self.backgroundColor = [UIColor clearColor];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    for (UIBezierPath *path in [MRMountainPath mountainPathsForRect:self.bounds])
    {
        [[UIColor blackColor] setStroke];
        [path stroke];
    }
}


@end
