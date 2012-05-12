//
//  VKNavigationBar.m
//  Vkmsg
//
//  Created by Rostislav Kobizsky on 4/9/12.
//  Copyright (c) 2012 Injoit Ltd. All rights reserved.
//

#import "VKNavigationBar.h"

@implementation VKNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 
 - (void)drawRect:(CGRect)rect {
	UIImage *image = [UIImage imageNamed: @"Header_black.png"];
	[image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
 }

@end
