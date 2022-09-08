//
//  ArrayUIView.swift
//  ExitekTechTask
//
//  Created by Данила on 08.09.2022.
//

import SwiftUI

struct ArrayUIView: View {
    
    var viewModel: ViewModel
    
    var body: some View {
        List(viewModel.mobiles) { mobile in
            HStack{
                Text(mobile.imei ?? "")
                    .padding(5.0)
                Text(mobile.model ?? "")
            }
        }
    }
}

struct ArrayUIView_Previews: PreviewProvider {
    static var previews: some View {
        ArrayUIView(viewModel: ViewModel())
    }
}
