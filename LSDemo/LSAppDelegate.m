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
        config.client_id            = << fetch at dev.mylocalsocial.com >>;
        config.client_secret        = << fetch at dev.mylocalsocial.com >>;
        config.app_callback         = << fetch at dev.mylocalsocial.com >>;
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

#pragma mark - Notifications

-(void)appBecomeActiveNotification:(NSNotification *)notification {
    [LSLocalsocial discoverNearby];
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
