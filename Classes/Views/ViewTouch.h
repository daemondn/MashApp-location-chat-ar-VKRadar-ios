//
//  ViewTouch.h
//  Vkmsg
//
//  Created by Igor Khomenko on 3/30/12.
//  Copyright (c) 2012 Injoit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewTouch : UIView {
    id target;
	SEL selector;
}

-(id) initWithFrame:(CGRect)frame selector:(SEL)sel target:(id)tar;

@end