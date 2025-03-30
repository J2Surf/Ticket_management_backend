# Ticket Management Backend

A NestJS-based backend service for managing tickets, wallets, and batch processing operations.

## Features

- User Authentication and Authorization
- Ticket Management System
- Wallet Integration
- Batch Processing
- Dashboard Analytics
- Role-based Access Control

## Prerequisites

- Node.js (v16 or higher)
- MySQL Database
- npm or yarn package manager

## Installation

1. Clone the repository:

```bash
git clone <repository-url>
cd ticket_management_backend
```

2. Install dependencies:

```bash
npm install
```

3. Create a `.env` file in the root directory with the following variables:

```env
DATABASE_HOST=localhost
DATABASE_PORT=3306
DATABASE_USERNAME=your_username
DATABASE_PASSWORD=your_password
DATABASE_NAME=your_database
JWT_SECRET=your_jwt_secret
```

4. Run database migrations:

```bash
npm run typeorm migration:run
```

## Running the Application

Development mode:

```bash
npm run start:dev
```

Production mode:

```bash
npm run build
npm run start:prod
```

## API Documentation

### Authentication

All endpoints except login/register require JWT authentication. Include the JWT token in the Authorization header:

```
Authorization: Bearer <your_jwt_token>
```

### Authentication APIs

#### Register

- `POST /auth/register`
  - Register a new user
  - Request Body:
    ```json
    {
      "username": "john_doe",
      "password": "secure123",
      "email": "john.doe@example.com",
      "role": "customer",
      "phone": "+1234567890"
    }
    ```
  - Response:
    ```json
    {
      "id": 1,
      "username": "john_doe",
      "email": "john.doe@example.com",
      "role": "CUSTOMER",
      "phone": "+1234567890",
      "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
    }
    ```
  - Error cases:
    - 409: Username already exists
    - 409: Email already exists (if email provided)
    - 409: Role not found (if specified role doesn't exist)

#### Login

- `POST /auth/login`
  - Login with email/username and password
  - Request Body:
    ```json
    {
      "email": "john.doe@example.com",
      "password": "secure123"
    }
    ```
  - Response:
    ```json
    {
      "id": 1,
      "username": "john_doe",
      "email": "john.doe@example.com",
      "role": "CUSTOMER",
      "phone": "+1234567890",
      "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
    }
    ```
  - Error cases:
    - 401: Invalid credentials
    - 401: Account is not active
    - 401: Password is required
    - 401: Please provide either email or username (not both)

### User Roles

- ADMIN: Full system access
- CUSTOMER: Can create tickets and manage their wallet
- FULFILLER: Can process tickets and manage their wallet
- USER: Can validate and decline tickets

### Endpoints

#### Tickets

- `POST /tickets`

  - Create a new ticket
  - Request Body:
    ```json
    {
      "facebook_name": "John Doe",
      "amount": 100.5,
      "game": "Mobile Legends",
      "game_id": "ML123456",
      "payment_method": "GCash",
      "payment_tag": "GCASH123",
      "account_name": "JohnDoe123",
      "payment_qr_code": "https://example.com/qr/123456",
      "clientId": 1
    }
    ```
  - Response:
    ```json
    {
      "id": 1,
      "facebook_name": "John Doe",
      "amount": 100.5,
      "game": "Mobile Legends",
      "game_id": "ML123456",
      "payment_method": "GCash",
      "payment_tag": "GCASH123",
      "account_name": "JohnDoe123",
      "payment_qr_code": "https://example.com/qr/123456",
      "status": "new",
      "created_at": "2024-03-20T10:30:00Z"
    }
    ```
  - Access: All authenticated users

- `GET /tickets`

  - Get all tickets
  - Query Parameters:
    - status: "new"
    - page: 1
    - limit: 10
  - Response:
    ```json
    {
      "data": [
        {
          "id": 1,
          "facebook_name": "John Doe",
          "amount": 100.5,
          "game": "Mobile Legends",
          "status": "new",
          "created_at": "2024-03-20T10:30:00Z"
        }
      ],
      "meta": {
        "total": 1,
        "page": 1,
        "limit": 10,
        "totalPages": 1
      }
    }
    ```
  - Access: ADMIN only

- `GET /tickets/:id`

  - Get ticket by ID
  - Path Parameters:
    - id: "1"
  - Response:
    ```json
    {
      "id": 1,
      "facebook_name": "John Doe",
      "amount": 100.5,
      "game": "Mobile Legends",
      "game_id": "ML123456",
      "payment_method": "GCash",
      "payment_tag": "GCASH123",
      "account_name": "JohnDoe123",
      "payment_qr_code": "https://example.com/qr/123456",
      "status": "new",
      "created_at": "2024-03-20T10:30:00Z"
    }
    ```
  - Access: ADMIN, USER, FULFILLER

- `PUT /tickets/:id/validate`

  - Validate a ticket
  - Path Parameters:
    - id: "1"
  - Response:
    ```json
    {
      "id": 1,
      "status": "validated",
      "validated_at": "2024-03-20T11:00:00Z"
    }
    ```
  - Access: USER role

- `PUT /tickets/:id/decline`

  - Decline a ticket
  - Path Parameters:
    - id: "1"
  - Response:
    ```json
    {
      "id": 1,
      "status": "declined",
      "declined_at": "2024-03-20T11:00:00Z"
    }
    ```
  - Access: USER role

- `PUT /tickets/:id/complete`

  - Complete a ticket
  - Path Parameters:
    - id: "1"
  - Request Body:
    ```json
    {
      "paymentImageUrl": "https://example.com/payment/123456.jpg",
      "transactionId": "TRX123456"
    }
    ```
  - Response:
    ```json
    {
      "id": 1,
      "status": "completed",
      "completed_at": "2024-03-20T11:30:00Z",
      "paymentImageUrl": "https://example.com/payment/123456.jpg",
      "transactionId": "TRX123456"
    }
    ```
  - Access: FULFILLER role

- `GET /tickets/status/:status`
  - Get tickets by status
  - Path Parameters:
    - status: TicketStatus (required, enum: new, validated, declined, completed, error, sent)
  - Access: ADMIN, USER, FULFILLER

#### Wallet

- `POST /wallet/connect`

  - Connect a wallet
  - Request Body:
    ```json
    {
      "type": "USDT",
      "walletAddress": "0x742d35Cc6634C0532925a3b844Bc454e4438f44e"
    }
    ```
  - Response:
    ```json
    {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "type": "USDT",
      "walletAddress": "0x742d35Cc6634C0532925a3b844Bc454e4438f44e",
      "balance": 0,
      "status": "PENDING",
      "createdAt": "2024-03-20T10:00:00Z"
    }
    ```
  - Access: CUSTOMER, FULFILLER

- `POST /wallet/deposit`

  - Make a deposit
  - Request Body:
    ```json
    {
      "type": "USDT",
      "amount": 100.5
    }
    ```
  - Response:
    ```json
    {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "type": "USDT",
      "balance": 100.5,
      "status": "ACTIVE",
      "lastTransaction": "2024-03-20T10:30:00Z"
    }
    ```
  - Access: CUSTOMER, ADMIN

- `GET /wallet`

  - Get all wallets
  - Response:
    ```json
    {
      "wallets": [
        {
          "id": "550e8400-e29b-41d4-a716-446655440000",
          "type": "USDT",
          "balance": 100.5,
          "status": "ACTIVE"
        },
        {
          "id": "550e8400-e29b-41d4-a716-446655440001",
          "type": "BTC",
          "balance": 0.005,
          "status": "ACTIVE"
        }
      ]
    }
    ```
  - Access: All authenticated users

- `GET /wallet/:type`

  - Get wallet by type
  - Path Parameters:
    - type: "USDT"
  - Response:
    ```json
    {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "type": "USDT",
      "balance": 100.5,
      "status": "ACTIVE",
      "walletAddress": "0x742d35Cc6634C0532925a3b844Bc454e4438f44e"
    }
    ```
  - Access: All authenticated users

- `PATCH /wallet/:id/status`
  - Update wallet status
  - Path Parameters:
    - id: "550e8400-e29b-41d4-a716-446655440000"
  - Request Body:
    ```json
    {
      "status": "SUSPENDED"
    }
    ```
  - Response:
    ```json
    {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "type": "USDT",
      "status": "SUSPENDED",
      "updatedAt": "2024-03-20T11:00:00Z"
    }
    ```
  - Access: ADMIN only

#### Batch Processing

- `POST /batch-processing/create`

  - Create a new batch
  - Request Body:
    ```json
    {
      "paymentMethod": "GCash"
    }
    ```
  - Response:
    ```json
    {
      "id": 1,
      "paymentMethod": "GCash",
      "status": "pending",
      "createdAt": "2024-03-20T10:00:00Z",
      "ticketCount": 0
    }
    ```
  - Access: ADMIN only

- `GET /batch-processing/fulfiller/:fulfillerId/batches`

  - Get fulfiller's batches
  - Path Parameters:
    - fulfillerId: "1"
  - Response:
    ```json
    {
      "batches": [
        {
          "id": 1,
          "paymentMethod": "GCash",
          "status": "processing",
          "createdAt": "2024-03-20T10:00:00Z",
          "ticketCount": 5,
          "completedCount": 2
        }
      ]
    }
    ```
  - Access: FULFILLER role

- `POST /batch-processing/batch/:batchId/start`

  - Start batch processing
  - Path Parameters:
    - batchId: "1"
  - Response:
    ```json
    {
      "id": 1,
      "status": "processing",
      "startedAt": "2024-03-20T10:30:00Z",
      "ticketCount": 5
    }
    ```
  - Access: FULFILLER role

- `POST /batch-processing/batch/:batchId/ticket/:ticketId/complete`

  - Complete a ticket in a batch
  - Path Parameters:
    - batchId: "1"
    - ticketId: "1"
  - Request Body:
    ```json
    {
      "paymentImageUrl": "https://example.com/payment/123456.jpg"
    }
    ```
  - Response:
    ```json
    {
      "id": 1,
      "batchId": 1,
      "ticketId": 1,
      "status": "completed",
      "completedAt": "2024-03-20T11:00:00Z"
    }
    ```
  - Access: FULFILLER role

- `GET /batch-processing/fulfiller/:fulfillerId/metrics`
  - Get fulfiller metrics
  - Path Parameters:
    - fulfillerId: "1"
  - Response:
    ```json
    {
      "totalBatches": 10,
      "completedBatches": 8,
      "totalTickets": 50,
      "completedTickets": 45,
      "successRate": 90,
      "averageProcessingTime": 15.5
    }
    ```
  - Access: FULFILLER role

#### Dashboard

- `GET /dashboard/customer`

  - Get customer dashboard data
  - Response:
    ```json
    {
      "totalTickets": 5,
      "activeTickets": 2,
      "completedTickets": 3,
      "walletBalance": {
        "USDT": 100.5,
        "BTC": 0.005
      },
      "recentTransactions": [
        {
          "id": 1,
          "amount": 50.25,
          "type": "deposit",
          "date": "2024-03-20T10:00:00Z"
        }
      ]
    }
    ```
  - Access: CUSTOMER role

- `GET /dashboard/fulfiller`

  - Get fulfiller dashboard data
  - Response:
    ```json
    {
      "totalBatches": 10,
      "activeBatches": 2,
      "completedBatches": 8,
      "totalTickets": 50,
      "completedTickets": 45,
      "successRate": 90,
      "recentActivity": [
        {
          "id": 1,
          "type": "batch_completed",
          "details": "Batch #1 completed with 5 tickets",
          "date": "2024-03-20T11:00:00Z"
        }
      ]
    }
    ```
  - Access: FULFILLER role

- `GET /dashboard/wallet/balance/:type`
  - Get wallet balance by type
  - Path Parameters:
    - type: "USDT"
  - Response:
    ```json
    {
      "type": "USDT",
      "balance": 100.5,
      "lastUpdated": "2024-03-20T11:00:00Z",
      "recentTransactions": [
        {
          "id": 1,
          "amount": 50.25,
          "type": "deposit",
          "date": "2024-03-20T10:00:00Z"
        }
      ]
    }
    ```
  - Access: CUSTOMER, FULFILLER

## Error Handling

The API uses standard HTTP status codes:

- 200: Success
- 201: Created
- 400: Bad Request
- 401: Unauthorized
- 403: Forbidden
- 404: Not Found
- 500: Internal Server Error

## Testing

Run unit tests:

```bash
npm run test
```

Run e2e tests:

```bash
npm run test:e2e
```

Run test coverage:

```bash
npm run test:cov
```

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request

## License

This project is licensed under the UNLICENSED License.
