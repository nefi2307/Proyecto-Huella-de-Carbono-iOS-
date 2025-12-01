#import "ProgressViewController.h"

@implementation ProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Configuración del botón ROJO
    if (@available(iOS 15.0, *)) {
        UIButtonConfiguration *config = [UIButtonConfiguration filledButtonConfiguration];
        config.title = @"Reiniciar Día";
        config.baseBackgroundColor = [UIColor systemRedColor]; // Color Rojo
        config.baseForegroundColor = [UIColor whiteColor];     // Texto Blanco
        config.cornerStyle = UIButtonConfigurationCornerStyleCapsule; // Forma de Píldora
        config.image = [UIImage systemImageNamed:@"trash.fill"]; // Icono Basura
        config.imagePadding = 8;
        config.imagePlacement = NSDirectionalRectEdgeLeading; // Icono a la izquierda
        
        // APLICAR LA CONFIGURACIÓN (Asegúrate que esta línea NO tenga // al inicio)
        self.btnReset.configuration = config;
        
        // Sombra para que se vea Pro
        self.btnReset.layer.shadowColor = [UIColor systemRedColor].CGColor;
        self.btnReset.layer.shadowOpacity = 0.4;
        self.btnReset.layer.shadowOffset = CGSizeMake(0, 4);
        self.btnReset.layer.shadowRadius = 8;
    } else {
        // Versiones viejas de iOS
        self.btnReset.backgroundColor = [UIColor systemRedColor];
        self.btnReset.layer.cornerRadius = 20;
        [self.btnReset setTitle:@"Reiniciar Día" forState:UIControlStateNormal];
        [self.btnReset setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

// Se ejecuta cada vez que entras a la pantalla: Actualiza la gráfica
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.graphView setNeedsDisplay];
}

// Acción del botón rojo
- (IBAction)resetData:(id)sender {
    // Alerta de confirmación
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"¿Reiniciar día?"
                                                                   message:@"Se borrará el progreso de hoy."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *reset = [UIAlertAction actionWithTitle:@"Borrar" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        
        // 1. Borrar dato
        [[NSUserDefaults standardUserDefaults] setFloat:0.0 forKey:@"dailyCO2"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // 2. Redibujar gráfica
        [self.graphView setNeedsDisplay];
    }];
    
    [alert addAction:cancel];
    [alert addAction:reset];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
