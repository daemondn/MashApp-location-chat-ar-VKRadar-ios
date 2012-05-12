//
//  NSObject+performer.h
//  Vkmsg
//
//  Created by Igor Khomenko on 4/2/12.
//  Copyright (c) 2012 Injoit. All rights reserved.
//



@interface NSObject (performer)

- (void) performSelectorOnMainThread:(SEL)selector withObject:(id)arg1 withObject:(id)arg2 waitUntilDone:(BOOL)wait;

@end
