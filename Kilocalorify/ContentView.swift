import SwiftUI
import CoreData

struct MyProduct: Identifiable {
    var id: UUID = UUID()
    var name = ""
    var caloricity : Float
    
    init(name: String, caloriesIn100g: Float) {
        self.name = name
        self.caloricity = caloriesIn100g / 100
    }
    
    init(name: String, caloriesIn1g: Float) {
        self.name = name
        self.caloricity = caloriesIn1g
    }
}

struct MyConsumation: Identifiable {
    var id: UUID = UUID()
    var product: MyProduct
    var weight : Float
    //
    init(product: MyProduct, weight: Float){
        self.product = product
        self.weight = weight
    }
}

struct ContentView: View {
    @State var Consumations: [MyConsumation] = [MyConsumation(product: MyProduct(name: "Eggs", caloriesIn100g: 155), weight: 190)]
    @State var allCalories: Float = 0
    
    var body: some View {
        NavigationView {
            VStack {
                Text("hello")
                List(Consumations) { (c:MyConsumation) in
                    HStack {
                        Text(c.product.name)
                        Spacer()
                        Text(String(c.weight) + "g")
                        Spacer()
                        Text(String(c.weight * c.product.caloricity) + "kcal")
                    }
                }
                .toolbar() {
                    Button(action: AddEmptyConsomation) {
                        Text("Create empty product")
                    }
                }
                
            }
        }
    }
    
    init(){
        if Consumations.isEmpty {
            allCalories = 0
        } else {
            for c in Consumations {
                allCalories += c.weight * c.product.caloricity
            }
        }
    }
    
    func AddEmptyConsomation() {
        let np = MyProduct(name: "Empty", caloriesIn1g: 0)
        let nc = MyConsumation(product: np, weight: 0)
        Consumations.append(nc)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
