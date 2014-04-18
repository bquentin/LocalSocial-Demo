#import <UIKit/UIKit.h>

#import "Localsocial.h"
#import "LSAppDelegate.h"
#import "LSShopzonesCollectionViewController.h"
#import "LSPlacesCollectionViewController.h"


@interface LSPlacesCollectionViewController ()
@end

@implementation LSPlacesCollectionViewController{
    NSMutableArray * places;
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Places", @"Places");
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(objectsChangedNotification:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(objectsChangedNotification:)
                                                 name:RSObjectsDidUpdateNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(objectsChangedNotification:)
                                                 name: RSNetworkDidFinishNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userRegisterStartNotification:)
                                                 name: RSProfileStartUpdateNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userRegisterCompletedNotification:)
                                                 name:RSProfileDidUpdateNotification
                                               object:nil];
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:@"Register"
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self
                                                                     action:@selector(registerUserWithLocalsocial)];
    self.navigationItem.rightBarButtonItem = btn;
    
    UIImageView *titleImageView                 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    titleImageView.frame                        = CGRectMake(0.0, 0.0, 138.0, 40.0);
    self.navigationItem.titleView               = titleImageView;
    self.collectionView.alwaysBounceVertical    = YES;
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
    places = [[LSLocalsocial getNearbyPlaces] mutableCopy];
}

#pragma mark - Collection view methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [places count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell      = [collectionView dequeueReusableCellWithReuseIdentifier:@"LSPlaceViewCell"
                                                                                forIndexPath:indexPath];

    RTSPlace * place                = [places objectAtIndex:indexPath.row];
    UILabel * place_name            = (UILabel *) [cell viewWithTag:101];
    
    place_name.text                 = [place name];
    place_name.backgroundColor      = [UIColor lightGrayColor];

    if([[place proximity] boolValue] && [[place priority] boolValue] < 2 ){
        switch ([[place priority] intValue])
        {
            case 0:
                place_name.backgroundColor      = LS_COLOUR_ZONE_0;
                break;
            case 1:
                place_name.backgroundColor      = LS_COLOUR_ZONE_1;
                break;
            case 2:
                place_name.backgroundColor      = LS_COLOUR_ZONE_2;
                break;
//            case 3:
//                place_name.backgroundColor      = LS_COLOUR_ZONE_3;
//                break;
            default:
                break;
        }
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RTSPlace * place = [places objectAtIndex:indexPath.row];
    place = [LSLocalsocial queryPlace:place];
    
    if([[place shopzones] count] != 0){
 
        // When the current "place" has shopzones, then switch to the shopzone view.
        
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"demo" bundle:nil];
        LSShopzonesCollectionViewController * shopzonesViewController = [sb instantiateViewControllerWithIdentifier:@"LSShopzonesCollectionViewController"];
        shopzonesViewController.place = place;
        [self.navigationController pushViewController:shopzonesViewController animated:YES];
        
    }else{
        
        // Display detailed information regarding the selected place.
        // THIS DOES NOT DISPLAY ALL THE ATTRIBUTES. Refer to the documentationfor full attributes listings.
    
        NSString  *content = @"";
        content = [content stringByAppendingString:@"Name:"];
        content = [content stringByAppendingString:[place name]];
        content = [content stringByAppendingString:@"\n"];

        content = [content stringByAppendingString:@"Category:"];
        content = [content stringByAppendingString:[place category]];
        content = [content stringByAppendingString:@"\n"];
        
        content = [content stringByAppendingString:@"Address:"];
        content = [content stringByAppendingString:[place address]];
        content = [content stringByAppendingString:@"\n"];
        
        content = [content stringByAppendingString:@"Latitude:"];
        content = [content stringByAppendingString:[[place longitude] stringValue]];
        content = [content stringByAppendingString:@"\n"];
        
        content = [content stringByAppendingString:@"Latitude:"];
        content = [content stringByAppendingString:[[place longitude] stringValue]];
        content = [content stringByAppendingString:@"\n"];
        
        content = [content stringByAppendingString:@"Image:"];
        if([place url_image]){
            content = [content stringByAppendingString:[place url_image]];
            content = [content stringByAppendingString:@"\n"];
        }
        
        content = [content stringByAppendingString:@"Shopzones:"];
        content = [content stringByAppendingString:[NSString stringWithFormat:@"%i", [[place shopzones] count]]];
        content = [content stringByAppendingString:@"\n"];
        
        content = [content stringByAppendingString:@"=== Offers ==="];
        content = [content stringByAppendingString:@"\n"];
        
        for(RTSOffer * offer in [place offers]){
            
            content = [content stringByAppendingString:@"Name:"];
            content = [content stringByAppendingString:[offer name]];
            content = [content stringByAppendingString:@"\n"];
            
            content = [content stringByAppendingString:@"Image:"];
            if([offer url_image]){
                content = [content stringByAppendingString:[offer url_image]];
                content = [content stringByAppendingString:@"\n"];
            }
        }
        
        content = [content stringByAppendingString:@"=== Products ==="];
        content = [content stringByAppendingString:@"\n"];
        
        for(RTSProduct * product in [place products]){
            
            content = [content stringByAppendingString:@"Name:"];
            content = [content stringByAppendingString:[product name]];
            content = [content stringByAppendingString:@"\n"];
            
            content = [content stringByAppendingString:@"Description:"];
            content = [content stringByAppendingString:[product description_1]];
            content = [content stringByAppendingString:@"\n"];
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Place Content"
                                                        message:content
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    
    }
}


#pragma mark - User Action

-(void)registerUserWithLocalsocial {
    /* LocalSocial user regisgration requires the current navigation controler OR App delegate will work */
    [LSLocalsocial appRegisterUserWithLocalsocial:self.navigationController];
}


#pragma mark - Notifications

/**
 *  This is called when new information regarding the proximity has been received and are ready to be fetched by the app. (likely to indicate that app should show something to the user..)
 */
-(void)objectsChangedNotification: (NSNotification *)notification {
    
    // NSDictionary *data = [notification userInfo];
    // The data would give enough details to update a specific object. For the demo purporse, I just reload it all.
    dispatch_async(dispatch_get_main_queue(), ^{
        
        places = [[LSLocalsocial getNearbyPlaces] mutableCopy];
        [self.collectionView reloadData];
        
    });
}

-(void)userRegisterStartNotification:(NSNotification *)notification {
    /* User is registering on the LocalSocial platform */
}

-(void)userRegisterCompletedNotification:(NSNotification *)notification {
    /* User has completed his registration on the LocalSocial platform - some user info can be retreived as follow */
    
    NSDictionary *user = [LSLocalsocial getCurrentUser];
    
    NSString  *content = @"";
    content = [content stringByAppendingString:[NSString stringWithFormat:@"UserInfo: %@", user]];
    content = [content stringByAppendingString:@"\n"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"User Content"
                                                    message:content
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
