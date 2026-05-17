# 🏥 MediBook - Advanced Healthcare & Doctor Booking App

MediBook is a premium, full-stack Mobile Application built using **Flutter** and powered by a **Supabase** cloud backend. Designed with an elegant UI/UX and smooth micro-interactions, the app bridges the gap between patients and healthcare professionals seamlessly.

---

## 📺 Demo & Showcase
[![LinkedIn Post](https://img.shields.io/badge/LinkedIn-Video%20Demo-blue?style=for-the-badge&logo=linkedin)](YOUR_LINKEDIN_POST_URL_HERE)
> 💡 *Replace `YOUR_LINKEDIN_POST_URL_HERE` with your actual LinkedIn video link once you upload it!*

---

## ✨ Key Features

### 🔐 1. Secure Authentication
* Full user sign-in flow managed dynamically by **Supabase Auth**.
* Safe handling of user sessions and encrypted credentials.

### 📅 2. Real-Time Appointment Booking (CRUD)
* Users can explore specialized doctor listings based on **Hospitals** and **Medical Specialties**.
* Booking an appointment creates relational data records immediately on the cloud database.
* Integrated dynamic **Bookings Management Dashboard** enabling users to view active schedules or cancel/delete appointments on the fly.

### 🌟 3. Smart "Upcoming Appointment" Card
* Features a smart cloud-driven notification card on the dashboard.
* Automatically fetches and lists the user's absolute closest upcoming medical appointment in real-time.

### 📁 4. Secure Medical Records Storage
* Patients can input report metadata and upload medical documents/images directly.
* Powered by **Supabase Storage Buckets** protected under strict **Row Level Security (RLS)** policies to ensure absolute data privacy.

### 🎨 5. Premium UI/UX Polish
* **Shimmer Effect Loading:** Modern skeleton loading indicators providing a seamless waiting experience while data loads.
* **Animated State Switching:** High-fidelity fade and scale animation transitions when filtering doctor listings.
* **Custom Floating Bottom Navigation Bar:** A sleek, rounded navigation bar hovering gracefully over the screen with fluid, animated icon slide-ups upon selection.
* **Dynamic Dark Mode:** Full dark theme integration across all screens, offering an eye-friendly environment for low-light situations.

---

## 🛠️ Tech Stack & Packages

* **Frontend Framework:** Flutter (Dart)
* **Backend as a Service (BaaS):** Supabase (PostgreSQL, Auth, Storage)
* **State Management:** Provider
* **Key Packages:**
  * `supabase_flutter` - Backend integration.
  * `shimmer` - Premium skeleton screen loading effect.
  * `provider` - Robust global state handling.

---

## 🚀 Getting Started

Follow these steps to run the project locally.

### Prerequisites
* Flutter SDK installed (Latest Stable Version)
* A Supabase Account and a created project
<img width="361" height="797" alt="image" src="https://github.com/user-attachments/assets/afdf79fc-ba86-4ded-8a5e-ca724ec5ff3f" />
<img width="372" height="797" alt="image" src="https://github.com/user-attachments/assets/7d4952fc-9a51-4172-9531-a08f7b012c5b" />
<img width="361" height="797" alt="image" src="https://github.com/user-attachments/assets/7fb97d15-f87e-4dbe-b3ca-e33ad77e3fd4" />

### Installation

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/YOUR_GITHUB_USERNAME/medi-book-flutter.git](https://github.com/YOUR_GITHUB_USERNAME/medi-book-flutter.git)
   cd medi-book-flutter/doctor_app
    x
