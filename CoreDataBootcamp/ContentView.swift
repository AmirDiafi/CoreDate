//
//  ContentView.swift
//  CoreDataBootcamp
//
//  Created by AmirDiafi on 7/26/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: FruitEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \FruitEntity.name, ascending: true)]
    )
    private var fruits: FetchedResults<FruitEntity>
    @State var value: String = ""
    @State var isUpdating: Bool = false
    @State var updatingIndex: FruitEntity?

    var body: some View {
        NavigationView{
            VStack{
                VStack{
                    TextField("Add a fruit", text: $value)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    Button(action: {
                        if isUpdating && value.count > 0 {
                            updateItem(targetValue: updatingIndex!)
                        } else {
                            addItem(item: value)
                        }
                    }) {
                        Text(isUpdating ? "Save" : "Add")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }
                
                List {
                    ForEach(fruits) { fruit in
                        Text(fruit.name ?? "")
                        .onTapGesture {
                            withAnimation {
                                isUpdating = true
                                value = fruit.name ?? ""
                                updatingIndex = fruit
                            }
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Core Data Bootcamp")
        }
    }
    
    private func saveItems(){
        withAnimation{
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func addItem(item: String) {
        if item.count > 0 {
            withAnimation {
                let newFruit = FruitEntity(context: viewContext)
                newFruit.name = item
                saveItems()
                value = ""
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            guard let index = offsets.first else {return}
            let fruitEntity = fruits[index]
            viewContext.delete(fruitEntity)
            saveItems()
        }
    }
    
    private func updateItem(targetValue: FruitEntity){
        withAnimation{
            guard let index = fruits.firstIndex(of: targetValue) else {return}
            let fruitEntity = fruits[index]
            fruitEntity.name = value
            value = ""
            saveItems()
            isUpdating = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewDevice("iPhone 12").environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
