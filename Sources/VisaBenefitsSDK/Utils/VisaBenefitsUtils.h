//
//  VisaBenefitsUtils.h
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VisaBenefitsUtils : NSObject

+ (NSDictionary *)updateServiceNameInPayload:(NSDictionary *)payload tenantServiceName:(NSString *)tenantServiceName isResponse:(BOOL)isResponse;

@end

NS_ASSUME_NONNULL_END