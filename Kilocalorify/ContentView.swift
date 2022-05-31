import SwiftUI
import CoreData
import Combine

struct ConsumationDetailView: View {
    let consumation: Consumation
    var body: some View {
        VStack{
            Text("Product")
                .font(Font.headline.weight(.light))
            Text(consumation.product!.name!)
                .padding([.bottom], 20)
            
            Text("Amount")
                .font(Font.headline.weight(.light))
            Text(String(format: "%.1f", consumation.amount) + " g")
                .padding([.bottom], 20)
            
            Text("Calories")
                .font(Font.headline.weight(.light))
            Text(String(format: "%.1f", consumation.amount * consumation.product!.calories) + " kcal")
                .padding([.bottom], 20)
        }
    }
}

struct ConsumationCreateView: View {
    
    @FetchRequest(
        entity: Product.entity(),
        sortDescriptors: []
    ) var Products: FetchedResults<Product>
    
    @State var selectedProduct: Product = Product()
    @State var amount: String = ""
    @State var date: Date = Date.now
    
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Product")
                .font(Font.headline.weight(.light))
            
            Picker("Product", selection: $selectedProduct){
                ForEach(Products) { p in
                    Text(p.name ?? "")
                }
            }
            .padding([.bottom], 20)

            Text("Amount")
                .font(Font.headline.weight(.light))
            TextField("200g", text: $amount)
                .padding([.bottom], 20)
                .keyboardType(.decimalPad)
            
            DatePicker("Choose date", selection: $date)
            
        }
        .toolbar(){
            Button("Create", action: createConsumation)
        }
        .padding([.trailing, .leading], 30)
    }
    
    func createConsumation(){
        
        let predicate = NSPredicate(format: "name == %@", "Banana" as! NSString)
        let _fr = Product.fetchRequest()
        _fr.predicate = predicate
        let _product = try! self.moc.fetch(_fr).first
        
        let nc = Consumation(context: moc)
        nc.product = _product
        nc.timestamp = date
        if let _amount = Float(amount) {
            nc.amount = _amount
        } else {
            Alert(title: Text("Error"), message: Text("Invalid amount"), dismissButton: .default(Text("Got it!")))
        }

        try? moc.save()
    }
}

struct ContentView: View {
//    @FetchRequest(
//        entity: Consumation.entity(),
//        sortDescriptors: []
//    ) var Consumations: FetchedResults<Consumation>
    @State var Consumations : [Consumation] = []
    @State var caloriesToday : Float = 0
    @Environment(\.managedObjectContext) var moc

    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Label("Calories consumed today", image: "bolt.Fill")
                        .font(Font.title.bold())
                    Text("")
                }
                List {
                    ForEach(Consumations) { (c:Consumation) in
                        NavigationLink(destination: ConsumationDetailView(consumation: c)) {
                            HStack {
                                Text(c.timestamp!, format: .dateTime.hour().minute())
                                Spacer()
                                Text(c.product!.name ?? "kke")
                                Spacer()
                                Text(String(format: "%.1f", c.amount * c.product!.calories) + " kcal")
                            }
                        }
                    }
                    .onDelete(perform: delete)
                }
                .onAppear(){
                    loadTodayConsumations()
                }
                .toolbar() {
                    HStack{
                        EditButton()
                        Button("Add Empty") {
                            let newProduct = Product(context: moc)
                            newProduct.name = "Banana"
                            newProduct.calories = 1.0
                            
                            let newConsumation = Consumation(context: moc)
                            newConsumation.timestamp = Date()
                            newConsumation.amount = 100
                            newConsumation.product = newProduct
                                                  
                            try? moc.save()
                            loadTodayConsumations()
                        }
                        NavigationLink(destination: ConsumationCreateView()){
                            Text("Add product")
                        }
                    }
                }
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        for offset in offsets {
            let consumation = Consumations[offset]
            moc.delete(consumation)
        }
        Consumations.remove(atOffsets: offsets)
        try? moc.save()
    }
    
    func loadTodayConsumations() {
        let date = Date()
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: date)
        let predicate = NSPredicate(format: "timestamp >= %@", today as NSDate)
        
        let _fr = Consumation.fetchRequest()
        _fr.predicate = predicate
        
        let _result = try! self.moc.fetch(_fr)
        
        self.Consumations = _result
    }
    
//    init() {
//
//    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
