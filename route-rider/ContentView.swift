//
//  ContentView.swift
//  route-rider
//
//  Created by Thaer Aldefai on 23.10.20.
//

import SwiftUI

struct ContentView: View {
    @State private var showAddItemView = false
    @State private var pickerDate = Date()
    @State private var buttonname: String = "Button title"
    
    
    var body: some View{
        
        
        NavigationView{
   
            VStack {
           
                datePickerView(date: $pickerDate)
                buttonview(name: buttonname, actionScope: {showAddItemView = true})
                datePickerView(date: $pickerDate)
                buttonview(name: buttonname, actionScope: {showAddItemView = true})
                buttonview(name: "add Route", actionScope: {})
                
                
            List{
                    ListElementView()
                }
            }
            

        
       
          
            .navigationTitle("Titel")
            .sheet(isPresented: $showAddItemView, content: {
                addItemview(showAddItemView: $showAddItemView)
            })
        }
    }
}


private func datePickerView(date: Binding<Date>) -> some View {
    return DatePicker("Picker", selection: date).labelsHidden().padding()
}



private func buttonview(name: String, actionScope: @escaping () -> Void  ) -> some View {
    return Button(action: actionScope) {
        Text(name)
    }
    .padding()
}


struct ListElementView: View {
    
    @State private var isSelected = false
    
    var body: some View {
        HStack {
            
            Button(action: {isSelected.toggle()}) {
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle" )
            }
            // make press only on the button icon
            .buttonStyle(PlainButtonStyle())
            
            Text("list element")
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            ContentView()
            ListElementView()
                .previewLayout(.sizeThatFits)
        }
    }
}


