#import "LSAppDelegate.h"
#import "Localsocial.h"
#import "RSConfiguration.h"
#import "LSPlacesCollectionViewController.h"


@interface LSAppDelegate ()
@end

@implementation LSAppDelegate

@synthesize window = _window;


/**
 *  This method deals with the configuration and registration. In order to make calls to the Server your app will need credentials. Using the RSConfiguration singleton, three elements will have to be provided. Use your account at dev.mylocalsocial.com to acquire these credentials.
 */

-(LSAppDelegate *)init
{
    self = [super init];
    
    if(self){
        RTSConfiguration *config    = [RTSConfiguration sharedInstance];
        config.client_id            = << FETCH AT dev.mylocalsocial.com >>;
        config.client_secret        = << FETCH AT dev.mylocalsocial.com >>;
        config.app_callback         = << FETCH AT dev.mylocalsocial.com >>;
        config.range                = 20000; // 20km
    }
    return self;
}


-(BOOL)                   application:(UIApplication *)application
        didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    /**
     *  Note that few notifications are registered to monitor LocalSocial's behavior.
     */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appBecomeActiveNotification:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(welcomeNotification:)
                                                 name: RSWelcomeNoticeNotification
                                               object: nil];

    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(authorizationStatusChanged:)
                                                 name: RSLocationChangeAuthorizationStatusNotification
                                               object: nil];

    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(awardNotification:)
                                                 name: RSAwardNoticeNotification
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkStartNotification:)
                                                 name: RSNetworkDidStartNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkCompletedNotification:)
                                                 name: RSNetworkDidFinishNotification
                                               object:nil];

    
    self.window                     = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"demo" bundle:nil];
    LSPlacesCollectionViewController * placesViewController = [sb instantiateViewControllerWithIdentifier:@"LSPlacesCollectionViewController"];
    
    UINavigationController *view  = [[UINavigationController alloc] initWithRootViewController: placesViewController];
    
    [view popToRootViewControllerAnimated:YES];

    [self.window setRootViewController: view];
    [self.window makeKeyAndVisible];
    
    // None of the code should even be compiled unless the Base SDK is iOS 8.0 or later
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    // The following line must only run under iOS 8. This runtime check prevents
    // it from running if it doesn't exist (such as running under iOS 7 or earlier).
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
        [application registerForRemoteNotifications];
    }
#endif
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application{

    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    
    if(![LSLocalsocial isAppRegistered]){
        [LSLocalsocial appRegister];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [LSLocalsocial willTerminate];
}

-(void)authorizationStatusChanged:(NSNotification *)notification {
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse){
        [NSTimer scheduledTimerWithTimeInterval:0.8
                                         target:self
                                       selector:@selector(discoverNearbyNoCache)
                                       userInfo:nil repeats:NO];
    }
}

-(void)discoverNearbyNoCache{
    [LSLocalsocial discoverNearbyNoCache];
}

#pragma mark - Notifications

-(void)appBecomeActiveNotification:(NSNotification *)notification {
    [self discoverAfterAuthorized];
}

-(void)discoverAfterAuthorized{
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorized:
            [LSLocalsocial discoverNearby];
            break;
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusRestricted:
        default:
            [NSTimer scheduledTimerWithTimeInterval:0.5
                                             target:self
                                           selector:@selector(discoverAfterAuthorized)
                                           userInfo:nil repeats:NO];
    }
}

/**
 *  This indicates that LocalSocial did start a remote call, either to register on the first launch, either to discover something nearby. This may be use to inform the user about such status.
 */
-(void)networkStartNotification:(NSNotification *)notification {
    
    NSDictionary *data = [notification userInfo];
    if(data){
        if([[data valueForKey:@"mode"] isEqualToString: @"register"]){
            UIApplication* app = [UIApplication sharedApplication];
            app.networkActivityIndicatorVisible = YES;
        }
        
        if([[data valueForKey:@"mode"] isEqualToString: @"discover"]){
            UIApplication* app = [UIApplication sharedApplication];
            app.networkActivityIndicatorVisible = YES;
        }
    }
}

/**
 *  This indicates that LocalSocial remote call is completed.
 */
-(void)networkCompletedNotification:(NSNotification *)notification {
    
    NSDictionary *data = [notification userInfo];
    if(data){
        if([[data valueForKey:@"mode"] isEqualToString: @"register"]){
            UIApplication* app = [UIApplication sharedApplication];
            app.networkActivityIndicatorVisible = NO;
        }
        
        if([[data valueForKey:@"mode"] isEqualToString: @"discover"]){
            UIApplication* app = [UIApplication sharedApplication];
            app.networkActivityIndicatorVisible = NO;
        }
    }
}

/**
 *  This method is called whenever a notification message should be prompted to the user. Depending on your need, this is the app responsibility to deal with either local push notification, either custom layout to display the data. Demo code does show how to extract those info.
 */
-(void)welcomeNotification:(NSNotification *)notification {

    NSDictionary * data      = [notification userInfo];
    NSString * message       = [[NSString alloc] initWithString:[data objectForKey:@"message"]];
    NSString * locationName  = [[NSString alloc] initWithString:[data valueForKey:@"place"]];
    
    if([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive){
        [self displayWelcomeInAppWith:message];
    }else{
        [self displayLocalPushNotification:[NSString stringWithFormat:@"%@ - %@", message, locationName]];
    }
}

/**
 *  This method is called whenever an award message should be prompted to the user. Depending on your need, this is the app responsibility to deal with either local push notification, either custom layout to display the data. Demo code does show how to extract those info.
 */

-(void)awardNotification:(NSNotification *)notification {
    
    NSDictionary * data         = [notification userInfo];
    NSString * points           = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@ points", [data valueForKey:@"points"]]];
    NSString * location         = [[NSString alloc] initWithString:[NSString stringWithFormat:@"@%@", [data valueForKey:@"place"]]];
    NSString * message          = [NSString stringWithFormat:@"%@ - %@", points, location];
    
    if([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive){
        [self displayWelcomeInAppWith:message];
    }else{
        [self displayLocalPushNotification:message];
    }
}

#pragma mark - User Display

-(void) displayLocalPushNotification:(NSString *) message {
    UILocalNotification *ln         = [[UILocalNotification alloc] init];
    ln.soundName                    = UILocalNotificationDefaultSoundName;
    ln.alertBody                    = message;
    ln.applicationIconBadgeNumber   = 1;
    [[UIApplication sharedApplication] presentLocalNotificationNow:ln];
}

-(void)displayWelcomeInAppWith:(NSString *)message {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
