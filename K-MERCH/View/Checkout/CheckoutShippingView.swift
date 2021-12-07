//
//  CheckoutShippingView.swift
//  K-MERCH
//
//  Created by Arrinal Sholifadliq on 07/11/21.
//

import SwiftUI
import Combine

struct CheckoutShippingView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State var isShowProvince = false
    @State var isShowCity = false
    @State var selectedDelivery = Delivery()
    @State var isNavigateToPayment = false
    @State var isNotFilled = false
    
    var body: some View {
        
        VStack {
            HStack {
                Text("Shipping")
                    .font(.caption2)
                    .bold()
                VStack {
                    Divider()
                }
                Text("Payment")
                    .font(.caption2)
                    .foregroundColor(.gray)
                VStack {
                    Divider()
                }
                Text("Review")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            
            ScrollView {
                HStack {
                    Text("Add Shipping Address")
                        .font(.title)
                        .bold()
                    Spacer()
                }
                .padding(.top)
                
                
                TextField("Full Name", text: $viewModel.shippingAddress.fullName)
                Divider()
                Group {
                    TextField("Street Address", text: $viewModel.shippingAddress.street)
                        .padding(.top)
                    Divider()
                    TextField("District", text: $viewModel.shippingAddress.district)
                        .padding(.top)
                    Divider()
                    HStack {
                        Button {
                            isShowProvince.toggle()
                        } label: {
                            VStack(alignment: .leading) {
                                Text(viewModel.shippingAddress.province)
                                    .lineLimit(1)
                                    .foregroundColor(.gray)
                                    .padding(.top)
                                Divider()
                            }
                            .fullScreenCover(isPresented: $isShowProvince) {
                            } content: {
                                ScrollView(showsIndicators: false) {
                                    ForEach(viewModel.provinceList, id: \.self) { each in
                                        Text(each.province)
                                            .onTapGesture {
                                                viewModel.updateProvince(isShowProvince: $isShowProvince, province: each)
                                            }
                                        Divider()
                                    }
                                    .padding(.top)
                                }
                            }
                        }
                        
                        Button {
                            guard viewModel.shippingAddress.province != "Province" else { return }
                            isShowCity.toggle()
                        } label: {
                            VStack(alignment: .leading) {
                                Text(viewModel.shippingAddress.city)
                                    .lineLimit(1)
                                    .foregroundColor(.gray)
                                    .padding(.top)
                                Divider()
                            }
                            .fullScreenCover(isPresented: $isShowCity) {
                            } content: {
                                ScrollView(showsIndicators: false) {
                                    ForEach(viewModel.cityList, id: \.self) { each in
                                        Text(" \(each.city) (\(each.type))")
                                            .onTapGesture {
                                                viewModel.updateCity(isShowCity: $isShowCity, city: each)
                                            }
                                        Divider()
                                    }
                                    .padding(.top)
                                }
                            }
                        }
                    }
                    
                    HStack {
                        VStack {
                            TextField("Postal Code", text: $viewModel.shippingAddress.postalCode)
                                .keyboardType(.numberPad)
                                .onReceive(Just(viewModel.shippingAddress.postalCode)) { newValue in
                                    viewModel.onlyNumberAndLimitText(limit: 5, value: newValue, field: $viewModel.shippingAddress.postalCode)
                                }
                            Divider()
                        }
                        VStack {
                            TextField("Mobile Number", text: $viewModel.shippingAddress.mobileNumber)
                                .onReceive(Just(viewModel.shippingAddress.mobileNumber)) { newValue in viewModel.onlyNumberAndLimitText(limit: 13, value: newValue, field: $viewModel.shippingAddress.mobileNumber)
                                }
                            Divider()
                        }
                    }
                    .padding(.top)
                }
                
                Group {
                    VStack {
                        HStack {
                            Text("Delivery")
                                .font(.title)
                                .bold()
                            Spacer()
                        }
                        
                        if viewModel.deliveryMenu.count == 0 {
                            Spacer()
                            Text("Please complete all shipping address fields to view delivery fee")
                                .bold()
                                .multilineTextAlignment(.center)
                            
                        }
                        ForEach($viewModel.deliveryMenu, id:\.self) { $each in
                            DeliveryView(service: each.service, estimate: each.estimate, price: each.price, delivery: each, selectedDelivery: $selectedDelivery)
                                .onTapGesture {
                                    selectedDelivery = each
                                    viewModel.totalPrice(deliveryPrice: selectedDelivery.price)
                                }
                        }
                    }
                    .padding(.top)
                }
            }
            .padding(.top)
            
            Spacer()
            
            VStack {
                HStack {
                    Text("Subtotal \(viewModel.totalItems) items")
                    Spacer()
                    Text("\(viewModel.cart.subTotal)")
                        .font(.title2)
                }
                HStack {
                    Text("Total")
                        .bold()
                    Spacer()
                    Text("\(viewModel.finalBuy.totalPrice)")
                        .font(.title2)
                        .bold()
                }
            }
            Button {
                viewModel.finalBuy.items = viewModel.cart
                viewModel.finalBuy.shippingAddress = viewModel.shippingAddress
                viewModel.finalBuy.delivery = selectedDelivery
                let shippingAddress = viewModel.finalBuy.shippingAddress
                guard shippingAddress.fullName != "", shippingAddress.street != "", shippingAddress.district != "", shippingAddress.city != "", shippingAddress.province != "", shippingAddress.postalCode != "", shippingAddress.mobileNumber != "", viewModel.finalBuy.delivery.courier != "" else {
                    isNotFilled.toggle()
                    return }
                isNavigateToPayment = true
            } label: {
                ZStack {
                    HStack {
                        Text("Next")
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(20)
                    
                    TemporaryPopUp(isActive: $isNotFilled, text: "Please fill all the shipping field and choose your delivery courier")
                        .offset(y: -70)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    self.isNotFilled.toggle()
                                }
                            }
                        }
                }
            }
            .padding(.top)
            
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("K-MERCH")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.blue)
                }
            }
            .background(
                NavigationLink(destination: CheckoutPaymentView(), isActive: $isNavigateToPayment) {
                    EmptyView()
                }
            )
        }
        .padding(.top, -20)
        .padding(.leading)
        .padding(.trailing)
        .padding(.bottom)
        .onAppear {
            viewModel.fetchProvince()
            if viewModel.shippingAddress.id != "" {
                withAnimation {
                    viewModel.deliveryMenu = []
                }
                viewModel.fetchCost(cityId: viewModel.shippingAddress.id)
            }
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutShippingView()
    }
}
