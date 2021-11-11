//
//  ContentView.swift
//  K-MERCH
//
//  Created by Arrinal Sholifadliq on 20/10/21.
//

import SwiftUI

struct MainView: View {
    @State var top = UIApplication.shared.windows.first?.safeAreaInsets.top
    @StateObject var viewModel = ViewModel()
    @State var isNavigateToCart = false
    @State var isNavigateToItem = false
    @State var itemz = Item()
    
    let layout = [
        GridItem(.flexible(minimum: 170)),
        GridItem(.flexible(minimum: 170))
    ]
    
    
    var body: some View {
        
        NavigationView {
            TabView {
                VStack(alignment: .leading) {
                    
                    VStack {
                        ScrollView {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    CardView(text: "Photocard", backgroundColor: .yellow)
                                    CardView(text: "Album", backgroundColor: .purple)
                                    CardView(text: "CD / DVD", backgroundColor: .gray)
                                    CardView(text: "Lightstick", backgroundColor: .pink)
                                    CardView(text: "Photobook", backgroundColor: .blue)
                                }
                            }
                            
                            HStack {
                                Text("Featured Items")
                                    .bold()
                                    .multilineTextAlignment(.leading)
                                    .padding(.top)
                                Spacer()
                            }
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(viewModel.items) { item in
                                        if item.isFeatured {
                                            ImageCardView(img: item.image , title: item.name)
                                                .onTapGesture {
                                                    itemz = item
                                                    isNavigateToItem = true
                                                }
                                            
                                        }
                                    }
                                }
                            }
                            
                            HStack {
                                Text("Best Seller Items")
                                    .bold()
                                    .padding(.top)
                                Spacer()
                            }
                            
                            BestSellerGridView(items: viewModel.items)
                        }
                    }
                    
                    
                    
                    Spacer()
                }
                .padding(.leading)
                .padding(.trailing)
                .padding(.bottom)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                
                CartView()
                    .tabItem {
                        Label("Profile", systemImage: "person.circle.fill")
                    }
            }
            .onAppear {
                viewModel.getItems()
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("K-MERCH")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.blue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "cart.fill")
                        .onTapGesture {
                            isNavigateToCart = true
                            print(isNavigateToCart)
                        }
                }
            }
            .background(
                NavigationLink(destination: CartView(), isActive: $isNavigateToCart) {
                    EmptyView()
                }
            )
            .background(
                NavigationLink(destination: ItemView(item: itemz), isActive: $isNavigateToItem) {
                    EmptyView()
                }
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .environmentObject(viewModel)
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
