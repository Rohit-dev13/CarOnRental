# Car On Rental App 🚗

A comprehensive Salesforce application for managing car rental operations, built with Lightning Web Components and modern Salesforce development practices.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Technology Stack](#technology-stack)
- [Architecture](#architecture)
- [Key Components](#key-components)
- [API Documentation](#api-documentation)
- [Testing](#testing)

## 🎯 Overview

The **Car On Rental App** is a full-featured Salesforce application designed to streamline car rental business operations. It provides a complete solution for inventory management, booking processing, payment handling, customer reviews, and administrative workflows.

### Business Value

- **Streamlined Operations**: Automated booking and payment processing
- **Customer Experience**: Modern, responsive UI with real-time updates
- **Business Intelligence**: Comprehensive reporting and analytics
- **Scalability**: Built to handle growing rental businesses
- **Integration Ready**: REST APIs for external system connectivity

## ✨ Features

### 🚗 Car Inventory Management

- Complete car catalog with images and specifications
- Real-time availability tracking
- Advanced filtering and search capabilities
- Service and maintenance scheduling
- Performance analytics and revenue tracking

### 📅 Booking System

- Advanced booking management with overlap validation
- Dynamic pricing calculations
- Coupon code integration with approval workflows
- Status tracking (Pending → Confirmed → Started → Completed)
- Automated notifications and communications

### 💳 Payment Processing

- Multi-stage payment handling
- Security deposit management
- Refund processing automation
- Payment status synchronization
- Financial transaction tracking

### ⭐ Customer Reviews

- Star rating system (1-5 scale)
- Review submission and validation
- Automated case creation for negative feedback
- Average rating calculations
- Customer communication triggers

### 🔧 Administrative Tools

- Approval workflows for coupon codes
- Case management for customer support
- Comprehensive reporting and dashboards
- User role and permission management
- System monitoring and logging

## 🛠 Technology Stack

### Frontend

- **Lightning Web Components (LWC)**: Modern, performant UI components
- **Lightning Design System**: Consistent Salesforce styling
- **JavaScript ES6+**: Modern JavaScript features
- **CSS3**: Responsive design and animations

### Backend

- **Apex**: Server-side business logic
- **Salesforce Platform**: Cloud-based infrastructure
- **SOQL**: Database query language
- **REST APIs**: External integration capabilities

### Development Tools

- **Salesforce CLI**: Command-line development tools
- **VS Code**: Integrated development environment
- **ESLint**: Code quality and consistency
- **Prettier**: Code formatting

### Automation

- **Salesforce Flows**: Process automation
- **Triggers**: Data validation and business logic
- **Platform Events**: Real-time communication
- **Batch Jobs**: Scheduled data processing

## 🏗 Architecture

The application follows a layered architecture pattern:

```
┌─────────────────────────────────────────┐
│           Presentation Layer             │
│     (Lightning Web Components)          │
├─────────────────────────────────────────┤
│           Business Logic Layer          │
│         (Apex Classes & Triggers)        │
├─────────────────────────────────────────┤
│           Data Access Layer             │
│        (Custom Objects & Fields)         │
├─────────────────────────────────────────┤
│           Integration Layer              │
│        (REST APIs & External Services)   │
└─────────────────────────────────────────┘
```

### Core Components

1. **Data Model**: Custom objects representing business entities
2. **Business Logic**: Apex classes handling complex operations
3. **User Interface**: Lightning Web Components for modern UX
4. **Automation**: Flows and triggers for process automation
5. **Integration**: REST APIs for external system connectivity

## 🧩 Key Components

### Lightning Web Components

#### Core UI Components

- **`carTileList`**: Main car listing with filtering
- **`carTile`**: Individual car display card
- **`carFilter`**: Advanced filtering interface
- **`bookCarModal`**: Booking creation modal
- **`carCard`**: Detailed car information display
- **`carRatingReview`**: Review and rating system for cars
- **`carImageManager`**: Car image upload and management interface
- **`estimateBooking`**: Booking cost estimation component
- **`estimateCarBooking`**: Car-specific booking estimation component

#### Utility Components

- **`starRating`**: Reusable star rating component
- **`errorPanel`**: Error handling and display
- **`placeholder`**: Loading and empty states
- **`ldsUtils`**: Lightning Data Service utilities

### Apex Classes

#### Business Logic

- **`BookingTriggerHandler`**: Booking validation and processing
- **`BookingTriggerHandlerService`**: Core booking business logic
- **`CarAvailabilityRestApiService`**: REST API for car availability
- **`CarReviewController`**: Review management
- **`carImageController`**: Car image management
- **`carTileListController`**: Car listing controller
- **`ContactTriggerHandler`**: Contact management
- **`ContactTriggerHandlerService`**: Contact processing service
- **`PaymentTransactionTriggerHandler`**: Payment processing
- **`PaymentTransactionTriggerHandlerService`**: Payment transaction service
- **`ReviewTriggerHandler`**: Review system automation
- **`ReviewTriggerHandlerService`**: Review processing service

#### Utility Classes

- **`Constants`**: Application-wide constants
- **`TestDataFactory`**: Basic test data generation
- **`LogCleanupBatch`**: Automated log cleanup
- **`LogCleanupBatchSchedule`**: Scheduled log cleanup
- **`QueuableTotalCarValue`**: Asynchronous car value calculation
- **`queueableEmailValidation`**: Email validation service
- **`EmailValidatoinHtppMock`**: Mock service for email validation

#### Test Classes

- **`BookingTriggerTest`**: Booking trigger test coverage
- **`CarAvailabilityRestApiServiceTest`**: API service test coverage
- **`ContactTriggerHandlerServiceTest`**: Contact handler test coverage
- **`PaymentTransactionTriggerHandlerTest`**: Payment handler test coverage
- **`ReviewTriggerTest`**: Review trigger test coverage

### Salesforce Flows

#### Process Automation Flows

- **`Approval_for_Coupon_Code`**: Coupon code approval workflow
- **`Car_Return_Checklist`**: Car return process automation
- **`Estimate_your_Booking`**: Booking cost estimation flow
- **`Post_Booking_Automation_After_Save_activity`**: Post-booking activities
- **`Post_Booking_Automation_Field_Update`**: Booking field updates
- **`Post_Booking_Cancellation_Automation`**: Cancellation processing

#### Data Management Flows

- **`Prevent_Deletion_Of_Primary_Image`**: Image protection flow
- **`Sync_Primary_Image`**: Image synchronization flow

### Custom Objects

#### Core Objects

- **`Booking__c`**: Central booking management
- **`Car__c`**: Vehicle inventory
- **`Payment_Transaction__c`**: Financial transactions
- **`Review__c`**: Customer feedback
- **`Coupon_Code__c`**: Discount management
- **`Contact`**: Customer information and management
- **`Case`**: Customer support and issue tracking

#### Supporting Objects

- **`Car_Image__c`**: Vehicle images
- **`Log__e`**: Platform events for logging
- **`LogEvent__c`**: Persistent log storage

## 🔌 API Documentation

### Car Availability API

**Endpoint**: `/services/apexrest/v1/cars/available/*`
**Method**: GET
**Authentication**: Salesforce session-based

#### Request Parameters

```
startDate: YYYY-MM-DD (required)
endDate: YYYY-MM-DD (required)
location: String (required)
fuelType: String (optional)
transmissionType: String (optional)
```

#### Response Format

```json
{
  "success": true,
  "message": "Cars retrieved successfully",
  "cars": [
    {
      "Id": "car_id",
      "Name": "Car Name",
      "Make__c": "Toyota",
      "Model__c": "Camry",
      "Rental_Rate_Per_Day__c": 50.0,
      "Primary_Image_Url__c": "image_url",
      "Availability_Status__c": "Available"
    }
  ]
}
```

## 🧪 Testing

### Test Coverage

- **Apex Classes**: Comprehensive test classes
- **Integration Tests**: End-to-end workflow testing
- **API Tests**: REST service validation

### Test Data

#### Using TestDataFactory (Basic Test Data)

Use the `TestDataFactory` class to generate basic test data:

```apex
List<Contact> contacts = TestDataFactory.createContacts(5);
List<Car__c> cars = TestDataFactory.createCars(10);
List<Booking__c> bookings = TestDataFactory.createBookings(20, contacts, cars);
List<Review__c> reviews = TestDataFactory.createReviews(20, contacts, bookings, 4);
```