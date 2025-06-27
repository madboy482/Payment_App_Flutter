# Payment Dashboard Backend

A NestJS-based backend API for the Payment Dashboard System.

## Features

- JWT Authentication
- Role-based access control (Admin, Viewer)
- Payment management with filtering and pagination
- User management
- Dashboard statistics
- MongoDB integration with Mongoose
- Automatic data seeding

## Prerequisites

- Node.js (v16 or higher)
- MongoDB (local or cloud instance)
- npm or yarn

## Installation

1. Install dependencies:
```bash
npm install
```

2. Set up environment variables:
Copy `.env.example` to `.env` and update the values:
```bash
MONGODB_URI=mongodb://localhost:27017/payment-dashboard
JWT_SECRET=your-super-secret-jwt-key-change-this-in-production
JWT_EXPIRATION=24h
PORT=3000
```

3. Start MongoDB (if running locally):
```bash
mongod
```

4. Run the application:
```bash
# Development
npm run start:dev

# Production build
npm run build
npm run start:prod
```

## Default Credentials

- Username: `admin`
- Password: `admin123`

## API Endpoints

### Authentication
- `POST /auth/login` - User login

### Users
- `GET /users` - List all users (Admin only)
- `POST /users` - Create new user (Admin only)

### Payments
- `GET /payments` - List payments with filtering and pagination
- `GET /payments/stats` - Get dashboard statistics
- `GET /payments/:id` - Get payment details
- `POST /payments` - Create new payment
- `POST /payments/seed` - Seed sample data (Admin only)

### Query Parameters for GET /payments:
- `status` - Filter by payment status (success, failed, pending)
- `method` - Filter by payment method
- `startDate` - Filter by start date
- `endDate` - Filter by end date
- `page` - Page number (default: 1)
- `limit` - Items per page (default: 10)

## Project Structure

```
src/
├── auth/           # Authentication module
├── users/          # User management module
├── payments/       # Payment management module
├── common/         # Shared components (guards, decorators, DTOs)
├── app.module.ts   # Main application module
└── main.ts         # Application entry point
```

## Technologies Used

- NestJS - Node.js framework
- MongoDB - Database
- Mongoose - ODM for MongoDB
- JWT - Authentication
- bcryptjs - Password hashing
- class-validator - Request validation
- Passport - Authentication middleware
