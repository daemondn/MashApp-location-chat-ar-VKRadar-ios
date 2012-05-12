//
//  DialogsTableView.h
//  Vkmsg
//
//  Created by Rostislav Kobizsky on 3/28/12.
//  Copyright (c) 2012 Injoit Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    AsyncImageCropNone,
    AsyncImageCropLong,
} AsyncImageCrop;

@interface AsyncImageView : UIImageView {
    NSURLConnection *connection;
    NSMutableData *data;
    NSString *urlString; // key for image cache dictionary
}
@property (assign) BOOL useMask;
@property (retain) NSURL *linkedUrl;

-(void)loadImageFromURL:(NSURL*)url;
-(void)remakeImage:(UIImage *)img;

@property AsyncImageCrop typeCrop;

@end
