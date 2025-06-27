# Payment Dashboard System

A full-stack payment management dashboard built with NestJS (backend) and Flutter (frontend). This system provides secure payment processing simulation, user management, and comprehensive analytics with real-time updates.

## 🚀 Project Overview

This is a complete payment dashboard system that includes:
- **Backend**: NestJS-based REST API with MongoDB
- **Frontend**: Flutter web/mobile application
- **Authentication**: JWT-based security
- **Features**: Payment simulation, user management, analytics, and reporting

## 📋 Features

### Backend (NestJS)
- ✅ JWT Authentication with role-based access control
- ✅ RESTful API design with validation
- ✅ MongoDB integration with Mongoose
- ✅ Payment management with filtering and pagination
- ✅ User management system
- ✅ Dashboard statistics and analytics
- ✅ Automatic data seeding
- ✅ CORS enabled for frontend integration

### Frontend (Flutter)
- ✅ Modern, responsive UI design
- ✅ Secure authentication with token storage
- ✅ Interactive dashboard with charts
- ✅ Payment transaction management
- ✅ Advanced filtering and pagination
- ✅ User management (admin only)
- ✅ Real-time data updates
- ✅ Cross-platform support (Web, Mobile, Desktop)

## 🛠️ Tech Stack

| Layer | Technology |
|-------|------------|
| **Frontend** | Flutter (Dart) |
| **Backend** | NestJS (Node.js/TypeScript) |
| **Database** | MongoDB |
| **Authentication** | JWT |
| **State Management** | Provider (Flutter) |
| **Charts** | fl_chart |
| **API Documentation** | REST |

## 📦 Project Structure

```
payment-dashboard-system/
├── backend/                 # NestJS Backend
│   ├── src/
│   │   ├── auth/           # Authentication module
│   │   ├── users/          # User management module
│   │   ├── payments/       # Payment processing module
│   │   ├── common/         # Shared components
│   │   ├── app.module.ts   # Main application module
│   │   └── main.ts         # Application entry point
│   ├── .env                # Environment variables
│   ├── package.json        # Dependencies
│   └── README.md          # Backend documentation
│
├── frontend/               # Flutter Frontend
│   ├── lib/
│   │   ├── models/         # Data models
│   │   ├── providers/      # State management
│   │   ├── screens/        # Application screens
│   │   ├── services/       # API services
│   │   ├── widgets/        # Reusable components
│   │   └── main.dart       # Application entry point
│   ├── pubspec.yaml        # Dependencies
│   └── README.md          # Frontend documentation
│
└── README.md              # This file
```

## 🚀 Quick Start

### Prerequisites
- Node.js (v16 or higher)
- MongoDB (local or cloud)
- Flutter SDK (v3.8.1 or higher)
- Dart SDK

### 1. Setup Backend
```bash
cd backend
npm install
cp .env.example .env  # Update MongoDB URI and JWT secret
npm run start:dev
```

### 2. Setup Frontend
```bash
cd frontend
flutter pub get
flutter run -d chrome  # For web
```

### 3. Access the Application
- **Frontend**: http://localhost:3001 (or your Flutter port)
- **Backend API**: http://localhost:3000
- **Default Login**: username: `admin`, password: `admin123`

## 📱 Application Screens

### 1. Login Screen
- Clean authentication interface
- Pre-filled demo credentials
- Form validation and error handling
- JWT token management

### 2. Dashboard
- Key metrics overview (transactions, revenue, failures)
- Interactive revenue trend chart (last 7 days)
- Real-time statistics
- Quick navigation

### 3. Transactions Page
- Paginated payment list
- Advanced filtering:
  - Payment status (success, failed, pending)
  - Payment method (credit card, PayPal, etc.)
  - Date range selection
- Detailed transaction view
- Search and sort capabilities

### 4. Add Payment Page
- Payment simulation form
- Multiple payment methods support
- Status selection (success/failed/pending)
- Input validation
- Success notifications

### 5. Users Page (Admin Only)
- User management interface
- Create new users with role assignment
- View user details and status
- Role-based access control

## 🔐 Authentication & Security

- **JWT Tokens**: Secure authentication with refresh capability
- **Role-Based Access**: Admin and Viewer roles
- **Password Hashing**: bcryptjs for secure password storage
- **CORS Protection**: Configured for frontend-backend communication
- **Input Validation**: Server-side validation using class-validator

## 📊 API Endpoints

### Authentication
- `POST /auth/login` - User authentication

### Users (Admin only)
- `GET /users` - List all users
- `POST /users` - Create new user

### Payments
- `GET /payments` - List payments with filtering
- `GET /payments/stats` - Dashboard statistics
- `GET /payments/:id` - Get payment details
- `POST /payments` - Create new payment
- `POST /payments/seed` - Seed sample data

## 🏗️ Database Schema

### User Collection
```javascript
{
  username: String (unique),
  email: String (unique),
  password: String (hashed),
  roles: [String],
  isActive: Boolean,
  timestamps: true
}
```

### Payment Collection
```javascript
{
  amount: Number,
  method: String (enum),
  status: String (enum),
  receiver: String,
  sender: String,
  description: String,
  transactionId: String (auto-generated),
  failureReason: String,
  timestamps: true
}
```

## 🔧 Configuration

### Backend Configuration (.env)
```bash
MONGODB_URI=mongodb://localhost:27017/payment-dashboard
JWT_SECRET=your-super-secret-jwt-key
JWT_EXPIRATION=24h
PORT=3000
ADMIN_USERNAME=admin
ADMIN_PASSWORD=admin123
```

### Frontend Configuration
Update `lib/services/api_service.dart`:
```dart
static const String baseUrl = 'http://localhost:3000';
```

## 🎯 Default Demo Data

The system automatically creates:
- **Admin User**: username: `admin`, password: `admin123`
- **Sample Payments**: 50 simulated transactions with various statuses
- **Revenue Data**: 7 days of sample revenue trends

## 🧪 Testing

### Backend Testing
```bash
cd backend
npm test
npm run test:e2e
```

### Frontend Testing
```bash
cd frontend
flutter test
```

## 🚀 Deployment

### Backend Deployment
- **Recommended**: Render, Railway, or Heroku
- **Environment**: Update production environment variables
- **Database**: Use MongoDB Atlas for production

### Frontend Deployment
- **Web**: `flutter build web` → Deploy to Netlify/Vercel
- **Mobile**: `flutter build apk` → Google Play Store
- **Desktop**: `flutter build windows/macos/linux`

## 📈 Performance Optimizations

- **Backend**: Mongoose connection pooling, request validation
- **Frontend**: Lazy loading, pagination, state management optimization
- **Database**: Indexed queries, aggregation pipelines
- **API**: Response caching, rate limiting ready

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🎯 Learning Outcomes

This project demonstrates:
- **Full-stack development** with modern technologies
- **RESTful API design** and implementation
- **Database modeling** and relationships
- **Authentication and authorization** patterns
- **State management** in Flutter applications
- **Responsive UI design** principles
- **Real-time data visualization**
- **Clean architecture** patterns

## 📞 Support

For support and questions:
- Create an issue in this repository
- Check the individual README files in backend/ and frontend/ folders
- Review the API documentation in the backend

---

**Built with ❤️ using NestJS and Flutter**

---