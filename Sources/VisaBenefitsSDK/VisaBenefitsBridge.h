//
//  VisaBenefitsBridge.h
//  JuspayBankSDK
//
//  Created by Namit Goel on 11/09/25.
//

#import <Foundation/Foundation.h>
#import <HyperSDK/HyperSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface VisaBenefitsBridge : NSObject

- (void)setBridgeComponent:(id<BridgeComponent>)component;
- (void)launchBookingBash:(NSString *)encryptedPayload :(NSString *) callback;
- (void)launchBookingBashWithEnv:(NSString *)encryptedPayload :(NSString *) callback :(NSString *) environment;

@end

NS_ASSUME_NONNULL_END
