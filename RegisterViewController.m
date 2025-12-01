#import "RegisterViewController.h"

@interface RegisterViewController ()
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // --- Configuración Estética Inicial ---
    self.imgIcon.layer.cornerRadius = 10;
    self.btnCalculate.layer.cornerRadius = 8;
    
    // El mensaje inicia invisible
    self.lblMessage.alpha = 0;
    
    // Aseguramos que el Label pueda tener múltiples líneas (Solución al texto cortado)
    self.lblMessage.numberOfLines = 0;
    self.lblMessage.textAlignment = NSTextAlignmentCenter;
    
    // Iniciamos la pantalla con la primera opción (Transporte)
    [self updateUIForSegment:0];
}

// -----------------------------------------------------------------------
// ACCIÓN 1: Cambio de Categoría Principal (Arriba)
// -----------------------------------------------------------------------
- (IBAction)segmentChanged:(id)sender {
    [self updateUIForSegment:self.segmentType.selectedSegmentIndex];
}

// -----------------------------------------------------------------------
// ACCIÓN 2: Cambio de Sub-Categoría (Abajo)
// -----------------------------------------------------------------------
- (IBAction)subtypeChanged:(id)sender {
    // Bajamos el teclado si cambian de opción para ver mejor
    [self.view endEditing:YES];
}

// Lógica auxiliar para actualizar la UI (Textos, Colores, Opciones)
- (void)updateUIForSegment:(NSInteger)index {
    self.txtInput.text = @"";
    [self.segmentSubtype removeAllSegments]; // Limpiamos el segundo control
    
    switch (index) {
        case 0: // Transporte
            [self.segmentSubtype insertSegmentWithTitle:@"Auto" atIndex:0 animated:NO];
            [self.segmentSubtype insertSegmentWithTitle:@"Bus" atIndex:1 animated:NO];
            [self.segmentSubtype insertSegmentWithTitle:@"Bici" atIndex:2 animated:NO];
            self.segmentSubtype.selectedSegmentIndex = 0;
            
            self.txtInput.placeholder = @"Kilómetros recorridos";
            self.imgIcon.backgroundColor = [UIColor systemTealColor];
            break;
            
        case 1: // Energía
            [self.segmentSubtype insertSegmentWithTitle:@"Luces" atIndex:0 animated:NO];
            [self.segmentSubtype insertSegmentWithTitle:@"TV/PC" atIndex:1 animated:NO];
            [self.segmentSubtype insertSegmentWithTitle:@"Aire A." atIndex:2 animated:NO];
            self.segmentSubtype.selectedSegmentIndex = 0;
            
            self.txtInput.placeholder = @"Horas de uso";
            self.imgIcon.backgroundColor = [UIColor systemYellowColor];
            break;
            
        case 2: // Hábito
            [self.segmentSubtype insertSegmentWithTitle:@"Reciclaje" atIndex:0 animated:NO];
            [self.segmentSubtype insertSegmentWithTitle:@"Termo" atIndex:1 animated:NO];
            [self.segmentSubtype insertSegmentWithTitle:@"Vegano" atIndex:2 animated:NO];
            self.segmentSubtype.selectedSegmentIndex = 0;
            
            self.txtInput.placeholder = @"Cantidad / Comidas";
            self.imgIcon.backgroundColor = [UIColor systemGreenColor];
            break;
    }
}

// -----------------------------------------------------------------------
// ACCIÓN 3: Calcular (La Lógica Maestra)
// -----------------------------------------------------------------------
- (IBAction)calculatePressed:(id)sender {
    // 1. Ocultar teclado
    [self.txtInput resignFirstResponder];
    
    // 2. Validar entrada
    float input = [self.txtInput.text floatValue];
    if (input <= 0) {
        [self showAlert:@"Ojo" message:@"Ingresa una cantidad válida."];
        return;
    }
    
    float co2Result = 0.0;
    NSString *equivalencia = @"";
    
    // 3. Obtener selección
    NSInteger mainType = self.segmentType.selectedSegmentIndex;
    NSInteger subType = self.segmentSubtype.selectedSegmentIndex;
    
    // --- CÁLCULOS DETALLADOS ---
    if (mainType == 0) { // TRANSPORTE
        if (subType == 0) { co2Result = input * 0.19; }      // Auto
        else if (subType == 1) { co2Result = input * 0.04; } // Bus
        else { co2Result = 0.0; }                            // Bici
        
    } else if (mainType == 1) { // ENERGÍA
        if (subType == 0) { co2Result = input * 0.05; }      // Luces
        else if (subType == 1) { co2Result = input * 0.10; } // TV
        else { co2Result = input * 0.50; }                   // Aire Acondicionado
        
    } else { // HÁBITO (Ahorro)
        if (subType == 0) { co2Result = -(input * 0.2); }    // Reciclar
        else if (subType == 1) { co2Result = -(input * 0.5); } // Termo
        else { co2Result = -(input * 1.5); }                 // Vegano
    }
    
    // --- EQUIVALENCIAS EDUCATIVAS ---
    float absCO2 = fabsf(co2Result);
    if (absCO2 == 0) {
        equivalencia = @"¡Cero emisiones! Sigue así.";
    } else if (absCO2 < 1.0) {
        equivalencia = @"Equivale a cargar 50 celulares 📱";
    } else if (absCO2 < 5.0) {
        equivalencia = @"Equivale a un foco prendido 2 días 💡";
    } else {
        equivalencia = @"Equivale a conducir 20km un auto 🚗";
    }
    
    // 4. GUARDAR DATOS (NSUserDefaults)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    float currentTotal = [defaults floatForKey:@"dailyCO2"];
    float newTotal = currentTotal + co2Result;
    if (newTotal < 0) newTotal = 0;
    [defaults setFloat:newTotal forKey:@"dailyCO2"];
    [defaults synchronize];
    
    // 5. MOSTRAR RESULTADO (ANIMACIÓN Y FEEDBACK)
    
    // A. Actualizar texto
    self.lblMessage.text = [NSString stringWithFormat:@"✅ ¡Guardado!\n%.2f kg\n(%@)", co2Result, equivalencia];
    self.lblMessage.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    
    // B. Hacerlo visible (IMPORTANTE: Esto faltaba)
    self.lblMessage.alpha = 1.0;
    
    // C. Animación de rebote del icono
    [UIView animateWithDuration:0.1 animations:^{
        self.imgIcon.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.imgIcon.transform = CGAffineTransformIdentity;
        }];
    }];
    
    // D. Desvanecer mensaje después de 4 segundos
    [UIView animateWithDuration:0.5 delay:4.0 options:0 animations:^{
        self.lblMessage.alpha = 0.0;
    } completion:nil];
    
    // Limpiar campo
    self.txtInput.text = @"";
}

// Cierra el teclado al tocar el fondo
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

// Método simple para alertas
- (void)showAlert:(NSString*)title message:(NSString*)msg {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
