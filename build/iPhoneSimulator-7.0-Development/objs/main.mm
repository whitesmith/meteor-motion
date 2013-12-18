#import <UIKit/UIKit.h>

extern "C" {
    void rb_define_global_const(const char *, void *);
    void rb_rb2oc_exc_handler(void);
    void rb_exit(int);
    void RubyMotionInit(int argc, char **argv);
void MREP_7813158588094C1BAEB2709AC404FF27(void *, void *);
void MREP_4DB40A63A37C49A584153FF3D8DE59BE(void *, void *);
void MREP_09DE648F7E044212A8978E56E9C0FFCC(void *, void *);
void MREP_82C6522A9E964DA4B20181F91A7F3354(void *, void *);
void MREP_2B753E9B851D4B48ACE53D8202BED641(void *, void *);
}
@interface SpecLauncher : NSObject
@end

#include <dlfcn.h>

@implementation SpecLauncher

+ (id)launcher
{
    [UIApplication sharedApplication];

    // Enable simulator accessibility.
    // Thanks http://www.stewgleadow.com/blog/2011/10/14/enabling-accessibility-for-ios-applications/
    NSString *simulatorRoot = [[[NSProcessInfo processInfo] environment] objectForKey:@"IPHONE_SIMULATOR_ROOT"];
    if (simulatorRoot != nil) {
        void *appSupportLibrary = dlopen([[simulatorRoot stringByAppendingPathComponent:@"/System/Library/PrivateFrameworks/AppSupport.framework/AppSupport"] fileSystemRepresentation], RTLD_LAZY);
        CFStringRef (*copySharedResourcesPreferencesDomainForDomain)(CFStringRef domain) = (CFStringRef (*)(CFStringRef)) dlsym(appSupportLibrary, "CPCopySharedResourcesPreferencesDomainForDomain");

        if (copySharedResourcesPreferencesDomainForDomain != NULL) {
            CFStringRef accessibilityDomain = copySharedResourcesPreferencesDomainForDomain(CFSTR("com.apple.Accessibility"));

            if (accessibilityDomain != NULL) {
                CFPreferencesSetValue(CFSTR("ApplicationAccessibilityEnabled"), kCFBooleanTrue, accessibilityDomain, kCFPreferencesAnyUser, kCFPreferencesAnyHost);
                CFRelease(accessibilityDomain);
            }
        }
    }

    // Load the UIAutomation framework.
    dlopen("/Developer/Library/PrivateFrameworks/UIAutomation.framework/UIAutomation", RTLD_LOCAL);

    SpecLauncher *launcher = [[self alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:launcher selector:@selector(appLaunched:) name:UIApplicationDidBecomeActiveNotification object:nil];
    return launcher; 
}

- (void)appLaunched:(id)notification
{
    // Give a bit of time for the simulator to attach...
    [self performSelector:@selector(runSpecs) withObject:nil afterDelay:0.3];
}

- (void)runSpecs
{
MREP_7813158588094C1BAEB2709AC404FF27(self, 0);
MREP_4DB40A63A37C49A584153FF3D8DE59BE(self, 0);
MREP_09DE648F7E044212A8978E56E9C0FFCC(self, 0);
MREP_82C6522A9E964DA4B20181F91A7F3354(self, 0);
MREP_2B753E9B851D4B48ACE53D8202BED641(self, 0);
[NSClassFromString(@"Bacon") performSelector:@selector(run)];
}

@end
int
main(int argc, char **argv)
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    int retval = 0;
[SpecLauncher launcher];
    RubyMotionInit(argc, argv);
    retval = UIApplicationMain(argc, argv, nil, @"TestSuiteDelegate");
    rb_exit(retval);
    [pool release];
    return retval;
}
