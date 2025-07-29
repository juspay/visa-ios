//
//  VisaBenefits.h
//

#import <Foundation/Foundation.h>
#import <HyperSDK/Hyper.h>

NS_ASSUME_NONNULL_BEGIN

typedef HyperSDKCallback VisaBenefitsCallback;

typedef HyperEventsCallback VisaBenefitsEventsCallback;

@protocol VisaBenefitsDelegate <HyperDelegate>

@end

@interface VisaBenefits : HyperServices

@property (nonatomic, weak) id <VisaBenefitsDelegate> _Nullable delegate;

+ (void)preFetch:(NSDictionary *)data __unavailable;

- (instancetype _Nonnull)initWithClientId:(NSString * _Nonnull)clientId;

- (void)initiate:(UIViewController * _Nonnull)viewController payload:(NSDictionary * _Nonnull)initiationPayload callback:(VisaBenefitsCallback _Nonnull)callback;

- (VisaBenefitsEventsCallback _Nullable)merchantEvent;

@end

NS_ASSUME_NONNULL_END