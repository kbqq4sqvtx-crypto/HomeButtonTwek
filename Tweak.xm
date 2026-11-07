#import <UIKit/UIKit.h>

// Создаем плавающее окно и кнопку
static UIWindow *floatingWindow;
static UIButton *homeButton;

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)application {
    %orig;
    
    // Создаем окно поверх всех приложений
    floatingWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    floatingWindow.windowLevel = UIWindowLevelAlert + 1; 
    floatingWindow.backgroundColor = [UIColor clearColor];
    floatingWindow.rootViewController = [[UIViewController alloc] init];
    floatingWindow.rootViewController.view.backgroundColor = [UIColor clearColor];

    // Создаем круглую кнопку
    homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    homeButton.frame = CGRectMake(20, 100, 50, 50); 
    homeButton.backgroundColor = [UIColor blackColor];
    homeButton.alpha = 0.8;
    homeButton.layer.cornerRadius = 25; 
    [homeButton setTitle:@"🏠" forState:UIControlStateNormal];
    homeButton.titleLabel.font = [UIFont systemFontOfSize:24];
    
    [homeButton addTarget:self action:@selector(goHomeAction) forControlEvents:UIControlEventTouchUpInside];

    [floatingWindow.rootViewController.view addSubview:homeButton];
    floatingWindow.hidden = NO;
}

- (void)goHomeAction {
    // Вызов системного метода "Домой"
    Class SBUIController = objc_getClass("SBUIController");
    if (SBUIController) {
        id uiController = [SBUIController sharedInstance];
        if ([uiController respondsToSelector:@selector(goHome)]) {
            [uiController performSelector:@selector(goHome)];
        }
    }
}

%end
