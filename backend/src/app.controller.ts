import { Controller, Get } from '@nestjs/common';

@Controller()
export class AppController {
  @Get()
  getStatus() {
    return {
      message: '🎉 Payment Dashboard API is running!',
      version: '1.0.0',
      status: 'active',
      timestamp: new Date().toISOString(),
      
      // Demo credentials for testing
      demoCredentials: {
        username: 'admin',
        password: 'admin123',
        note: 'Use these credentials to test the API'
      },
      
      // How to test the API
      howToTest: [
        '1. POST /auth/login with demo credentials to get JWT token',
        '2. Copy the access_token from response',
        '3. Add header: Authorization: Bearer <your-token>',
        '4. Access protected endpoints like /payments/stats'
      ],
      
      // Available endpoints
      endpoints: {
        public: {
          home: 'GET /',
          health: 'GET /health',
          login: 'POST /auth/login'
        },
        protected: {
          payments: 'GET /payments (list all payments)',
          stats: 'GET /payments/stats (dashboard statistics)',
          paymentDetails: 'GET /payments/:id (payment details)',
          createPayment: 'POST /payments (create new payment)',
          users: 'GET /users (list all users - admin only)',
          createUser: 'POST /users (create new user - admin only)'
        }
      },
      
      // Example requests
      examples: {
        login: {
          url: 'POST /auth/login',
          body: {
            username: 'admin',
            password: 'admin123'
          }
        },
        getStats: {
          url: 'GET /payments/stats',
          headers: {
            'Authorization': 'Bearer <your-jwt-token>'
          }
        }
      }
    };
  }

  @Get('health')
  getHealth() {
    return {
      status: 'OK',
      uptime: process.uptime(),
      timestamp: new Date().toISOString(),
    };
  }
}
