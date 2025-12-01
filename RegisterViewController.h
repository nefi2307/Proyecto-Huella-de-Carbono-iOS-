#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RegisterViewController : UIViewController

// --- NUEVOS ELEMENTOS DE DISEÑO ---
@property (weak, nonatomic) IBOutlet UIButton *btnTransport;
@property (weak, nonatomic) IBOutlet UIButton *btnEnergy;
@property (weak, nonatomic) IBOutlet UIButton *btnHabit;

@property (weak, nonatomic) IBOutlet UILabel *lblSliderValue; // El número grande (ej. 15.0)
@property (weak, nonatomic) IBOutlet UISlider *sliderInput;   // La barra para deslizar

@property (weak, nonatomic) IBOutlet UILabel *lblInputTitle; // El que dice "Distancia"
@property (weak, nonatomic) IBOutlet UILabel *lblUnit;

// Mantenemos estos del diseño anterior
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentSubtype; // (Auto/Bus...)
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;               // La imagen grande
@property (weak, nonatomic) IBOutlet UIButton *btnCalculate;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;



// --- ACCIONES ---
- (IBAction)categoryTapped:(UIButton *)sender; // Cuando tocan uno de los 3 botones de arriba
- (IBAction)sliderChanged:(UISlider *)sender;  // Cuando mueven el slider
- (IBAction)subtypeChanged:(id)sender;         // Cuando cambian el subtipo
- (IBAction)calculatePressed:(id)sender;

@end

NS_ASSUME_NONNULL_END
