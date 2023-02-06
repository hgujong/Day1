//
//  NewDataView.swift
//  Day1
//
//  Created by 서종현 on 2023/02/02.
//

import SwiftUI

struct NewDataView: View {
    @ObservedObject var model : ViewModel
    @Environment(\.managedObjectContext) var context
    var body: some View {
        VStack{
            
            HStack{
                
                Text("\(model.updateItem == nil ? "Add New" : "Update") Task")
//                    .font(.system(size: 65))
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
                
                Spacer(minLength: 0)
            }
            .padding([.horizontal, .top])
            
            TextEditor(text: $model.content)
                .padding()
            
            Divider()
                .padding(.horizontal)
            
            HStack{
            
                Text("When")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Spacer(minLength: 0)
            }
            .padding()
            
            HStack(spacing: 10){
                
                DateButton(title: "Today", model: model)
                
                DateButton(title: "Tomorrow", model: model)
                
                DatePicker("", selection: $model.date, displayedComponents: .date)
                    .labelsHidden()
                
            }
            .padding()
            
            //추가 버튼
            Button(action: {model.writeData(context: context)}, label: {
                
                Label(
                    title: {Text(model.updateItem == nil ? "Add Now" : "Update")
                            .font(.title2)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    },
                    icon: {Image(systemName: "plus")
                            .font(.title2 )
                            .foregroundColor(.white)
                    })
                .padding(.vertical)
                .frame(width: UIScreen.main.bounds.width - 30)
                .background(
                    LinearGradient(gradient: .init(colors: [Color.indigo,Color.blue,]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(8)
            })
            .padding()
            .disabled(model.content == "" ? true : false)
            .opacity(model.content == "" ? 0.5 : 1 )
 
        }
        .background(Color.black.opacity(0.06).ignoresSafeArea(.all, edges: .bottom))
    }
}

