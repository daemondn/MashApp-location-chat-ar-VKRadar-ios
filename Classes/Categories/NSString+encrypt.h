//
//  NSString+encrypt.h
//  Vkmsg
//
//  Created by md314 on 3/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

@interface NSString (MD5)

- (NSString *)MD5String;

@end
