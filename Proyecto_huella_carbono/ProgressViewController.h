#import <UIKit/UIKit.h>
#import "GraphView.h" // ¡Importante importar esto!

NS_ASSUME_NONNULL_BEGIN

@interface ProgressViewController : UIViewController

// El enchufe para la Gráfica (Outlet)
@property (weak, nonatomic) IBOutlet GraphView *graphView;
@property (weak, nonatomic) IBOutlet UIButton *btnReset;

// El enchufe para el Botón (Action)
- (IBAction)resetData:(id)sender;

@end

NS_ASSUME_NONNULL_END
