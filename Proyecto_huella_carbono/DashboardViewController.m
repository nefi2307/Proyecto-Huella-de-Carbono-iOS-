#import "DashboardViewController.h"
#import <UserNotifications/UserNotifications.h> // Importante para las notificaciones

// Agregamos el protocolo del delegado aquí para que funcione el banner con la app abierta
@interface DashboardViewController () <UNUserNotificationCenterDelegate>
@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // TU COLOR TURQUESA (#5ABFBF)
    UIColor *myTurquoise = [UIColor colorWithRed:90/255.0 green:191/255.0 blue:191/255.0 alpha:1.0];
    
    // 1. CONFIGURACIÓN DEL CÍRCULO
    self.viewCarbonCircle.layer.cornerRadius = self.viewCarbonCircle.frame.size.width / 2.0;
    self.viewCarbonCircle.clipsToBounds = YES;
    self.viewCarbonCircle.layer.borderColor = myTurquoise.CGColor;
    self.viewCarbonCircle.layer.borderWidth = 8.0f;
    self.viewCarbonCircle.backgroundColor = [UIColor whiteColor];
    
    self.viewCarbonCircle.layer.shadowColor = [UIColor blackColor].CGColor;
    self.viewCarbonCircle.layer.shadowOpacity = 0.1;
    self.viewCarbonCircle.layer.shadowOffset = CGSizeMake(0, 5);
    self.viewCarbonCircle.layer.shadowRadius = 10;
    self.viewCarbonCircle.layer.masksToBounds = NO;
    
    // 2. TARJETA DE RETO
    self.viewChallengeCard.backgroundColor = [UIColor whiteColor];
    self.viewChallengeCard.layer.cornerRadius = 20;
    self.viewChallengeCard.layer.shadowColor = [UIColor blackColor].CGColor;
    self.viewChallengeCard.layer.shadowOpacity = 0.08;
    self.viewChallengeCard.layer.shadowOffset = CGSizeMake(0, 4);
    self.viewChallengeCard.layer.shadowRadius = 12;
    
    // Estilos internos del reto
    self.imgChallengeIcon.tintColor = [UIColor systemOrangeColor];
    self.progressChallenge.progressTintColor = myTurquoise;
    self.progressChallenge.trackTintColor = [UIColor systemGray6Color];
    self.progressChallenge.layer.cornerRadius = 4;
    self.progressChallenge.clipsToBounds = YES;
    [self.progressChallenge setProgress:0.5 animated:NO];

    // 3. BOTÓN DE REGISTRO
    if (@available(iOS 15.0, *)) {
        UIButtonConfiguration *config = [UIButtonConfiguration filledButtonConfiguration];
        config.title = @"Registrar Acción";
        config.baseBackgroundColor = myTurquoise;
        config.baseForegroundColor = [UIColor whiteColor];
        config.cornerStyle = UIButtonConfigurationCornerStyleCapsule;
        config.contentInsets = NSDirectionalEdgeInsetsMake(15, 30, 15, 30);
        
        config.image = [UIImage systemImageNamed:@"plus"];
        config.imagePadding = 8;
        
        self.btnRegister.configuration = config;
    } else {
        self.btnRegister.backgroundColor = myTurquoise;
        self.btnRegister.layer.cornerRadius = 25;
        [self.btnRegister setTitle:@"Registrar Acción" forState:UIControlStateNormal];
        [self.btnRegister setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    self.btnRegister.layer.shadowColor = myTurquoise.CGColor;
    self.btnRegister.layer.shadowOpacity = 0.4;
    self.btnRegister.layer.shadowOffset = CGSizeMake(0, 5);
    self.btnRegister.layer.shadowRadius = 10;
    
    // 4. FECHA DE HOY
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE, d 'de' MMMM"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"es_MX"]];
    self.lblDate.text = [[formatter stringFromDate:[NSDate date]] capitalizedString];
    self.lblDate.textColor = [UIColor secondaryLabelColor];
    
    // Icono del TabBar
    self.tabBarItem.image = [UIImage systemImageNamed:@"house.fill"];
    
    // 5. ESTILO DEL NAV BAR (TAB BAR)
    self.tabBarController.tabBar.tintColor = [UIColor blackColor];
    self.tabBarController.tabBar.unselectedItemTintColor = [UIColor systemGray3Color];
    self.tabBarController.tabBar.backgroundColor = [UIColor whiteColor];
    
    // 6. INICIAR NOTIFICACIONES
    [self setupNotifications];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    float totalCO2 = [defaults floatForKey:@"dailyCO2"];
    
    NSString *fullText = [NSString stringWithFormat:@"%.1f kg", totalCO2];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:fullText];
    
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18 weight:UIFontWeightMedium] range:NSMakeRange(fullText.length - 2, 2)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:40 weight:UIFontWeightBold] range:NSMakeRange(0, fullText.length - 2)];
    
    self.lblCarbonAmount.attributedText = attrString;
    
    UIColor *myTurquoise = [UIColor colorWithRed:90/255.0 green:191/255.0 blue:191/255.0 alpha:1.0];
    
    if (totalCO2 < 5.0) {
        self.viewCarbonCircle.layer.borderColor = myTurquoise.CGColor;
    } else if (totalCO2 < 10.0) {
        self.viewCarbonCircle.layer.borderColor = [UIColor systemOrangeColor].CGColor;
    } else {
        self.viewCarbonCircle.layer.borderColor = [UIColor systemRedColor].CGColor;
    }
}

// Acción del Botón Grande
- (IBAction)goToRegister:(id)sender {
    self.tabBarController.selectedIndex = 1;
}

// --- LÓGICA DE NOTIFICACIONES (MODO DEMO) ---

- (void)setupNotifications {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    // IMPORTANTE: Asignar el delegado para que se vea con la app abierta
    center.delegate = self;
    
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            NSLog(@"Permiso concedido - Iniciando Demo en 5s");
            // Agendamos la notificación de prueba
            [self scheduleDemoReminder];
        }
    }];
}

// Notificación para la EXPOSICIÓN (5 segundos)
- (void)scheduleDemoReminder {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center removeAllPendingNotificationRequests];
    
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"🌍 Tu Impacto de Hoy";
        content.body = @"¡No olvides registrar tus hábitos! Pequeñas acciones crean grandes cambios 🌱";
    content.sound = [UNNotificationSound defaultSound];
    
    // --- DEBUG DE IMAGEN ---
        // Asegúrate de que el nombre aquí coincida EXACTO con tu archivo
        NSURL *imageURL = [[NSBundle mainBundle] URLForResource:@"eco_notif" withExtension:@"png"];
        
        if (imageURL) {
            NSLog(@"✅ IMAGEN ENCONTRADA en: %@", imageURL);
            NSError *attachmentError = nil;
            UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"EcoImage" URL:imageURL options:nil error:&attachmentError];
            
            if (attachment) {
                content.attachments = @[attachment];
            } else {
                NSLog(@"❌ Error creando adjunto: %@", attachmentError);
            }
        } else {
            // SI SALE ESTO EN LA CONSOLA, ES EL ERROR DE TARGET MEMBERSHIP O NOMBRE
            NSLog(@"❌ ERROR CRÍTICO: No se encuentra el archivo 'eco_notif.png' en el Bundle.");
        }
        // -----------------------
    
    
    // Gatillo: 5 segundos desde ahora
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"DemoNotification" content:content trigger:trigger];
    
    [center addNotificationRequest:request withCompletionHandler:nil];
}

// ESTE MÉTODO ES EL SECRETO: Permite que la notificación baje aunque estés dentro de la app
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    // Mostrar Banner y Sonido
    completionHandler(UNNotificationPresentationOptionBanner | UNNotificationPresentationOptionSound);
}

@end
