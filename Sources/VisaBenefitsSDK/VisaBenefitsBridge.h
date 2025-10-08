//
//  VisaBenefitsBridge.h
//  JuspayBankSDK
//
//  Created by Harsh Garg on 11/09/25.
//

#import <Foundation/Foundation.h>
#import <HyperSDK/HyperSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface VisaBenefitsBridge : NSObject

- (void)setBridgeComponent:(id<BridgeComponent>)component;
- (NSString *)launchBookingBash:(NSString *)encryptedPayload;

@end

NS_ASSUME_NONNULL_END
