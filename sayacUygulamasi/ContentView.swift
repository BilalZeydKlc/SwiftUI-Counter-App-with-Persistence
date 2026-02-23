//
//  ContentView.swift
//  sayacUygulamasi
//
//  Created by Bilal Zeyd Kılıç on 16.02.2026.
//

import SwiftUI
#Preview {
    ContentView()
}

struct KayitModel: Identifiable, Codable {
    var id = UUID()
    var baslik: String
    var sayi: Int
    var tarih: Date
}

struct ContentView: View {
    
    @State var sayac = 0
    @State var baslik = ""
    
    
    @State var kayitlar: [KayitModel] = []
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                
                TextField("Neyi Sayıyorsun?", text: $baslik)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                
                VStack {
                    Text(baslik.isEmpty ? "Sayaç" : baslik)
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Text("\(sayac)")
                        .font(.system(size: 80, weight: .bold))
                        .contentTransition(.numericText())
                }
                
                
                HStack(spacing: 40) {
                    Button(action: {
                        sayac -= 1
                    }) {
                        Text("-")
                            .font(.largeTitle)
                            .frame(width: 70, height: 70)
                            .background(Color.red.opacity(0.8))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    
                    Button(action: {
                        sayac += 1
                    }) {
                        Text("+")
                            .font(.largeTitle)
                            .frame(width: 70, height: 70)
                            .background(Color.blue.opacity(0.8))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                }
                
                
                Button("Sonucu Kaydet") {
                    
                    let yeniKayit = KayitModel(baslik: baslik.isEmpty ? "Sayaç" : baslik,
                                               sayi: sayac,
                                               tarih: Date())
                    
                    
                    kayitlar.insert(yeniKayit, at: 0)
                    
                    
                    verileriHafizayaYaz()
                    
                    
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                .padding()
                .font(.headline)
                
                
                List {
                    ForEach(kayitlar) { kayit in
                        NavigationLink(destination: DetaySayfasi(gelenVeri: kayit)) {
                            HStack {
                                Text("\(kayit.sayi)")
                                    .font(.title)
                                    .foregroundColor(.blue)
                                    .frame(width: 50)
                                
                                VStack(alignment: .leading) {
                                    Text(kayit.baslik)
                                        .font(.headline)
                                    
                                    Text(kayit.tarih.formatted(date: .numeric, time: .shortened))
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    .onDelete(perform: sil)
                }
                .onAppear {
                    
                    if let data = UserDefaults.standard.data(forKey: "GecmisListesiModel") {
                        if let decoded = try? JSONDecoder().decode([KayitModel].self, from: data) {
                            kayitlar = decoded
                        }
                    }
                }
                
            }
            .navigationTitle("Stajyer Sayacı")
            .padding()
            
        }
    }
    
    
    func sil(at offsets: IndexSet) {
        kayitlar.remove(atOffsets: offsets)
        verileriHafizayaYaz()
    }
    
    func verileriHafizayaYaz() {
        if let encoded = try? JSONEncoder().encode(kayitlar) {
            UserDefaults.standard.set(encoded, forKey: "GecmisListesiModel")
        }
    }
}


struct DetaySayfasi: View {
    let gelenVeri: KayitModel
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "note.text")
                .font(.system(size: 100))
                .foregroundColor(.blue)
            
            Text("Seçilen Kayıt:")
                .font(.headline)
                .foregroundColor(.gray)
            
            Text(gelenVeri.baslik)
                .font(.largeTitle)
                .bold()
            
            Text("\(gelenVeri.sayi) Adet")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text(gelenVeri.tarih.formatted())
                .foregroundColor(.gray)
                .padding()
        }
    }
}

#Preview {
    ContentView()
}
