#import "FluentPlugin.h"
#if __has_include(<fluent/fluent-Swift.h>)
#import <fluent/fluent-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "fluent-Swift.h"
#endif

@implementation FluentPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFluentPlugin registerWithRegistrar:registrar];
}
@end
