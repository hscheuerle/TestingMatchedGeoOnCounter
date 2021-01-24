//
//  ContentView.swift
//  TestingMatchedGeoOnCounter
//
//  Created by harry scheuerle on 1/23/21.
//

// Doesn't animate work in preview provider???

import SwiftUI

extension View {
    func positionOne(geo: GeometryProxy) -> some View {
        self.position(
            x: geo.size.width / 2,
            y: geo.size.height / 2)
    }
    func positionTwo(geo: GeometryProxy) -> some View {
        self.position(
            x: geo.size.width / 4,
            y: geo.size.height / 2
        )
    }
    func positionThree(geo: GeometryProxy) -> some View {
        self
            .opacity(0)
            .position(
                x: geo.size.width / 8,
                y: geo.size.height / 2
            )
    }
}

extension Notification {
    static let Tapped = Notification.Name.init("Tapped")
}

struct TextView: View {
    static let nc = NotificationCenter.default
    @Namespace var anim
    @State var id = 0
    
    @State var p: Int
    let geo: GeometryProxy
    
    func nextState() {
        
        if p == 0 {
            withAnimation {
                p = 1
            }
            return
        }
        
        if p == 1 {
            withAnimation {
                p = 2
            }
            return
        }
        
        if p == 2 {
            id += 1
            withAnimation {
                p = 0
            }
            id += 1
            return
        }
    }
    
    var body: some View {
        Group {
            if p == 0 {
                Text("Animate")
                    .matchedGeometryEffect(id: id, in: anim)
                    .positionOne(geo: geo)
            }
            
            if p == 1 {
                Text("Animate")
                    .matchedGeometryEffect(id: id, in: anim)
                    .positionTwo(geo: geo)
            }
            
            if p == 2 {
                Text("Animate")
                    .matchedGeometryEffect(id: id, in: anim)
                    .positionThree(geo: geo)
            }
        }
        .onReceive(Self.nc.publisher(for: Notification.Tapped)) { _ in
            nextState()
        }
    }
}

struct ContentView: View {
    var body: some View {
        Color.red.overlay(
            GeometryReader { geo in
                TextView(p: 0, geo: geo)
                TextView(p: 1, geo: geo)
                TextView(p: 2, geo: geo)
            }
        )
        .onTapGesture {
            NotificationCenter.default.post(
                name: Notification.Tapped, object: nil)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
