#import "ProgressViewController.h"

@implementation ProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
