//
//  ContentView.swift
//  Shared
//
//  Created by Alaina Thompson on 2/4/22.
//

import SwiftUI

struct ContentView: View {
    @State var e = Darwin.M_E
    @State var eMinusX = 0.0
    @State var totalGuesses = 0.0
    @State var totalIntegral = 0.0
    @State var guessString = "23458"
    @State var totalGuessString = "0"
    @State var eMinusXString = "0.0"
   
    // Setup the GUI to monitor the data from the Monte Carlo Integral Calculator
    @ObservedObject var monteCarlo = MonteCarloInt(withData: true)
    
    //Setup the GUI View
    var body: some View {
        HStack{
            
            VStack{
                
                VStack(alignment: .center) {
                    Text("Guesses")
                        .font(.callout)
                        .bold()
                    TextField("# Guesses", text: $guessString)
                        .padding()
                }
                .padding(.top, 5.0)
                
                VStack(alignment: .center) {
                    Text("Total Guesses")
                        .font(.callout)
                        .bold()
                    TextField("# Total Guesses", text: $totalGuessString)
                        .padding()
                }
                
    
                
                VStack(alignment: .center) {
                    Text("e^-x")
                        .font(.callout)
                        .bold()
                    TextField("", text: $eMinusXString)
                        .padding()
                }
                
                Button("Cycle Calculation", action: {Task.init{await self.calculateEMinusX()}})
                    .padding()
                    .disabled(monteCarlo.enableButton == false)
                
                Button("Clear", action: {self.clear()})
                    .padding(.bottom, 5.0)
                    .disabled(monteCarlo.enableButton == false)
                
                if (!monteCarlo.enableButton){
                    
                    ProgressView()
                }
                
                
            }
            .padding()
            
            //DrawingField
            
            
            drawingView(redLayer:$monteCarlo.insideData, blueLayer: $monteCarlo.outsideData)
                .padding()
                .aspectRatio(1, contentMode: .fit)
                .drawingGroup()
            // Stop the window shrinking to zero.
            Spacer()
            
        }
    }
    
    func calculateEMinusX() async {
        
        
        monteCarlo.setButtonEnable(state: false)
        
        monteCarlo.guesses = Int(guessString)!
        monteCarlo.e = e
        monteCarlo.totalGuesses = Int(totalGuessString) ?? Int(0.0)
        
        await monteCarlo.calculateEMinusX()
        
        totalGuessString = monteCarlo.totalGuessesString
        
        eMinusXString =  monteCarlo.eMinusXString
        
        monteCarlo.setButtonEnable(state: true)
        
    }
    
    func clear(){
        
        guessString = "23458"
        totalGuessString = "0.0"
        eMinusXString =  ""
        monteCarlo.totalGuesses = 0
        monteCarlo.totalIntegral = 0.0
        monteCarlo.insideData = []
        monteCarlo.outsideData = []
        monteCarlo.firstTimeThroughLoop = true
        
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
 
