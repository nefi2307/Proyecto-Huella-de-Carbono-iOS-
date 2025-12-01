#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DashboardViewController : UIViewController

// Encabezado
@property (weak, nonatomic) IBOutlet UILabel *lblDate;     // NUEVO: La fecha



// Elementos de la Interfaz (UI)
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UIView *viewCarbonCircle; // El cuadro gris
@property (weak, nonatomic) IBOutlet UILabel *lblCarbonAmount; // El texto "2.4 kg"
@property (weak, nonatomic) IBOutlet UIView *viewChallengeCard; // La tarjeta del reto

@property (weak, nonatomic) IBOutlet UIImageView *imgChallengeIcon; // NUEVO: El trofeo
@property (weak, nonatomic) IBOutlet UIProgressView *progressChallenge; // NUEVO: La barrita
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;
// Acción para movernos de pestaña
- (IBAction)goToRegister:(id)sender;

@end

NS_ASSUME_NONNULL_END
