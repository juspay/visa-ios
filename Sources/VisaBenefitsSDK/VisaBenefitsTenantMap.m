
#import "VisaBenefitsTenantMap.h"

@implementation VisaBenefitsTenantMap

static NSMutableDictionary<NSString *, VisaBenefitsTenantMap *> *_tenantRegistry = nil;

+ (void)initialize {
    if (self == [VisaBenefitsTenantMap class]) {
        _tenantRegistry = [[NSMutableDictionary alloc] init];
        [self registerDefaultTenants];
    }
}

        // releaseConfigTemplateUrl:@"https://%@api.dms.gbm.hsbc.com/hyper/bundles/in.juspay.merchants/%@/ios/%@/release-config.json?toss=%d"
+ (void)registerDefaultTenants {
    [self registerTenantWithName:@"visa_uae"
                        tenantId:@"visa_uae"
        releaseConfigTemplateUrl:@"https://airborne.sandbox.juspay.in/release/VISA/VISABenefits?x=%d&y=%d&z=%d&toss=%d"
                   logsEndPoints:nil];
    [self registerTenantWithName:@"DEFAULT"
                        tenantId:@"visa_uae"
        releaseConfigTemplateUrl:@"https://airborne.sandbox.juspay.in/release/VISA/VISABenefits?x=%d&y=%d&z=%d&toss=%d"
                   logsEndPoints:nil];
}


- (instancetype)initWithTenantId:(NSString *)tenantId
            releaseConfigTemplateUrl:(NSString *)releaseConfigTemplateUrl
                       logsEndPoints:(nullable NSDictionary *)logsEndPoints {
    self = [super init];
    if (self) {
        _tenantId = [tenantId copy];
        _releaseConfigTemplateUrl = [releaseConfigTemplateUrl copy];
        _logsEndPoints = [logsEndPoints copy];
    }
    return self;
}

+ (void)registerTenantWithName:(NSString *)name
                      tenantId:(NSString *)tenantId
      releaseConfigTemplateUrl:(NSString *)releaseConfigTemplateUrl
                 logsEndPoints:(nullable NSDictionary *)logsEndPoints {
    
    id tenant = [[self alloc]
                                    initWithTenantId:tenantId
                                    releaseConfigTemplateUrl:releaseConfigTemplateUrl
                                    logsEndPoints:logsEndPoints];
    
    @synchronized(_tenantRegistry) {
        _tenantRegistry[name] = tenant;
    }
}

+ (nullable instancetype)tenantWithName:(NSString *)name {
    @synchronized(_tenantRegistry) {
        return _tenantRegistry[name];
    }
}

// Dictionary-style access
- (nullable id)objectForKeyedSubscript:(NSString *)key {
    return [self valueForKey:key];
}

- (nullable id)valueForKey:(NSString *)key {
    if ([key isEqualToString:@"tenantId"]) {
        return self.tenantId;
    } else if ([key isEqualToString:@"releaseConfigTemplateUrl"]) {
        return self.releaseConfigTemplateUrl;
    } else if ([key isEqualToString:@"logsEndPoints"]) {
        return self.logsEndPoints;
    }
    return [super valueForKey:key];
}

@end
