//
//  ExperiencePassesCardView.swift
//  VisaActivity
//
//  Created by Apple on 04/08/25.
//

import Foundation
import SUINavigation
import SwiftUI


struct ExperiencePassesCardView: View {
    var package: Package
    var model: ExperienceDetailModel
    @State private var shouldNavigate: Bool = false
    @ObservedObject var viewModel: ExperienceAvailabilitySelectOptionsViewModel
    
    let gridLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text(package.title)
                        .font(.custom(Constants.Font.openSansBold, size: 12))
                        .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                    Spacer()
                    if let arrow = bundleImage(named: Constants.Icons.arrowDown) {
                        arrow
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(Color(hex: Constants.HexColors.primary))
                    }
                }
                .contentShape(Rectangle())
                // Remove .onTapGesture and isExpanded logic

                // Always show expanded content
                VStack(alignment: .leading, spacing: 18) {
                    let visibleItems = package.isInfoExpanded ? package.infoItems : Array(package.infoItems.prefix(2))
                    let leftColumn = visibleItems.enumerated().filter { $0.offset % 2 == 0 }.map { $0.element }
                    let rightColumn = visibleItems.enumerated().filter { $0.offset % 2 != 0 }.map { $0.element }

                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(leftColumn) { item in
                                Label(item.title, systemImage: item.icon)
                                    .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                                    .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                            }
                        }

                        Spacer()

                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(rightColumn) { item in
                                Label(item.title, systemImage: item.icon)
                                    .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                                    .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                            }
                        }
                    }

                    if package.infoItems.count != 0 {
                        Text(package.isInfoExpanded ? Constants.SharedConstants.lessInfo : Constants.SharedConstants.moreInfo)
                            .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                            .foregroundStyle(Color(hex: Constants.HexColors.primary))
                            .padding(.top, -10)
                            .onTapGesture {
                                viewModel.toggleInfo(for: package)
                            }
                    }

                    if !package.times.isEmpty {
                        LazyVGrid(columns: gridLayout, spacing: 8) {
                            ForEach(package.times, id: \.self) { time in
                                Button(action: {
                                    viewModel.selectTime(time, for: package)
                                }) {
                                    Text(time)
                                        .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                                        .foregroundStyle(
                                            package.selectedTime == time
                                            ? Color(hex: Constants.HexColors.primary)
                                            : Color(hex: Constants.HexColors.neutral)
                                        )
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 34)
                                        .background(package.selectedTime == time ? Color(hex: Constants.HexColors.bgPremierWeak) : Color.white)
                                        .cornerRadius(4)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 4)
                                                .stroke(
                                                    package.selectedTime == time
                                                    ? Color(hex: Constants.HexColors.primary)
                                                    : Color(hex: Constants.HexColors.neutralWeak),
                                                    lineWidth: 1
                                                )
                                        )
                                }
                            }
                        }
                    }
                }

                if !package.totalAmount.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Total \(package.totalAmount)")
                            .font(.custom(Constants.Font.openSansBold, size: 12))
                            .foregroundStyle(Color(hex: Constants.HexColors.secondary))

                        ForEach(package.pricingDescription, id: \.self) { line in
                            Text(line)
                                .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                                .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                        }
                    }

                    Button(action: {
                        totalPriceG = package.totalAmount
                        shouldNavigate = true
                    }) {
                        Text(Constants.AvailabilityScreenConstants.bookThisExperience)
                            .font(.custom(Constants.Font.openSansBold, size: 12))
                            .foregroundStyle(.white)
                            .frame(height: 42)
                            .frame(maxWidth: .infinity)
                            .background(Color(hex: Constants.HexColors.primary))
                            .cornerRadius(4)
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(hex: Constants.HexColors.primary), style: StrokeStyle(lineWidth: 1, dash: [3]))
                    .background(Color(hex: Constants.HexColors.surfaceWeakest).cornerRadius(12))
            )
        }
        .onAppear {
            if package.selectedTime == nil, let firstTime = package.times.first {
                viewModel.selectTime(firstTime, for: package)
            }
        }
        .navigation(isActive: $shouldNavigate, id: Constants.NavigationId.experienceCheckoutView) {
            ExperienceCheckoutView(viewModel: viewModel, package: package, model: model)
        }
    }}

// Helper function to load an image from the bundle root
//func bundleImage(named name: String) -> Image? {
//    if let path = Bundle.main.path(forResource: name, ofType: "png"),
//       let uiImage = UIImage(contentsOfFile: path) {
//        return Image(uiImage: uiImage)
//    }
//    return nil
//}
