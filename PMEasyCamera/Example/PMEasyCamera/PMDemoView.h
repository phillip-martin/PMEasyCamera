#import <UIKit/UIKit.h>
#import <ESCObservable/ESCObservable.h>

@protocol PMDemoViewObserver <NSObject>

- (void)mainViewCameraButtonClicked;

@end

@interface PMDemoView : UIView <ESCObservable>

@end
