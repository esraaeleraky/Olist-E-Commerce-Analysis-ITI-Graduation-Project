import pandas as pd
import random

# قراءة البيانات من ملفات الإكسل
orders_df = pd.read_excel("orders.xlsx")
customers_df = pd.read_excel("customers.xlsx")

# دمج جدول الطلبات مع العملاء للحصول على customer_state
merged_df = pd.merge(orders_df, customers_df[['customer_id', 'customer_state']], on='customer_id', how='left')

# تعريف شركات الشحن
logistics_companies = [
    {"logistics_company_id": 1, "logistics_company_name": "DHL", "logistics_contact_number": "+201001234567", "logistics_email": "support@dhl.com", "logistics_website": "https://www.dhl.com"},
    {"logistics_company_id": 2, "logistics_company_name": "FedEx", "logistics_contact_number": "+201002345678", "logistics_email": "help@fedex.com", "logistics_website": "https://www.fedex.com"},
    {"logistics_company_id": 3, "logistics_company_name": "Aramex", "logistics_contact_number": "+201003456789", "logistics_email": "contact@aramex.com", "logistics_website": "https://www.aramex.com"},
    {"logistics_company_id": 4, "logistics_company_name": "UPS", "logistics_contact_number": "+201004567890", "logistics_email": "support@ups.com", "logistics_website": "https://www.ups.com"},
    {"logistics_company_id": 5, "logistics_company_name": "Bosta", "logistics_contact_number": "+201005678901", "logistics_email": "info@bosta.com", "logistics_website": "https://www.bosta.co"},
]

logistics_df = pd.DataFrame(logistics_companies)

# توزيع واقعي بناءً على customer_state
state_to_company = {
    "SP": 5,
    "RJ": 1,
    "MG": 2,
    "BA": 3,
    "RS": 4,
}

def assign_logistics(state):
    return state_to_company.get(state, random.choice(logistics_df['logistics_company_id'].tolist()))

# توزيع شركات الشحن
merged_df['logistics_company_id'] = merged_df['customer_state'].apply(assign_logistics)


orders = merged_df.drop(columns=['customer_state'])

# حفظ الملفات في نفس مجلد السكريبت
orders.to_excel("orders.xlsx", index=False)
logistics_df.to_excel("logistics_companies.xlsx", index=False)


