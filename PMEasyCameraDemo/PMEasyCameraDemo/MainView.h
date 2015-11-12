#import <UIKit/UIKit.h>
#import <ESCObservable/ESCObservable.h>

@protocol MainViewObserver <NSObject>

- (void)mainViewCameraButtonClicked;

@end

@interface MainView : UIView <ESCObservable>

@end
