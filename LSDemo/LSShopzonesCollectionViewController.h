#import <UIKit/UIKit.h>
#import "Place.h"

@interface LSShopzonesCollectionViewController : UICollectionViewController<UICollectionViewDelegate, UICollectionViewDataSource>
    @property (nonatomic, strong) RTSPlace *place;
@end