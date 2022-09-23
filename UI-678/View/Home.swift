//
//  Home.swift
//  UI-678
//
//  Created by nyannyan0328 on 2022/09/23.
//

import SwiftUI

struct Home: View {
    @State var currentImage : CustomShape = .cloud
    
    @State var pickedImage : CustomShape = .cloud
    
    @State var turnOffImage : Bool = false
    
    @State var aniatedMorpy : Bool = false
    @State var blurRadius : CGFloat = 0
    var body: some View {
        VStack{
            
            GeometryReader{proxy in
                
                let size = proxy.size
                
                Image("p1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width,height: size.height)
                     .offset(y:-40)
                    .clipped()
                    .overlay {
                        Rectangle()
                            .fill(.white)
                            .opacity(turnOffImage ? 1 : 0)
                    }
                
                    .mask {
                        
                        
                        Canvas { context, size in
                            
                            context.addFilter(.alphaThreshold(min: 0.5))
                            context.addFilter(.blur(radius:blurRadius >= 20 ? 20 - (blurRadius - 20) : blurRadius))
                            
                            context.drawLayer { cxt in
                                
                                
                                if let reslovedImage = context.resolveSymbol(id: 1){
                                    
                                    cxt.draw(reslovedImage, at: CGPoint(x: size.width / 2 , y: size.height / 2))
                                }
                            }
                            
                        } symbols: {
                            
                            ResolvedView(currentImage: $currentImage)
                                .tag(1)
                            
                        }

                    }
                    .onReceive(Timer.publish(every: 0.03, on: .main, in: .common).autoconnect()) { _ in
                        
                        if aniatedMorpy{
                            
                            if blurRadius <= 40{
                                
                                blurRadius += 0.5
                                
                                if blurRadius.rounded() == 20{
                                    
                                    currentImage = pickedImage
                                }
                                if blurRadius == 40{
                                    
                                    aniatedMorpy = false
                                    blurRadius = 0
                                }
                            }
                            
                            
                        }
                    }
                
                
                
            }
            .frame(height: 300)
            
            
            Picker(selection: $pickedImage) {
                
                ForEach(CustomShape.allCases ,id:\.self){shape in
                    
                    
                    Image(systemName: shape.rawValue)
                        .tag(shape)
                }
                
            } label: {
                
                
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .overlay {
                Rectangle()
                    .fill(.red.opacity(0.3))
                    .opacity(aniatedMorpy ? 0.1 : 0)
            }
            .onChange(of: pickedImage) { newValue in
                aniatedMorpy = true
            }
            
            
            Toggle("Turn off Image", isOn: $turnOffImage)
                .padding(.vertical,30)
                .padding(.horizontal,60)
                
                
            
            
         

            
        }
        .offset(y:-30)
        .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .top)
    }
  
}

struct ResolvedView : View{
    @Binding var currentImage : CustomShape
    var body: some View{
        
        Image(systemName: currentImage.rawValue)
            .font(.system(size: 200))
            .animation(.interactiveSpring(response: 0.6,dampingFraction: 0.5,blendDuration: 0.6), value: currentImage)
            .frame(width: 300,height: 300)
        
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
