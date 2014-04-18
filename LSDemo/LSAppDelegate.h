#import <UIKit/UIKit.h>

#define AppDelegate                     (LSAppDelegate *)[[UIApplication sharedApplication] delegate]
#define LSLocalsocial                   (RTSLocalsocial *)[RTSLocalsocial sharedInstance]

#define LS_COLOUR_ZONE_3                [UIColor colorWithRed:0.709 green:0.792 blue:0.003 alpha:1.000]
#define LS_COLOUR_ZONE_2                [UIColor colorWithRed:0.996 green:0.909 blue:0.003 alpha:1.000]
#define LS_COLOUR_ZONE_1                [UIColor colorWithRed:0.968 green:0.705 blue:0.003 alpha:1.000]
#define LS_COLOUR_ZONE_0                [UIColor colorWithRed:0.89 green:0.309 blue:0.16 alpha:1.000]

@interface LSAppDelegate : UIResponder <UIApplicationDelegate>
@end

