//
//  UIView.swift
//  ExitekTechTask
//
//  Created by Данила on 08.09.2022.
//

import SwiftUI
import Combine

struct UIView: View {
    
    let viewModel: ViewModel
    
    @State var imei: String = ""
    @State var model: String = ""
    
    @State private var showingAlert = false
    @State var alertText = ""
    @State var alertTitle = ""
    
    @FocusState private var isFocused: Bool
    
    // MARK: - methods
    private func saveItem() {
        let bool = viewModel.action(.save, imei, model)
        
        if bool {
            alertTitle = "Save"
            alertText = imei + " " + model
            imei = ""
            model = ""
        } else {
            alertTitle = "Not Save"
            alertText = imei + " " + model
        }
    }
    
    private func deleteItem() {
        let bool = viewModel.action(.delete, imei, model)
        
        if bool {
            alertTitle = "Delete"
            alertText = imei + " " + model
            imei = ""
            model = ""
        } else {
            alertTitle = "Not found"
            alertText = imei + " " + model
        }
    }
    
    private func isExists() {
        
        let bool = viewModel.action(.exists, imei, model)
        
        if bool {
            alertTitle = "Exists"
            alertText = imei + " " + model
        } else {
            alertTitle = "No Exists"
            alertText = imei + " " + model
        }
    }
    
    private func findByImei() {
        let mobile = viewModel.findByImei(imei)
        
        alertTitle = "We found"
        
        if mobile != nil, let imei = mobile?.imei, let model = mobile?.model {
            alertText = imei + " " + model
        } else {
            alertText = "Nothing"
        }
    }
    
    private func getAll() {
        print(viewModel.getAll())
    }
    
    // MARK: - View
    var body: some View {
        NavigationView {
            VStack{
                TextField("imei", text: $imei)
                    .focused($isFocused)
                    .frame(height: 25.0)
                    .keyboardType(.numberPad)
                    .onReceive(Just(imei)) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            self.imei = filtered
                        }
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.gray, lineWidth: 1)
                    )
                    .padding(5)
                TextField("model", text: $model)
                    .focused($isFocused)
                    .frame(height: 25.0)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.gray, lineWidth: 1)
                    )
                    .padding( 5.0)
                HStack( spacing: 30.0){
                    Button {
                        deleteItem()
                        isFocused = false
                        showingAlert = true
                    } label: {
                        Text("Delete")
                            .font(.title)
                            .foregroundColor(.red)
                    }
                    
                    Button {
                        isExists()
                        isFocused = false
                        showingAlert = true
                    } label: {
                        Text("Exists").font(.title)
                    }
                    
                    Button {
                        saveItem()
                        isFocused = false
                        showingAlert = true
                    } label: {
                        Text("Save")
                            .font(.title)
                            .foregroundColor(.green)
                    }
                }
                .padding(.bottom, 10.0)
                Button {
                    findByImei()
                    isFocused = false
                    showingAlert = true
                } label: {
                    Text("Find By Imei")
                        .font(.title)
                        .padding(.bottom, 30.0)
                }
                Button {
                    getAll()
                    isFocused = false
                } label: {
                    Text("Print Set")
                        .font(.title)
                        .padding(.bottom, 20.0)
                }
                
                NavigationLink(destination: ArrayUIView(viewModel: viewModel)) {
                    Text("Show All")
                        .font(.title)
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle),
                      message: Text(alertText),
                      dismissButton: .default(Text("Got it!")))
            }
        }
    }
}

struct UIView_Previews: PreviewProvider {
    static var previews: some View {
        UIView(viewModel: ViewModel())
    }
}
