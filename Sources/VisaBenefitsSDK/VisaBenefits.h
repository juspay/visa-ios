//
//  VisaBenefits.h
//

#import <Foundation/Foundation.h>
#import <HyperSDK/Hyper.h>

// Forward declaration for BookingBash integration
@class UIViewController;
@protocol BookingBashDelegate;

NS_ASSUME_NONNULL_BEGIN

typedef HyperSDKCallback VisaBenefitsCallback;

typedef HyperEventsCallback VisaBenefitsEventsCallback;

@protocol VisaBenefitsDelegate <HyperDelegate>

@end

@interface VisaBenefits : NSObject

@property (nonatomic, weak) id <VisaBenefitsDelegate> _Nullable delegate;
@property (nonatomic, assign) BOOL shouldHideNavigationBarWhenPushed;
@property (nonatomic, assign) BOOL shouldUseViewController;

- (instancetype _Nonnull)initWithClientId:(NSString * _Nonnull)clientId region:(NSString * _Nonnull)region;

- (void)initiate:(UIViewController * _Nonnull)viewController payload:(NSDictionary * _Nonnull)sdkPayload callback:(VisaBenefitsCallback _Nonnull)callback;

- (void)process:(NSDictionary * _Nonnull)sdkPayload;

- (void)show:(UIViewController * _Nonnull)viewController payload:(NSDictionary * _Nonnull)sdkPayload callback:(VisaBenefitsCallback _Nonnull)callback;

- (BOOL)isInitialised;

- (void)terminate;

- (VisaBenefitsEventsCallback _Nullable)merchantEvent;

@end

NS_ASSUME_NONNULL_END