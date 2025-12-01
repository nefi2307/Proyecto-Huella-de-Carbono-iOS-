#import "GraphView.h"

@implementation GraphView

// Este método se llama automáticamente para dibujar en la pantalla
- (void)drawRect:(CGRect)rect {
    // 1. Obtener el valor REAL de hoy desde la memoria
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    float todayCO2 = [defaults floatForKey:@"dailyCO2"];
    
    // 2. Datos simulados para los días anteriores (Lun-Sáb) + Hoy Real (Dom)
    // Esto simula que has usado la app toda la semana
    NSMutableArray *values = [NSMutableArray arrayWithArray:@[@3.5, @2.1, @5.0, @1.2, @4.5, @2.8]];
    [values addObject:@(todayCO2)]; // Agregamos el valor real al final
    
    NSArray *days = @[@"L", @"M", @"M", @"J", @"V", @"S", @"D (Hoy)"];
    
    // 3. Configuración de dimensiones
    CGContextRef context = UIGraphicsGetCurrentContext();
    float width = rect.size.width;
    float height = rect.size.height;
    
    // Ajustes de diseño
    float margin = 40.0; // Espacio abajo para texto
    float maxDataValue = 10.0; // El tope de la gráfica (10 kg)
    // Si hoy te pasaste de 10, ajustamos la escala
    if (todayCO2 > maxDataValue) maxDataValue = todayCO2 + 2.0;
    
    float barWidth = (width - (values.count * 10)) / values.count; // Calcular ancho dinámico
    // --- NUEVO: LÍNEA DE META (TARGET) ---
        float targetValue = 5.0; // El límite ideal
        float targetHeight = (targetValue / maxDataValue) * (height - margin);
        float targetY = height - targetHeight - 20;
        
        // Dibujar línea punteada
        UIBezierPath *line = [UIBezierPath bezierPath];
        [line moveToPoint:CGPointMake(0, targetY)];
        [line addLineToPoint:CGPointMake(width, targetY)];
        
        [[UIColor systemGrayColor] setStroke];
        [line setLineWidth:1.0];
        const CGFloat dashes[] = { 4.0, 4.0 }; // Patrón de punteado
        [line setLineDash:dashes count:2 phase:0.0];
        [line stroke];
        
        // Texto de "Meta"
        NSString *goalLabel = @"Meta Sostenible";
        [goalLabel drawAtPoint:CGPointMake(5, targetY - 15) withAttributes:@{
            NSFontAttributeName: [UIFont italicSystemFontOfSize:10],
            NSForegroundColorAttributeName: [UIColor systemGrayColor]
        }];
    
    // 4. Bucle para dibujar cada barra
    for (int i = 0; i < values.count; i++) {
        float value = [values[i] floatValue];
        
        // Calcular altura proporcional
        float barHeight = (value / maxDataValue) * (height - margin);
        
        // Coordenadas (X, Y)
        float x = (barWidth + 10) * i; // 10 es el espacio entre barras
        float y = height - barHeight - 20; // 20px de margen extra abajo
        
        // COLOR DINÁMICO: Verde (bajo), Naranja (medio), Rojo (alto)
        UIColor *barColor = [UIColor systemGreenColor];
        if (value > 4.0) barColor = [UIColor systemOrangeColor];
        if (value > 8.0) barColor = [UIColor systemRedColor];
        
        [barColor setFill];
        
        // Dibujar la barra con esquinas redondeadas
        CGRect barRect = CGRectMake(x, y, barWidth, barHeight);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:barRect cornerRadius:6];
        [path fill];
        
        // Poner el número arriba de la barra
        NSString *valueText = [NSString stringWithFormat:@"%.1f", value];
        NSDictionary *attrs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:10], NSForegroundColorAttributeName: [UIColor darkGrayColor]};
        [valueText drawAtPoint:CGPointMake(x + 5, y - 15) withAttributes:attrs];
        
        // Poner la letra del día abajo
        NSString *dayLetter = days[i];
        [dayLetter drawAtPoint:CGPointMake(x + 5, height - 15) withAttributes:attrs];
    }
}

@end
