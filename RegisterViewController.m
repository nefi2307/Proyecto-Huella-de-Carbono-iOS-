#import "RegisterViewController.h"

@interface RegisterViewController ()
@property (nonatomic, assign) NSInteger currentCategoryIndex;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. Estilo de los Botones Superiores
    [self styleButton:self.btnTransport icon:@"car.fill" title:@"Transporte"];
    [self styleButton:self.btnEnergy icon:@"bolt.fill" title:@"Energía"];
    [self styleButton:self.btnHabit icon:@"leaf.fill" title:@"Hábito"];
    
    // 2. Estilo de la Imagen Principal
    self.imgIcon.layer.cornerRadius = 20;
    self.imgIcon.clipsToBounds = YES;
    self.imgIcon.contentMode = UIViewContentModeScaleAspectFit;
    
    // 3. Estilo del Botón Calcular
    self.btnCalculate.layer.cornerRadius = 12;
    self.btnCalculate.layer.shadowColor = [UIColor systemBlueColor].CGColor;
    self.btnCalculate.layer.shadowOpacity = 0.3;
    self.btnCalculate.layer.shadowOffset = CGSizeMake(0, 4);
    
    // 4. Configuración Inicial
    self.lblMessage.alpha = 0;
    self.currentCategoryIndex = 0;
    [self selectCategory:0]; // Iniciar en Transporte
}

- (void)styleButton:(UIButton *)btn icon:(NSString *)iconName title:(NSString *)title {
    if (@available(iOS 15.0, *)) {
        UIButtonConfiguration *config = [UIButtonConfiguration filledButtonConfiguration];
        config.title = title;
        config.image = [UIImage systemImageNamed:iconName];
        config.imagePlacement = NSDirectionalRectEdgeTop;
        config.imagePadding = 5;
        config.cornerStyle = UIButtonConfigurationCornerStyleMedium;
        
        config.baseBackgroundColor = [UIColor whiteColor];
        config.baseForegroundColor = [UIColor darkGrayColor];
        config.background.strokeColor = [UIColor systemGray5Color];
        config.background.strokeWidth = 1;
        
        btn.configuration = config;
    } else {
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setImage:[UIImage systemImageNamed:iconName] forState:UIControlStateNormal];
    }
}

// -----------------------------------------------------------------------
// ACCIÓN 1: Tocar Botones de Categoría
// -----------------------------------------------------------------------
- (IBAction)categoryTapped:(UIButton *)sender {
    if (sender == self.btnTransport) [self selectCategory:0];
    else if (sender == self.btnEnergy) [self selectCategory:1];
    else if (sender == self.btnHabit) [self selectCategory:2];
}

// Lógica Principal (Cambio de Colores, Textos y Etiquetas)
- (void)selectCategory:(NSInteger)index {
    self.currentCategoryIndex = index;
    
    NSArray *buttons = @[self.btnTransport, self.btnEnergy, self.btnHabit];
    
    // TU COLOR TURQUESA (#5ABFBF)
    UIColor *myTurquoise = [UIColor colorWithRed:90/255.0 green:191/255.0 blue:191/255.0 alpha:1.0];
    NSArray *colors = @[myTurquoise, myTurquoise, myTurquoise];
    
    // 1. Actualizar botones
    for (int i = 0; i < buttons.count; i++) {
        UIButton *btn = buttons[i];
        BOOL isSelected = (i == index);
        UIColor *targetColor = colors[i];
        
        if (@available(iOS 15.0, *)) {
            UIButtonConfiguration *config = btn.configuration;
            if (isSelected) {
                config.baseBackgroundColor = targetColor;
                config.baseForegroundColor = [UIColor whiteColor];
                config.background.strokeWidth = 0;
            } else {
                config.baseBackgroundColor = [UIColor whiteColor];
                config.baseForegroundColor = [UIColor darkGrayColor];
                config.background.strokeColor = [UIColor systemGray5Color];
                config.background.strokeWidth = 1;
            }
            btn.configuration = config;
        }
    }
    
    // 2. Limpiar UI
    [self.segmentSubtype removeAllSegments];
    self.sliderInput.value = 0;
    self.lblSliderValue.text = @"0.0";
    
    // Color y estilo de imagen
    self.imgIcon.backgroundColor = myTurquoise;
    self.imgIcon.tintColor = [UIColor whiteColor];
    
    // 3. CAMBIO DE TEXTOS SEGÚN CATEGORÍA (Aquí está la corrección)
    switch (index) {
        case 0: // Transporte
            self.lblInputTitle.text = @"Distancia"; // Título
            self.lblUnit.text = @"km";              // Unidad
            
            self.imgIcon.image = [UIImage systemImageNamed:@"car.fill"];
            [self.segmentSubtype insertSegmentWithTitle:@"Auto" atIndex:0 animated:NO];
            [self.segmentSubtype insertSegmentWithTitle:@"Bus" atIndex:1 animated:NO];
            [self.segmentSubtype insertSegmentWithTitle:@"Bici" atIndex:2 animated:NO];
            break;
            
        case 1: // Energía
            self.lblInputTitle.text = @"Tiempo de uso"; // Título
            self.lblUnit.text = @"hrs";                 // Unidad
            
            self.imgIcon.image = [UIImage systemImageNamed:@"lightbulb.fill"];
            [self.segmentSubtype insertSegmentWithTitle:@"Luces" atIndex:0 animated:NO];
            [self.segmentSubtype insertSegmentWithTitle:@"TV" atIndex:1 animated:NO];
            [self.segmentSubtype insertSegmentWithTitle:@"Aire" atIndex:2 animated:NO];
            break;
            
        case 2: // Hábito
            self.lblInputTitle.text = @"Cantidad"; // Título
            self.lblUnit.text = @"u";              // Unidad
            
            self.imgIcon.image = [UIImage systemImageNamed:@"arrow.3.trianglepath"];
            [self.segmentSubtype insertSegmentWithTitle:@"Reciclar" atIndex:0 animated:NO];
            [self.segmentSubtype insertSegmentWithTitle:@"Termo" atIndex:1 animated:NO];
            break;
    }
    self.segmentSubtype.selectedSegmentIndex = 0;
}

// -----------------------------------------------------------------------
// ACCIÓN 2: Sub-categoría (Cambio de Icono)
// -----------------------------------------------------------------------
- (IBAction)subtypeChanged:(id)sender {
    NSString *iconName = @"";
    NSInteger subIndex = self.segmentSubtype.selectedSegmentIndex;
    
    if (self.currentCategoryIndex == 0) { // TRANSPORTE
        if (subIndex == 0) iconName = @"car.fill";
        else if (subIndex == 1) iconName = @"bus.fill";
        else iconName = @"bicycle";
        
    } else if (self.currentCategoryIndex == 1) { // ENERGÍA
        if (subIndex == 0) iconName = @"lightbulb.fill";
        else if (subIndex == 1) iconName = @"tv.fill";
        else iconName = @"wind";
        
    } else { // HÁBITO
        if (subIndex == 0) iconName = @"arrow.3.trianglepath";
        else iconName = @"drop.fill";
    }
    
    [UIView transitionWithView:self.imgIcon
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.imgIcon.image = [UIImage systemImageNamed:iconName];
                    } completion:nil];
}

// -----------------------------------------------------------------------
// ACCIÓN 3: Slider
// -----------------------------------------------------------------------
- (IBAction)sliderChanged:(UISlider *)sender {
    self.lblSliderValue.text = [NSString stringWithFormat:@"%.1f", sender.value];
}

// -----------------------------------------------------------------------
// ACCIÓN 4: Calcular
// -----------------------------------------------------------------------
- (IBAction)calculatePressed:(id)sender {
    float input = self.sliderInput.value;
    
    if (input <= 0) {
        [self showAlert:@"Ups" message:@"Mueve el slider para registrar una cantidad."];
        return;
    }
    
    float co2Result = 0.0;
    NSInteger subType = self.segmentSubtype.selectedSegmentIndex;
    
    // Cálculo
    if (self.currentCategoryIndex == 0) { // TRANSPORTE
        if (subType == 0) co2Result = input * 0.19;
        else if (subType == 1) co2Result = input * 0.04;
        else co2Result = 0.0;
        
    } else if (self.currentCategoryIndex == 1) { // ENERGÍA
        if (subType == 0) co2Result = input * 0.05;
        else if (subType == 1) co2Result = input * 0.10;
        else co2Result = input * 0.50;
        
    } else { // HÁBITO
        if (subType == 0) co2Result = -(input * 0.2);
        else co2Result = -(input * 0.5);
    }
    
    // Guardar
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    float currentTotal = [defaults floatForKey:@"dailyCO2"];
    float newTotal = currentTotal + co2Result;
    if (newTotal < 0) newTotal = 0;
    [defaults setFloat:newTotal forKey:@"dailyCO2"];
    [defaults synchronize];
    
    // Animación
    self.lblMessage.text = [NSString stringWithFormat:@"✅ Registrado: %.2f kg", co2Result];
    self.lblMessage.alpha = 1.0;
    self.lblMessage.font = [UIFont boldSystemFontOfSize:16];
    self.lblMessage.textColor = [UIColor systemGreenColor];
    
    [UIView animateWithDuration:0.1 animations:^{
        self.imgIcon.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.imgIcon.transform = CGAffineTransformIdentity;
        }];
    }];
    
    [UIView animateWithDuration:0.5 delay:3.0 options:0 animations:^{
        self.lblMessage.alpha = 0.0;
    } completion:nil];
}

- (void)showAlert:(NSString*)title message:(NSString*)msg {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
