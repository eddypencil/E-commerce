# 🛍️ E-commerce App (Flutter)

A modern and scalable **E-commerce mobile application** built using **Flutter**, with state management via `flutter_bloc`, robust dependency handling with `get_it`, and secure data storage using `flutter_secure_storage`.

This app showcases clean architecture principles, domain-driven design, and real-world e-commerce functionality including cart management, product browsing, geolocation, and more.

## 🚀 Features

-  Product Listing & Detail View
-  Shopping Cart Functionality
-  Order & Checkout Screens
-  payment via paymob
-  Location Access & Map View
-  Persistent Storage with Hydrated Bloc
-  Secure User Data Handling
-  Responsive UI with `flutter_screenutil`
-  Skeleton Loading UI
-  Dependency Injection using `get_it`

## 📸 Screenshots





### 🛠️ Setup Instructions

1. **Clone the Repository**

   ```bash
   git clone https://github.com/eddypencil/E-commerce.git
   cd E-commerce






## 💳 Payment Integration

This project integrates **Paymob** as the payment gateway provider.

### Supported Payment Methods

- Visa/Mastercard

### 🔒 Payment Flow

1. Authenticate with Paymob
2. Create Order with selected items
3. Generate Payment Key
4. Redirect user to Paymob Iframe using `url_launcher`

> All communication with Paymob is securely done via HTTPS using `dio`.
