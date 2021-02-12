//
//  ContentView.swift
//  route-rider
//
//  Created by Thaer on 23.10.20.
//

import SwiftUI

struct ContentView: View {
    @State private var showAddItemView = false
    @State private var pickerDate = Date()
    @State private var buttonname: String = "Search Place"
    
    
    var body: some View{
        
        
        NavigationView{
   
            VStack {
           
                buttonview(name: buttonname, color:Color.green ,actionScope: {showAddItemView = true})
                datePickerView(date: $pickerDate)
                buttonview(name: buttonname, color:Color.blue ,actionScope: {showAddItemView = true})
                datePickerView(date: $pickerDate)
                
                Button(action: {}) {
                    Text("Click me!")
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.red)
                
            List{
                    ListElementView()
                }
            }
            

        
       
          
            .navigationTitle("Titel")
            .sheet(isPresented: $showAddItemView, content: {
                //addItemview()
            })
        }
    }
}


private func datePickerView(date: Binding<Date>) -> some View {
    return DatePicker("Picker", selection: date).labelsHidden().padding()
}



private func buttonview(name: String, color: Color ,actionScope: @escaping () -> Void  ) -> some View {
    return Button(action: actionScope) {
        Text(name)
    }
    .padding()
    .foregroundColor(.white)
    .background(color)
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


