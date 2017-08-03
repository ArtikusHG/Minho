@interface UIWindow()
- (void)setAutorotates: (BOOL)arg;
@end
// Make the compiler know wot da hek is FBSystemService
@interface FBSystemService : NSObject
+(id)sharedInstance;
-(void)shutdownAndReboot:(BOOL)arg1;
@end
// Declare two windows
static UIWindow *gestureWindow = nil;
static UIWindow *blurryWindow = nil;
%hook SBPowerDownController
-(void)orderFront {
if(!gestureWindow) {
gestureWindow = [[UIWindow alloc]initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
gestureWindow.backgroundColor = [UIColor clearColor];
gestureWindow.hidden = NO;
gestureWindow.windowLevel = 9998;
}
if(!blurryWindow) {
// Add the shutdown window
blurryWindow = [[UIWindow alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 82,[UIScreen mainScreen].bounds.size.height / 2 - 55,165,110)];
blurryWindow.backgroundColor = [UIColor clearColor];
blurryWindow.hidden = NO;
blurryWindow.windowLevel = 9999;
blurryWindow.layer.masksToBounds = YES;
blurryWindow.layer.borderWidth = 0.0f;
blurryWindow.layer.cornerRadius = 15;
[blurryWindow setAutorotates: 1];
// Add an invisible window for GestureRecognizer
// Add the blur
UIVisualEffect *blurEffect;
blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
UIVisualEffectView *blurView;
blurView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
blurView.frame = blurryWindow.bounds;
[blurryWindow addSubview:blurView];
// Gesture recongizer
UITapGestureRecognizer *cancelTap = [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelPowerDown)]autorelease];
[cancelTap setNumberOfTouchesRequired:1];
[gestureWindow addGestureRecognizer:cancelTap];
// Power off button
UIButton *powerOff = [UIButton buttonWithType:UIButtonTypeRoundedRect];
powerOff.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 150,4, 150, 35);
[powerOff setTitle:@"Power off" forState:UIControlStateNormal];
[powerOff addTarget: self action:@selector(powerOff) forControlEvents:UIControlEventTouchUpInside];
[powerOff setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
[powerOff.titleLabel setFont:[UIFont systemFontOfSize:25]];
[blurryWindow addSubview:powerOff];
// Reboot button
UIButton *reBoot = [UIButton buttonWithType:UIButtonTypeRoundedRect];
reBoot.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 150,38, 150, 35);
[reBoot setTitle:@"Reboot" forState:UIControlStateNormal];
[reBoot addTarget: self action:@selector(reBoot) forControlEvents:UIControlEventTouchUpInside];
[reBoot setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
[reBoot.titleLabel setFont:[UIFont systemFontOfSize:25]];
[blurryWindow addSubview:reBoot];
UIButton *reSpring = [UIButton buttonWithType:UIButtonTypeRoundedRect];
reSpring.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 150,71, 150, 35);
[reSpring setTitle:@"Respring" forState:UIControlStateNormal];
[reSpring addTarget: self action:@selector(reSpring) forControlEvents:UIControlEventTouchUpInside];
[reSpring setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
[reSpring.titleLabel setFont:[UIFont systemFontOfSize:25]];
[blurryWindow addSubview:reSpring];
}
}
%new
-(void)cancelPowerDown {
blurryWindow.hidden = YES;
blurryWindow = nil;
gestureWindow.hidden = YES;
gestureWindow = nil;
}
%new
-(void)powerOff {
[[objc_getClass("FBSystemService") sharedInstance] shutdownAndReboot:0];
}
%new
-(void)reBoot {
[[objc_getClass("FBSystemService") sharedInstance] shutdownAndReboot:1];
}
%new
-(void)reSpring {
system("killall -9 SpringBoard");
}
%end