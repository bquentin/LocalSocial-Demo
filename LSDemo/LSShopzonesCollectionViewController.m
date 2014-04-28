#import <UIKit/UIKit.h>

#import "Localsocial.h"
#import "LSAppDelegate.h"
#import "LSShopzonesCollectionViewController.h"

@interface LSShopzonesCollectionViewController ()
@end

@implementation LSShopzonesCollectionViewController{
    NSArray * shopzones;
}

@synthesize place;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Shopzones", @"Shopzones");
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
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.collectionView reloadData];
    shopzones = [LSLocalsocial getShopzonesForPlace:place];
}

#pragma mark - Collection view methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [shopzones count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell          = [collectionView dequeueReusableCellWithReuseIdentifier:@"LSShopzoneViewCell"
                                                                                forIndexPath:indexPath];

    RTSShopzone * shopzone              = [shopzones objectAtIndex:indexPath.row];
    UILabel * shopzone_name             = (UILabel *) [cell viewWithTag:201];

    shopzone_name.text                  = [shopzone name];
    shopzone_name.backgroundColor       = [UIColor lightGrayColor];

    /**
     *  proximity: 
     */
    if([[shopzone proximity] boolValue]){
        switch ([[shopzone priority] intValue])
        {
            case 0:
                shopzone_name.backgroundColor      = LS_COLOUR_ZONE_0;
                break;
            case 1:
                shopzone_name.backgroundColor      = LS_COLOUR_ZONE_1;
                break;
            case 2:
                shopzone_name.backgroundColor      = LS_COLOUR_ZONE_2;
                break;
//            case 3:
//                shopzone_name.backgroundColor      = LS_COLOUR_ZONE_3;
//                break;
            default:
                break;
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // Display detailed information regarding the selected place.
    // THIS DOES NOT DISPLAY ALL THE ATTRIBUTES. Refer to the documentationfor full attributes listings.
    
    RTSShopzone * shopzone = [shopzones objectAtIndex:indexPath.row];
    
    NSString  *content = @"";
    content = [content stringByAppendingString:@"Name:"];
    content = [content stringByAppendingString:[shopzone name]];
    content = [content stringByAppendingString:@"\n"];
    
    content = [content stringByAppendingString:@"Category:"];
    content = [content stringByAppendingString:[shopzone category]];
    content = [content stringByAppendingString:@"\n"];
    
    content = [content stringByAppendingString:@"Image:"];
    content = [content stringByAppendingString:[shopzone url_image]];
    content = [content stringByAppendingString:@"\n"];
    
    content = [content stringByAppendingString:@"=== Offers ==="];
    content = [content stringByAppendingString:@"\n"];
    
    for(RTSOffer * offer in [shopzone offers]){
        
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
    
    for(RTSProduct * product in [shopzone products]){
        
        content = [content stringByAppendingString:@"Name:"];
        content = [content stringByAppendingString:[product name]];
        content = [content stringByAppendingString:@"\n"];
        
        content = [content stringByAppendingString:@"Cards:"];
        content = [content stringByAppendingString:[[product cards] allObjects][0]];
        content = [content stringByAppendingString:@"\n"];
        content = [content stringByAppendingString:[[product cards] allObjects][1]];
        content = [content stringByAppendingString:@"\n"];
    }

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Shopzone Content"
                                                    message:content
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - Notifications

/**
 *  This is called when new information regarding the proximity has been received and are ready to be fetched by the app. (likely to indicate that app should show something to the user..)
 */
-(void)objectsChangedNotification: (NSNotification *)notification {
    
    /**
     *   NSDictionary *data = [notification userInfo];
     The data would give enough details to update a specific object. For the demo purporse, I just reload it all.
     */
    dispatch_async(dispatch_get_main_queue(), ^{
        shopzones = [LSLocalsocial getShopzonesForPlace:place];
        [self.collectionView reloadData];
    });
}

@end
