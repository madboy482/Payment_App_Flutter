# 🚀 Payment Dashboard API Documentation

## Live API URL
**Base URL:** https://payment-app-flutter.onrender.com

## 🔑 Demo Credentials
```json
{
  "username": "admin", 
  "password": "admin123"
}
```

## 📖 How to Test the API

### Step 1: Visit the API Home Page
Open: https://payment-app-flutter.onrender.com
You'll see API documentation and demo credentials.

### Step 2: Get Authentication Token
**Endpoint:** `POST /auth/login`
**URL:** https://payment-app-flutter.onrender.com/auth/login

**Request Body:**
```json
{
  "username": "admin",
  "password": "admin123"
}
```

**Response:**
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "...",
    "username": "admin",
    "email": "admin@payment-dashboard.com",
    "roles": ["admin"]
  }
}
```

### Step 3: Use Token for Protected Endpoints
Copy the `access_token` and use it in the Authorization header:

**Header Format:**
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

## 📋 API Endpoints

### 🔓 Public Endpoints (No Auth Required)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/` | API documentation and demo info |
| GET | `/health` | Health check |
| POST | `/auth/login` | User authentication |

### 🔒 Protected Endpoints (Auth Required)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/payments` | List all payments with pagination |
| GET | `/payments/stats` | Dashboard statistics |
| GET | `/payments/:id` | Get payment details |
| POST | `/payments` | Create new payment |
| GET | `/users` | List all users (admin only) |
| POST | `/users` | Create new user (admin only) |

## 🧪 Testing Examples

### Example 1: Login
```bash
curl -X POST https://payment-app-flutter.onrender.com/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'
```

### Example 2: Get Dashboard Stats
```bash
curl -X GET https://payment-app-flutter.onrender.com/payments/stats \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

### Example 3: List Payments
```bash
curl -X GET https://payment-app-flutter.onrender.com/payments \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

## 🔧 Testing with Postman

### Collection Import
1. Create new collection in Postman
2. Add requests for each endpoint
3. Set up authorization tab with Bearer token
4. Test in this order:
   - Login → Copy token → Test protected endpoints

### Environment Variables
Create Postman environment with:
```
base_url: https://payment-app-flutter.onrender.com
token: {{access_token_from_login}}
```

## 📊 Sample Responses

### Dashboard Stats Response
```json
{
  "transactionsToday": 5,
  "transactionsThisWeek": 23,
  "revenueToday": 1250.50,
  "revenueThisWeek": 8750.25,
  "failedTransactionsToday": 1,
  "revenueTrend": [
    {"_id": "2025-06-25", "revenue": 1200, "count": 8},
    {"_id": "2025-06-26", "revenue": 1800, "count": 12}
  ]
}
```

### Payments List Response
```json
{
  "payments": [
    {
      "_id": "...",
      "amount": 150.75,
      "method": "credit_card",
      "status": "success",
      "receiver": "user@example.com",
      "description": "Payment for order #123",
      "createdAt": "2025-06-27T10:30:00Z"
    }
  ],
  "total": 50,
  "page": 1,
  "totalPages": 5
}
```

## 🚀 Ready to Test!

1. **Visit:** https://payment-app-flutter.onrender.com
2. **Login with:** admin / admin123  
3. **Copy JWT token**
4. **Test protected endpoints**

**Your API is live and ready for company testing! 🎉**
