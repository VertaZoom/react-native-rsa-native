#import "RNRSA.h"
#import "RSANative.h"

@implementation RNRSA

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE()

// Key based API, provide the public or private key with each call - pending discussions with @amitaymolko

RCT_EXPORT_METHOD(generate:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    RSANative *rsa = [[RSANative alloc] init];
    [rsa generate];
    NSDictionary *keys = @{
                           @"private" : [rsa encodedPrivateKey],
                           @"public" : [rsa encodedPublicKey]
                           };
    resolve(keys);
}

RCT_EXPORT_METHOD(encrypt:(NSString *)message withKey:(NSString *)key resolve:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    RSANative *rsa = [[RSANative alloc] init];
    rsa.publicKey = key;
    NSString *encodedMessage = [rsa encrypt:message];
    resolve(encodedMessage);
}

RCT_EXPORT_METHOD(decrypt:(NSString *)encodedMessage withKey:(NSString *)key resolve:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    RSANative *rsa = [[RSANative alloc] init];
    rsa.privateKey = key;
    NSString *message = [rsa decrypt:encodedMessage];
    resolve(message);
}

RCT_EXPORT_METHOD(sign:(NSString *)message withKey:(NSString *)key resolve:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
  RSANative *rsa = [[RSANative alloc] init];
  rsa.privateKey = key;
  NSString *signature = [rsa sign:message];
  resolve(signature);
}

@end

@implementation RNRSAKeychain

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE()

// Keychain based API, provide a key chain tag with each call

RCT_EXPORT_METHOD(generate:(NSString *)keyTag resolve:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    RSANative *rsa = [[RSANative alloc] initWithKeyTag:keyTag];
    [rsa generate];
    NSDictionary *keys = @{@"public" : [rsa encodedPublicKey]};
    resolve(keys);
}

RCT_EXPORT_METHOD(encrypt:(NSString *)message withKeyTag:(NSString *)keyTag resolve:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    RSANative *rsa = [[RSANative alloc] initWithKeyTag:keyTag];
    NSString *encodedMessage = [rsa encrypt:message];
    resolve(encodedMessage);
}

RCT_EXPORT_METHOD(decrypt:(NSString *)encodedMessage withKeyTag:(NSString *)keyTag resolve:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    RSANative *rsa = [[RSANative alloc] initWithKeyTag:keyTag];
    NSString *message = [rsa decrypt:encodedMessage];
    resolve(message);
}

RCT_EXPORT_METHOD(sign:(NSString *)message withKeyTag:(NSString *)keyTag resolve:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
  RSANative *rsa = [[RSANative alloc] initWithKeyTag:keyTag];
  NSString *signature = [rsa sign:message];
  resolve(signature);
}

@end
