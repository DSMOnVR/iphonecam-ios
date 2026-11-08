import SwiftUI

struct SetupView: View {
    @Binding var serverURL: String
    var onConnect: (URL) -> Void

    @State private var text: String = ""

    init(serverURL: Binding<String>, onConnect: @escaping (URL) -> Void) {
        self._serverURL = serverURL
        self.onConnect = onConnect
    }

    var body: some View {
        VStack(spacing: 18) {
            Spacer()

            Image(systemName: "video.fill")
                .font(.system(size: 46))
                .foregroundStyle(.green)

            Text("iPhoneCam")
                .font(.largeTitle.bold())

            Text("Enter your PC server address")
                .foregroundStyle(.secondary)

            TextField("https://192.168.1.89:8443/", text: $text)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.URL)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .multilineTextAlignment(.center)

            Button {
                var t = text.trimmingCharacters(in: .whitespacesAndNewlines)
                if !t.contains("://") { t = "https://" + t }
                if !t.hasSuffix("/") { t += "/" }
                guard let url = URL(string: t) else { return }
                serverURL = t
                onConnect(url)
            } label: {
                Text("Connect").frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(text.trimmingCharacters(in: .whitespaces).isEmpty)

            Text("Run start.bat on your PC first, and install the cert on this iPhone once.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Spacer()
        }
        .padding(24)
        .onAppear { text = serverURL }
    }
}
