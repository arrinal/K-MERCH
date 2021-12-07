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
    @State var item = Item()
    
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
                                                    self.item = item
                                                    viewModel.navigationSelection = "Item View"
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
                            
                            ScrollView {
                                LazyVGrid(columns: layout) {
                                    ForEach(viewModel.items) { item in
                                        if item.isBestSeller {
                                            BestSellerGridView(name: item.name, img: item.image, price: item.price)
                                                .onTapGesture {
                                                    self.item = item
                                                    viewModel.navigationSelection = "Item View"
                                                }
                                        }
                                    }
                                }
                            }
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
//                viewModel.getItems()
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
                            viewModel.navigationSelection = "Cart View"
                        }
                }
            }
            .background(
                NavigationLink(destination: CartView(), tag: "Cart View", selection: $viewModel.navigationSelection) {
                    EmptyView()
                }
            )
            .background(
                NavigationLink(destination: ItemView(item: item), tag: "Item View", selection: $viewModel.navigationSelection) {
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
