> Industri kesehatan menghasilkan data yang sangat besar dan beragam, mulai dari informasi pasien, dokter, rumah sakit, hingga catatan pengobatan. Sayangnya, data ini sering tersimpan dalam bentuk mentah yang terpisah-pisah, tidak konsisten, dan sulit diolah untuk analisis.
untuk mengatasi masalah tersebut diperlunya membangun sebuah sistem data yang terintergarasi dalam data warehouse berbasis star schema untuk kebutuhan monitoring, serta mengembangkan dashboard  sebagai sarana decision making.

## End-to-End Data Architecture
![arsitektur](images/arsitektur_finpro.png)

Arsitektur sistem menggunakan:
- *Data Source*: generate data dummy menggunakan producer.py
- *Data Integration*: Script Python untuk memuat data ke Google BigQuery pada layer `raw`.
- *Data Transformation*: DBT digunakan untuk membuat tabel `staging`, `model`, dan `data mart` serta validasi data pada layer model.
- *Data Orchestration*: Apache Airflow mengatur urutan eksekusi job.
- *Notification*: notification pipeline mengirim status pipeline (success/failure) 
- *Visualization*: Tableu digunakan untuk membuat dashboard interaktif.

Flow:
`producer.py → RAW → STAGING → MODEL → Validasi data → MART → Tableu`

## Data Model (Star Chema) Healthcare
![relasi](images/ERD.png)

Struktur Star Schema pada Data Warehouse:
- *Fact Table*: 
    - `fact_healthcare` Menyimpan data detail aktivitas admission pasien.
    - `fact_doctor_rating` Menyimpan informasi terkait rating dokter dan outcome pasien pada setiap admission.
    - `fact_payment` Menyimpan informasi terkait pembayaran pasien, termasuk insurance_provider dan billing_amount.

- *Dimension Tables*:
    - `dim_patient`: Berisi informasi pasien seperti usia, gender, dan golongan darah.
    - `dim_doctor`: Berisi informasi medis, mencakup nama dokter, diagnosa, dan ruangan.


## Dags Design
> menggunakan airflow sebagai orchestration pada proyek ini. disini ada 3 dags yang berfungsi antara lain:

### Dag Producer --python
![producer](images/producer.png)
- berfungsi untuk menghasilkan data dummy atau simulasi data pasien secara terus-menerus.
- Data tersebut ditulis ke healthcare_data.csv yang di simpan ke dalam folder tmp.
- Setelah proses producer selesai, Airflow secara otomatis menjalankan DAG Data Transformation untuk memproses data lebih lanjut.

### Dag Extraction --python
![extrcat](images/extract.png)
- Membuat dataset baru di Google BigQuery menggunakan credentials.json melalui script Python.
- Mengunggah data mentah (raw data) dari healthcare_data.csv ke tabel BigQuery.
- Menambahkan jeda proses untuk memastikan data berhasil terunggah sepenuhnya.
- Setelah proses extract selesai, Airflow secara otomatis menjalankan DAG Data Transformation untuk memproses data lebih lanjut.

### Data Transformation --DBT
![transform](images/transform.png)
- Membuat tabel staging di BigQuery dengan data yang sudah dibersihkan dan distandarisasi.
-  Membangun data model sesuai kebutuhan analisis, seperti tabel dimensi dan fakta.
- Melakukan data testing menggunakan DBT untuk memastikan kualitas data sesuai kriteria.
- Data Mart Membuat data mart siap pakai untuk analisis dan visualisasi.


## Dashboard
> terdapat 3 analisa yang bisa di lihat pada dashboard di bawah ini.

### Overall Patient

![patient](images/patient.png)
- `Pasien elective` mendominasi dengan tren meningkat hingga 240 pasien di 2024.
- `Total pasien` stabil di kisaran 2.200 per tahun, sempat turun drastis di 2022.
- `Rating layanan tertinggi` terjadi pada 2023 (1.355).
- `Outcome pasien` menunjukkan peningkatan pasien sembuh (546 → 808), meski angka kematian masih tinggi di kisaran 700-an.

### Doctor Performance
![doctor](images/performance.png)
- `Rata-rata rating dokter` berfluktuasi, dengan dr. Citra dan dr. Jane memiliki performa cukup stabil.
- `dr. Zhafar` menunjukkan peningkatan signifikan di 2025 (69.16).
- `Outcome pasien` terbagi cukup seimbang: 35.8% dirujuk, 33.3% sembuh, dan 30.8% meninggal.

### Patient Payment
![paymment](images/pay.png)
- `Jumlah tren rovider`, insurance mengalami penurunan 2 tahaun awal dan kenaikan pada tahun 2023 .
- Distribusi provider insurance cukup merata: BPJS (34.5%), - Insurance (33.1%), dan Self-pay (32.2%).
- Dari sisi total payment, Insurance memberikan kontribusi tertinggi (950 juta), diikuti BPJS (924 juta), lalu Self-pay (850 juta).

## Insight Utama:
Dari data rumah sakit dari 3 dashboard dia atas. Rumah sakit berhasil menjaga stabilitas jumlah pasien dan meningkatkan outcome kesembuhan. Dari sisi finansial, kontribusi pembayaran cukup merata antar provider, sehingga risiko pendanaan tidak hanya bertumpu pada satu sumber