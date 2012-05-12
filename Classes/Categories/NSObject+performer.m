//
//  NSObject+performer.m
//  Vkmsg
//
//  Created by Igor Khomenko on 4/2/12.
//  Copyright (c) 2012 Injoit. All rights reserved.
//

#import "NSObject+performer.h"

@implementation NSObject (performer)

- (void) performSelectorOnMainThread:(SEL)selector withObject:(id)arg1 withObject:(id)arg2 waitUntilDone:(BOOL)wait{
    NSMethodSignature *sig = [self methodSignatureForSelector:selector];
    if (!sig) {
        return;
    }
    
    NSInvocation *invo = [NSInvocation invocationWithMethodSignature:sig];
    [invo setTarget:self];
    [invo setSelector:selector];
    [invo setArgument:&arg1 atIndex:2];
    [invo setArgument:&arg2 atIndex:3];
    [invo retainArguments];
    [invo performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:wait];
}

@end
