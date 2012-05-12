//
//  NumberToLetterConverter.h
//  SuperSample
//
//  Created by Igor Khomenko on 2/21/12.
//  Copyright (c) 2012 YAS. All rights reserved.
//



@interface NumberToLetterConverter : NSObject{
    NSArray *numbersToLettersMap;
}

+ (NumberToLetterConverter *)instance;
- (NSString *) convertNumbersToLetters:(NSString *) number;

@end
