import WatchKit
import Foundation
import CoreMotion

class InterfaceController: WKInterfaceController {
    
    @IBOutlet var labelPasos: WKInterfaceLabel!
    @IBOutlet var labelDistancia: WKInterfaceLabel!
    @IBOutlet var labelAscender: WKInterfaceLabel!
    @IBOutlet var labelDescender: WKInterfaceLabel!
    
    let podometro = CMPedometer()

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        //COMPROBAMOS SI ES POSIBLE MEDIR LOS DATOS
        if CMPedometer.isPaceAvailable() {
            
            //INICIALIZAMOS LA CLASE Y POR MEDIO DE UNA CLOSURE RECOGEMOS LOS DISTINTOS DATOS
            podometro.startUpdates(from: Date()) {(pedometerData, error) -> Void in
                
                //MEDIANTE OPTIONAL BINDING MEDIR LOS PASOS
                if let pedometerData = pedometerData {
                    let pasos = pedometerData.numberOfSteps.uint64Value
                    self.labelPasos.setText(String (format: "%lu", pasos))
                }
                
                //RECOGER LA DISTANCIA
                
                if let distancia = pedometerData?.distance {
                    self.labelDistancia.setText(String (format: "%lu", distancia.uint64Value))
                }
                
                //RECOGEMOS LOS PISOS SUBIDOS
                if let ascender = pedometerData?.floorsAscended {
                    self.labelAscender.setText(String (format: "%lu", ascender.uint64Value))
                }
                
                //RECOGEMOS LOS PISOS BAJADOS
                if let descender = pedometerData?.floorsDescended {
                    self.labelDescender.setText(String (format: "%lu", descender.uint64Value))
                }
            }
            
            //SI NO HAY POSIBILIDAD DE RECOGER LOS DATOS
        }else{
            self.labelPasos.setText("No disponible")
            self.labelDistancia.setText("No disponible")
            self.labelAscender.setText("No disponible")
            self.labelDescender.setText("No disponible")
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        podometro.stopUpdates()
    }

}
