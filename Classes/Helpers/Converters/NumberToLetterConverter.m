//
//  NumberToLetterConverter.m
//  SuperSample
//
//  Created by Igor Khomenko on 2/21/12.
//  Copyright (c) 2012 YAS. All rights reserved.
//

#import "NumberToLetterConverter.h"

static NumberToLetterConverter *g_instance;

@implementation NumberToLetterConverter

/**
 Singleton
 */
+ (NumberToLetterConverter *)instance {
    if( g_instance == nil ) {
        g_instance = [[NumberToLetterConverter alloc] init];
    }
    
    return( g_instance );
}

- (id)init {
    self = [super init];
    if( self ) {
        numbersToLettersMap = [[NSArray alloc] initWithObjects:@"a", @"b", @"c", @"d", @"f", @"g", @"h", @"i", @"g", @"k", nil];
    }
    return( self );
}

- (void) dealloc{
    [numbersToLettersMap release];
    [super dealloc];
}

- (NSString *) convertNumbersToLetters:(NSString *) numbers{
    NSMutableString *result = [NSMutableString string];
    
    DLog(@"numbers=%@", [numbers class]);
    
    int len = 0;
    NSMutableArray *separetedNumbers = [[NSMutableArray alloc] init];
    while(len < [numbers length]) {
        NSString *num = [numbers substringWithRange:NSMakeRange(len, 1)];
        [separetedNumbers addObject:num];
        ++len;
    }
    
    for(NSString *number in separetedNumbers){
        [result appendString:[numbersToLettersMap objectAtIndex:[number intValue]]];
    }
	
	[separetedNumbers release];
    
    return result;
}

@end
