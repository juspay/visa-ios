//
//  VisaBenefitsUtils.m
//

#import "VisaBenefitsUtils.h"
#import "VisaBenefitsConstants.h"

@implementation VisaBenefitsUtils

+ (NSDictionary *)updateServiceNameInPayload:(NSDictionary *)payload tenantServiceName:(NSString *)tenantServiceName isResponse:(BOOL)isResponse {
    if (!payload || !payload[@"service"]) {
        return payload;
    }
    
    NSString *serviceName = payload[@"service"];
    NSString *updatedServiceName = serviceName;
    
    if (isResponse) {
        if (![tenantServiceName containsString:VISA_BENEFITS_HYPER_SERVICE_PREFIX] && [serviceName containsString:VISA_BENEFITS_HYPER_SERVICE_PREFIX]) {
            updatedServiceName = [serviceName stringByReplacingOccurrencesOfString:VISA_BENEFITS_HYPER_SERVICE_PREFIX withString:@""];
        }
    } else {
        if (![serviceName containsString:VISA_BENEFITS_HYPER_SERVICE_PREFIX]) {
            updatedServiceName = [NSString stringWithFormat:@"%@%@", VISA_BENEFITS_HYPER_SERVICE_PREFIX, serviceName];
        }
    }
    
    if ([updatedServiceName isEqualToString:serviceName]) {
        return payload;
    }
    
    NSMutableDictionary *updatedPayload = [payload mutableCopy];
    updatedPayload[@"service"] = updatedServiceName;
    return [updatedPayload copy];
}

@end