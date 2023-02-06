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
    @Environment(\.self) var env
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Edit task")
                .font(.title3.bold())
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading) {
                    Button {
                        env.dismiss
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.title3)
                            .foregroundColor(.black)
                    }
                }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Task Color")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                // MARK: Sample Card Colors
                let colors: [String] =
                    ["Yellow", "Green", "Blue", "Purple", "Red", "Orange"]
                
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
                
                Text(model.taskDeadline.formatted(date: .abbreviated, time: .omitted))
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
                        .foregroundColor(.black)
                }
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Task Title")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                TextField("", text: $model.taskTitle)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 10)
            }
            
            Divider()
            
            // MARK: Save Button
            Button{
                
            } label: {
                Text("Save")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .foregroundColor(.white)
                    .background{
                        Capsule()
                            .fill(.black)
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
