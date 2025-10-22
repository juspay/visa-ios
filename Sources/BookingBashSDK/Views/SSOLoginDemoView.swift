import SwiftUI

struct SSOLoginDemoView: View {
    @StateObject private var homeViewModel = HomeViewModel()
    @State private var encryptedToken = "eyJraWQiOiJrZXlfYjYzMzE2OGU3YmU0NDViYmIzOGZkMzJlMTk4YTVhOTYiLCJjdHkiOiJKV1QiLCJlbmMiOiJBMjU2R0NNIiwiYWxnIjoiUlNBLU9BRVAtMjU2In0.JVsvmYznycTkuY9Br4JqA4zcaHWsHT5iuMAIHr2OVifU4ZYQOl0c0gZPAxQnsuUQfE66cIq9LdL2BD1vmAhz54VcSMx8BLknKc0pc2yYrdxIn24iK_NQuoPR7CUxcvF-Q5GCuaSSJYItm0S_zNUHQRIpnUNbcy2MSgS_Cssnu7r5wnSLzbP18js7UNIvWyR4IUO6MLkpYq9u2uvQuWjVY26TTvnRbE7-8KqatsceuyrJJwgD19CMVitLtnyV60rMeditCGZxZl6Y3Z_nk8I1FIo2eZlvTkxmLhf-3W6NwiDmK5FHBf6VXXY37x7wcoPa-6AkbMDmDZUhpce-LYs-7g.wQs9prmcwZk7MSWq.Fzbl7iNE6HzbK0nSvYw3a8B50xNPDrwWm0gD4-wn1CQVqjMbGL4yOrJ73-At0DOZH_ptEqicG-emO02la6l2mL_vGxyvbUu2eh4joCpGWrxzNIj-gRfMSdd036HtDphJKyg_RMqrNOAuwNP7LiLWRuz3nbrVEwZ6H8DRgnPEa_5UIJjVg52D4q6uPvblvjZTOXt1pwPE1TMCIA4hglKuw9r6al_AtTdqQN4n3B5e1OvQVCMJgriidk_HfLnFp9KPNuwLxDNbcU8QPf6AwTI_xFTZLZN9Bei-vRzaIWdEkKD6p4vp7QTNt6Sc2gq1kYRmlw22edTT3DPf5ZVWJfN279QpUN74MI9j3iFtpj4IxhX4x4A8yXpK7cclR3_np4sULFw-f0zuDQDXkLnEqyDwtXgm3cAN8ECL9PXp9DuPBbvwPXLyzo3aiwWWPDLIJkhUVkffO8ZJgKYOJ1rq8XmN2866lgBGBklQHWaREOsPpGmAlBVyjtgn7nNJ8Ul_FTsBKAm0m8oWuZ3ES4DmzFsRR7sSt_hQ2DaZUkFoX0tbrCjk6A-yUxmBPpAqOVEEz2SkFKlYy1_fP8NVU5X3uNBGLVemB9BsLVteJCLPabaC8wjUbs7mlUH6OBo7Ag5DzWqIxMBVByqxBHiaOaaFT0VE2qKETS9ou5prwrP8NlLejVVoH9aHV44vqtN5H-MJV67ifl0I_0kU3tvrvz-aUJm_RqU-kemokPYEfgAt--5Fd4wiLnyXsAjtY1_6BUYUpPORIqwCzdSRxyJBu3wLUnMNybWqSo6HwMNlxDxHdSV9WxbBg-ymytoUVxsy7Scj5kX79DuOGNC3q6ZMtZl49YqmqwIpnbpUZ3xg9-U79EBrbSa_pTN1Qt9FgR2pt5y99q8uFQp1JMN7V0XinyORimh2IjCld5mhcpJoYYuizWFvhNXCd6F_mEPjGqVwD_GAWJQiMTT_OHsRzs0__2XynzynytAAOAol0bSvMMR1zjqjNW1G1zZQvtVS-ZYqVHneCOf5mk67iKApmVloYWk_l9kMivTFx728KpE5VCqQUshN5wCe3l58C59-WCfTXu_81XBByDPpz-cAnYvkyNfsgv37krfdrxn-F-AaeNIsygaQ8ZB8-HizeUPIBKg_OpCElpQOefFpxXmuhDRQmOMDMnOitb7ipwK0a5TFSgDa6Nq92KYkdeI1K0Jv35zoMiOg_q3KYaS8mrwXbW9tZeTcsfMDPdoEslGCmMmCybzusYeCEi6HrMPIgkvfmL6YAVxyvF32LqAamC8QWMJhkVdHuWNYypAuYf_GgEdTd85rhEfRFHcYuzM-0yiVpg.4mwVUZAEGhigeKFJCTJ2bA"
    
    var body: some View {
        VStack(spacing: 20) {
            Text("SSO Login Demo")
                .font(.title)
                .padding()
            
            VStack {
                Text("Encrypted Token:")
                    .font(.headline)
                TextEditor(text: $encryptedToken)
                    .frame(height: 150)
                    .border(Color.gray, width: 1)
            }
            .padding()
            
            Button(action: {
                homeViewModel.performSSOLogin(encryptedToken: encryptedToken)
            }) {
                if homeViewModel.isSSOLoginLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    Text("Perform SSO Login")
                }
            }
            .disabled(homeViewModel.isSSOLoginLoading || encryptedToken.isEmpty)
            .padding()
            .background(homeViewModel.isSSOLoginLoading ? Color.gray : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            if !homeViewModel.errorMessage.isEmpty {
                Text("Error: \(homeViewModel.errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            }
            
            if let response = homeViewModel.ssoLoginResponse {
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("SSO Login Response:")
                            .font(.headline)
                        
                        Text("Status: \(response.status ? "Success" : "Failed")")
                        Text("Message: \(response.message)")
                        Text("User ID: \(response.data.userId)")
                        Text("Name: \(response.data.firstName) \(response.data.lastName)")
                        Text("Email: \(response.data.email)")
                        Text("Login Type: \(response.data.loginType)")
                        Text("Login Flow: \(response.data.loginFlow)")
                        Text("Member ID: \(response.data.loyalty.req.memberProfile.memberId)")
                        Text("Points Balance: \(response.data.loyalty.pointsBalance)")
                    }
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    SSOLoginDemoView()
}