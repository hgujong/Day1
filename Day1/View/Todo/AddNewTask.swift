//
//  AddNewTask.swift
//  Day1
//
//  Created by 서종현 on 2023/02/06.
//

import SwiftUI

struct AddNewTask: View {
    @ObservedObject var model: ViewModel
    // MARK: All Environment Values in one variable
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Edit task")
                .font(.title3.bold())
                .foregroundColor(Color("ThemeColor"))
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading) {
                    Button {
                        model.openEditTask = false
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.title3)
                            .foregroundColor(Color("ThemeColor"))
                    }
                }
                .overlay(alignment: .trailing){
                    Button {
                        if let editTast = model.editTask {
                            context.delete(editTast)
                            try? context.save()
                            model.openEditTask = false
                        }
                    } label: {
                        Image(systemName: "trash")
                            .font(.title3)
                            .foregroundColor(.red)
                    }
                    .opacity(model.editTask == nil ? 0 : 1)
                }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Task Color")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                // MARK: Sample Card Colors
                let colors: [String] =
                    ["Color 1", "Color 2", "Color 3", "Color 4"]
                
                HStack(spacing: 15) {
                    ForEach(colors , id: \.self) { color in
                        Circle()
                            .fill(Color(color))
                            .frame(width: 30, height: 30)
                            .background{
                                if model.color == color {
                                    Circle()
                                        .strokeBorder(.gray)
                                        .padding(-3)
                                }
                            }
                            .contentShape(Circle())
                            .onTapGesture {
                                model.color = color
                            }
                    }
                }
                .padding(.top, 10)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 30)
            
            Divider()
                .padding(.vertical, 10)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Task Deadline")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(model.currentDay.formatted(date: .abbreviated, time: .omitted))
                    .padding(.top, 10)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .padding(.top, 8)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .overlay(alignment: .bottomTrailing){
                Button {
                    
                } label: {
                    Image(systemName: "calendar")
                        .foregroundColor(.primary)
                }
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Task Title")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                TextField("", text: $model.content)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 10)
            }
            
            Divider()
            
            // MARK: Save Button
            Button{
                if model.addData(context: context){
                    model.openEditTask = false
                }
            } label: {
                Text("Save")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .foregroundColor(.white)
                    .background{
                        Capsule()
                            .fill(Color("ThemeColor"))
                    }
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 10)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
    }
}

struct AddNewTask_Previews: PreviewProvider {
    static var previews: some View {
        AddNewTask(model: .init())
    }
}
