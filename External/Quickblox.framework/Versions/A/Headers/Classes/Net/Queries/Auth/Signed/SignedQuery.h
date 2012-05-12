//
//  SignedQuery.h
//  BaseService
//
//

#import <Foundation/Foundation.h>


@interface SignedQuery : Query {
	
}

-(void)signRequest:(RestRequest*)request;

@end