//
//  XmlAnswer.h
//  BaseService
//
//

#import <Foundation/Foundation.h>


@interface XmlAnswer : RestAnswer<NSXMLParserDelegate> {
	NSMutableArray* elements;
	NSStringEncoding encodeEncoding;
	NSStringEncoding decodeEncoding;
    
    NSMutableString *elementText; 
}
@property (nonatomic,retain) NSMutableArray* elements;
@property (nonatomic,readonly) NSString *currentElement;
@property (nonatomic,readonly) NSString* prevElement;
@property (nonatomic) NSStringEncoding encodeEncoding;
@property (nonatomic) NSStringEncoding decodeEncoding;
+(NSStringEncoding)defaultEncodeEncoding;
+(NSStringEncoding)defaultDecodeEncoding;
-(id)LoadFromUrl:(NSURL*)URL parseError:(NSError **)error;
-(id)loadString:(NSString*)xmlString encoding:(NSStringEncoding)encoding parseError:(NSError **)error;
-(id)loadString:(NSString*)xmlString parseError:(NSError **)error;
-(id)loadData:(NSData*)data parseError:(NSError **)error;

//To Override
-(void)handleElement:(NSString*)elementName  attributes:(NSDictionary *)attributeDict;
-(void)handleEndOfElement:(NSString*)elementName;
-(void)handleText:(NSString*)text currentElement:(NSString*)element;
-(void)handleData:(NSData*)data currentElement:(NSString*)element;
+ (NSDate*)dateFromXMLString:(NSString*)string;
+ (NSDate *)dateFromISO8601:(NSString *)str; 
@end
