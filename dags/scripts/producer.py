import csv
import random, datetime, time
from faker import Faker
fake = Faker()

GENDER = ["male", "female"]
BLOOD = ["A", "B", "AB", "O"]
DIAGNOSIS = ["Diabetes", "Stroke", "Asthma", "Dengue Fever", "Heart Disease", "Cancer"]
DOCTORS = ["Dr. Citra", "Dr. Zhafar", "Dr. Dhika", "Dr. Jane"]
ROOMS = ["ICU", "Emergency Room", "General Ward", "VIP Room"]
PAYMENT = ["BPJS", "Insurance", "Self-Pay"]
OUTCOME = ["recovered", "referred", "deceased"]
ADMISSION = ["emergency", "urgent", "elective"]

def generate_record():
    patient_id = fake.uuid4()
    start_date = datetime.date(2020, 1, 1)
    end_date = datetime.date(2025, 12, 31)
    days_range = (end_date - start_date).days
    admission_date = start_date + datetime.timedelta(days=random.randint(0, days_range))
    age = random.randint(1, 90)
    gender = random.choice(GENDER)
    blood_type = random.choice(BLOOD)
    diagnosa = random.choice(DIAGNOSIS)
    doctor = random.choice(DOCTORS)
    room = random.choice(ROOMS)  
    length_of_stay = random.randint(1, 14)
    adm_type = random.choice(ADMISSION)
    discharge_date = admission_date + datetime.timedelta(days=length_of_stay)
    amount = round(random.uniform(100_000, 10_000_000), 2)
    insurance_provider = random.choice(PAYMENT)
    outcome = random.choice(OUTCOME)
    rating = random.randint(1, 5)

    return [
        patient_id, admission_date, age, gender, blood_type, diagnosa,
        doctor, room, length_of_stay, adm_type, discharge_date,
        amount, insurance_provider, outcome, rating
    ]

csv_path = "/opt/airflow/tmp/healthcare_data.csv"
with open(csv_path, "a", newline="") as f:
    writer = csv.writer(f)
    
    if f.tell() == 0:
        writer.writerow([
            "patient_id", "admission_date", "age", "gender", "blood_type", "diagnosa",
            "doctor", "room", "length_of_stay", "admission_type","discharge_date",
            "amount", "insurance_provider", "outcome", "rating"
        ])

    start_time = time.time()
    duration = 5 * 60  

    while time.time() - start_time < duration:
        record = generate_record()
        writer.writerow(record)
        f.flush()  
        print("Inserted:", record)
        time.sleep(2)
