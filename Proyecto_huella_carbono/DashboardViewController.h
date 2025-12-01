#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DashboardViewController : UIViewController

// Elementos de la Interfaz (UI)
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UIView *viewCarbonCircle; // El cuadro gris
@property (weak, nonatomic) IBOutlet UILabel *lblCarbonAmount; // El texto "2.4 kg"
@property (weak, nonatomic) IBOutlet UIView *viewChallengeCard; // La tarjeta del reto
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;

@end

NS_ASSUME_NONNULL_END
