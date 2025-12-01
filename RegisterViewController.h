#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RegisterViewController : UIViewController

// Elementos de la UI
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentType; // El selector de arriba
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentSubtype; // EL NUEVO (Sub-categorías)
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;            // El cuadro gris de imagen
@property (weak, nonatomic) IBOutlet UITextField *txtInput;           // Donde escriben los números
@property (weak, nonatomic) IBOutlet UIButton *btnCalculate;          // El botón azul
@property (weak, nonatomic) IBOutlet UILabel *lblMessage; // El mensaje de feedback


// Acciones (Eventos)
- (IBAction)segmentChanged:(id)sender; // Cuando cambian entre Transporte/Energía
- (IBAction)calculatePressed:(id)sender; // Cuando tocan el botón

- (IBAction)subtypeChanged:(id)sender; // Acción del nuevo control
@end

NS_ASSUME_NONNULL_END
