# WordyPDF — Word (DOC/DOCX) to PDF (macOS)

WordyPDF, macOS üzerinde DOC veya DOCX dosyalarını tek seferde PDF'e dönüştürmeyi kolaylaştıran basit bir masaüstü uygulamasıdır.

## Öne Çıkan Özellikler

- Bir veya birden fazla `.doc` / `.docx` dosyasını aynı anda seçip PDF'e dönüştürebilme
- Çıktı PDF'ler için hedef klasör seçimi
- LibreOffice'in yerel PDF aktarım motorunu kullanarak yerel, çevrimdışı dönüştürme
- Basit, macOS'a özgü arayüz ile hızlı kullanım

## Gereksinimler

- macOS (uygun sürüm: macOS 10.13 veya üzeri önerilir)
- LibreOffice (uygulama, LibreOffice'in PDF aktarma motorunu kullanır)
- Dönüştürülen dosyada kullanılan fontların Mac'te kurulu olması daha doğru görünümler sağlar

> Not: İlk çalıştırmada macOS uygulama için dosya erişimi izni (ör. Masaüstü / Belgeler / Seçilen klasörler) isteyebilir; bu normaldir.

## Kurulum

1. Hazır uygulama (Word to PDF.app) kullanıyorsanız uygulamayı çift tıklayarak açın.
2. Kaynak koddan derlemek isterseniz depoyu klonlayın ve aşağıdaki adımları izleyin:

```sh
git clone https://github.com/fikoture/WordyPDF.git
cd WordyPDF
./build.sh
```

Derleme tamamlandığında `Word to PDF.app` paketini `dist/` veya build çıktısında belirtilen klasörde bulacaksınız.

## Kullanım

1. Uygulamayı açın (`Word to PDF.app`).
2. "Dosya Seç" butonuyla bir veya daha fazla `.doc` / `.docx` dosyası seçin.
3. PDF'lerin kaydedileceği hedef klasörü seçin.
4. "PDF'e Çevir" butonuna basın.

Uygulama dönüştürme işlemi boyunca ilerleme bilgisi gösterir ve tamamlandığında işlem sonucunu bildirir.

## İçerideki Dönüştürme Motoru

- WordyPDF, dönüştürme işlemleri için sistemde yüklü olan LibreOffice'i kullanır (komut satırı arayüzü/UNO).
- Bu nedenle LibreOffice'in doğru şekilde kurulu ve PATH veya uygulama yolunun doğru ayarlanmış olması önemlidir.

## Hata Ayıklama ve Sık Karşılaşılan Sorunlar

- Bozuk veya desteklenmeyen Word formatı: Dosya LibreOffice ile açılamıyorsa düzgün dönüştürülmez.
- Eksik fontlar: PDF'de yazı tipi farklı gözükebilir; eksik fontları Mac'e kurmak genellikle sorunu çözer.
- İzin hataları: macOS'ta uygulama klasörlere erişim izni vermeniz gerekebilir. Sistem Tercihleri → Güvenlik ve Gizlilik → Gizlilik bölümünden erişimleri kontrol edin.
- LibreOffice bulunamıyorsa: Terminal'de `soffice --version` çalıştırarak LibreOffice'in erişilebilir olduğunu doğrulayın.

## Geliştirme

- Kaynak kodu düzenlerseniz tekrar derlemek için:

```sh
./build.sh
```

- Kod değişiklikleri, uygulama paketinin yeniden oluşturulmasını gerektirir.

## Katkıda Bulunma

- Hatalar ve istekler için Issues açabilirsiniz.
- Basit düzeltmeler için fork -> branch -> PR akışı kullanılabilir.

## Lisans

Bu projenin lisansı: (Lütfen uygun lisans bilgisini buraya ekleyin, örn. MIT)

---

Teşekkürler — eklemek istediğiniz özellikler, desteklenen Word öğeleri veya ekran görüntüleri varsa README'i ona göre genişletebilirim.
