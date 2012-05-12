//
//  MapChatARViewController.h
//  Vkmsg
//
//  Created by Alexey on 21.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "MapViewController.h"
#import "ChatViewController.h"
#import "AugmentedRealityController.h"

@interface MapChatARViewController : UIViewController <ActionStatusDelegate, VKServiceResultDelegate, UIActionSheetDelegate>{
    BOOL isFirstAppear;
    
    // selected user
    NSDictionary *selectedVKUser;
    
    NSMutableArray *chatIDs;
    
    NSTimer *updateTimre;
}
@property (nonatomic, retain) NSMutableArray *mapPoints;
@property (nonatomic, retain) NSMutableArray *chatPoints;
@property (nonatomic, retain) UIActionSheet *userActionSheet;

@property (nonatomic, retain) IBOutlet MapViewController *mapViewController;
@property (nonatomic, retain) IBOutlet ChatViewController *chatViewController;
@property (nonatomic, retain) IBOutlet AugmentedRealityController *arViewController;

@property (nonatomic, assign) UISegmentedControl *segmentControl;


- (void)segmentValueDidChanged:(id)sender;
- (void)showRadar;
- (void)showChat;
- (void)showMap;

- (void)addNewAnnotationToMapChatARForVKUser:(NSDictionary *)vkUser withGeoData:(QBLGeoData *)geoData;

- (void)touchOnMarker:(UIView *)marker;

@end
