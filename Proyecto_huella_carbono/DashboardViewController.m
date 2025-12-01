//
//  DashboardViewController.m
//  Proyecto_huella_carbono
//
//  Created by Isaac Burciaga on 30/11/25.
//

#import "DashboardViewController.h"

@interface DashboardViewController ()

@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // --- 1. CONFIGURACIÓN DEL CÍRCULO CENTRAL ---
    // Hacemos que la vista sea un círculo perfecto dividiendo su ancho entre 2
    self.viewCarbonCircle.layer.cornerRadius = self.viewCarbonCircle.frame.size.width / 2.0;
    self.viewCarbonCircle.clipsToBounds = YES;
    
    // Le añadimos un borde grueso verde para simular el "progreso"
    // (Más adelante podemos animar esto, pero por ahora se verá genial)
    self.viewCarbonCircle.layer.borderColor = [UIColor systemGreenColor].CGColor;
    self.viewCarbonCircle.layer.borderWidth = 10.0f; // Grosor del anillo
    
    // Color de fondo blanco o transparente para que resalte
    self.viewCarbonCircle.backgroundColor = [UIColor whiteColor];


    // --- 2. CONFIGURACIÓN DE LA TARJETA DE RETO ---
    // Redondeamos las esquinas de la tarjeta
    self.viewChallengeCard.layer.cornerRadius = 15.0f;
    
    // Agregamos una sombra suave para darle profundidad (Efecto 3D)
    self.viewChallengeCard.layer.shadowColor = [UIColor blackColor].CGColor;
    self.viewChallengeCard.layer.shadowOpacity = 0.1f; // Sombra muy sutil
    self.viewChallengeCard.layer.shadowOffset = CGSizeMake(0, 4); // Desplazamiento hacia abajo
    self.viewChallengeCard.layer.shadowRadius = 6.0f; // Difuminado
    
    // Importante: Para que la sombra se vea, clipsToBounds debe ser NO en la tarjeta
    self.viewChallengeCard.clipsToBounds = NO;
    self.viewChallengeCard.backgroundColor = [UIColor whiteColor];


    // --- 3. CONFIGURACIÓN DEL BOTÓN ---
    // Redondeamos el botón completamente
    self.btnRegister.layer.cornerRadius = 25.0f; // Ajusta este valor según la altura de tu botón
}

// Este método se ejecuta CADA VEZ que entras a esta pantalla
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 1. Recuperar el dato guardado
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    float totalCO2 = [defaults floatForKey:@"dailyCO2"];
    
    // 2. Actualizar la etiqueta del círculo
    self.lblCarbonAmount.text = [NSString stringWithFormat:@"%.1f kg", totalCO2];
    
    // 3. CAMBIO DE COLOR DINÁMICO (Gamificación)
    // Si la huella es baja (< 5kg), círculo verde. Si es alta, naranja/rojo.
    if (totalCO2 < 5.0) {
        self.viewCarbonCircle.layer.borderColor = [UIColor systemGreenColor].CGColor;
    } else if (totalCO2 < 10.0) {
        self.viewCarbonCircle.layer.borderColor = [UIColor systemOrangeColor].CGColor;
    } else {
        self.viewCarbonCircle.layer.borderColor = [UIColor systemRedColor].CGColor;
    }
}

@end
