# GraphQL Implementation Status

## Overview
This document compares the available GraphQL API (backend) with what's currently implemented in the Flutter app.

---

## ✅ FULLY IMPLEMENTED

### 1. User Management
**Backend API:**
- ✅ Query: `me` - Get current user
- ✅ Mutation: `createUser`
- ✅ Mutation: `updateUser`

**Flutter Implementation:**
- ✅ `GraphQLQueries.me` - Implemented
- ✅ Used in `ApiService.getCurrentUserViaGraphQL()`
- ✅ Integrated with auth flow

---

### 2. Business Profile Management
**Backend API:**
- ✅ Query: `myBusinesses` - Get all user's businesses
- ✅ Query: `business(id)` - Get single business
- ✅ Query: `businesses` - List all businesses
- ✅ Mutation: `createBusiness`
- ✅ Mutation: `updateBusiness`
- ✅ Mutation: `deleteBusiness`

**Flutter Implementation:**
- ✅ `GraphQLQueries.getMyBusinesses` - Implemented
- ✅ `GraphQLQueries.getBusiness` - Implemented
- ✅ `GraphQLQueries.createBusiness` - Implemented
- ✅ `GraphQLQueries.updateBusiness` - Implemented
- ✅ `GraphQLQueries.deleteBusiness` - Implemented
- ✅ All integrated in `ApiService`
- ✅ Business provider and UI screens exist

---

### 3. Client Management (Partial)
**Backend API:**
- ✅ Query: `client(id)` - Get single client
- ✅ Query: `clients` - List clients with filters
- ✅ Mutation: `createClient`
- ✅ Mutation: `updateClient`
- ✅ Mutation: `deleteClient`

**Flutter Implementation:**
- ✅ `GraphQLQueries.getClients` - Implemented
- ✅ `GraphQLQueries.createClient` - Implemented
- ✅ `GraphQLQueries.updateClient` - Implemented
- ✅ `GraphQLQueries.deleteClient` - Implemented
- ✅ Basic client list and create screens exist
- ⚠️ Missing: Client details screen
- ⚠️ Missing: Client edit functionality in UI

---

### 4. Invoice Management (Partial)
**Backend API:**
- ✅ Query: `invoice(id)` - Get single invoice
- ✅ Query: `invoices` - List invoices with filters
- ✅ Query: `invoiceItems(invoiceId)` - Get invoice items
- ✅ Mutation: `createInvoice` (with items)
- ✅ Mutation: `updateInvoice`
- ✅ Mutation: `deleteInvoice`
- ✅ Mutation: `sendInvoice`
- ✅ Mutation: `markInvoiceAsPaid`
- ✅ Mutation: `cancelInvoice`

**Flutter Implementation:**
- ✅ `GraphQLQueries.getInvoices` - Implemented
- ✅ `GraphQLQueries.createInvoice` - Implemented
- ✅ Invoice list screen with search/filter
- ✅ Invoice details screen
- ✅ Create invoice screen
- ❌ Missing: `getInvoice(id)` query
- ❌ Missing: `invoiceItems(invoiceId)` query
- ❌ Missing: `updateInvoice` mutation
- ❌ Missing: `deleteInvoice` mutation
- ❌ Missing: `sendInvoice` mutation
- ❌ Missing: `markInvoiceAsPaid` mutation
- ❌ Missing: `cancelInvoice` mutation

---

### 5. Product Management (Partial)
**Backend API:**
- ✅ Query: `product(id)` - Get single product
- ✅ Query: `products` - List products with filters
- ✅ Mutation: `createProduct`
- ✅ Mutation: `updateProduct`
- ✅ Mutation: `deleteProduct`

**Flutter Implementation:**
- ✅ `GraphQLQueries.getProducts` - Implemented
- ✅ `GraphQLQueries.createProduct` - Implemented
- ✅ Basic product list screen exists
- ❌ Missing: `getProduct(id)` query
- ❌ Missing: `updateProduct` mutation
- ❌ Missing: `deleteProduct` mutation
- ❌ Missing: Product details screen
- ❌ Missing: Product edit functionality

---

## ❌ NOT IMPLEMENTED IN FLUTTER

### 6. Payment Management
**Backend API Available:**
- ✅ Query: `payment(id)` - Get single payment
- ✅ Query: `payments` - List payments with filters
- ✅ Mutation: `createPayment` (auto-updates invoice)
- ✅ Mutation: `updatePayment`
- ✅ Mutation: `deletePayment`
- ✅ Mutation: `refundPayment`

**Flutter Implementation:**
- ❌ No GraphQL queries defined
- ❌ No payment repository
- ❌ No payment provider
- ❌ No payment UI screens
- ❌ No payment tracking in invoice details

**Impact:** Cannot record payments, track payment history, or automatically update invoice status when paid.

---

## 📋 MISSING QUERIES & MUTATIONS

### Invoice Operations
```dart
// Missing in graphql_queries.dart:

static const String getInvoice = r'''
  query GetInvoice($id: ID!) {
    invoice(id: $id) {
      id
      invoiceNumber
      status
      invoiceDate
      dueDate
      subtotal
      taxAmount
      discountAmount
      totalAmount
      amountPaid
      amountDue
      currency
      notes
      paymentInstructions
      # ... all fields
    }
  }
''';

static const String getInvoiceItems = r'''
  query GetInvoiceItems($invoiceId: ID!) {
    invoiceItems(invoiceId: $invoiceId) {
      id
      description
      quantity
      unitPrice
      taxRate
      taxAmount
      discountAmount
      lineTotal
    }
  }
''';

static const String updateInvoice = r'''
  mutation UpdateInvoice($id: ID!, $input: UpdateInvoiceInput!) {
    updateInvoice(id: $id, input: $input) {
      id
      status
      # ... fields
    }
  }
''';

static const String deleteInvoice = r'''
  mutation DeleteInvoice($id: ID!) {
    deleteInvoice(id: $id)
  }
''';

static const String sendInvoice = r'''
  mutation SendInvoice($id: ID!) {
    sendInvoice(id: $id)
  }
''';

static const String markInvoiceAsPaid = r'''
  mutation MarkInvoiceAsPaid($id: ID!) {
    markInvoiceAsPaid(id: $id)
  }
''';

static const String cancelInvoice = r'''
  mutation CancelInvoice($id: ID!) {
    cancelInvoice(id: $id)
  }
''';
```

### Payment Operations
```dart
// All payment queries/mutations missing:

static const String getPayments = r'''
  query GetPayments($invoiceId: ID, $status: PaymentStatus, $skip: Int, $limit: Int) {
    payments(invoiceId: $invoiceId, status: $status, skip: $skip, limit: $limit) {
      id
      paymentNumber
      paymentDate
      amount
      paymentMethod
      transactionId
      referenceNumber
      status
      notes
    }
  }
''';

static const String getPayment = r'''
  query GetPayment($id: ID!) {
    payment(id: $id) {
      id
      invoiceId
      paymentNumber
      paymentDate
      amount
      paymentMethod
      transactionId
      referenceNumber
      notes
      status
    }
  }
''';

static const String createPayment = r'''
  mutation CreatePayment($input: CreatePaymentInput!) {
    createPayment(input: $input) {
      id
      paymentNumber
      paymentDate
      amount
      paymentMethod
      status
    }
  }
''';

static const String updatePayment = r'''
  mutation UpdatePayment($id: ID!, $input: UpdatePaymentInput!) {
    updatePayment(id: $id, input: $input) {
      id
      amount
      notes
    }
  }
''';

static const String refundPayment = r'''
  mutation RefundPayment($id: ID!) {
    refundPayment(id: $id)
  }
''';
```

### Product Operations
```dart
// Missing product queries:

static const String getProduct = r'''
  query GetProduct($id: ID!) {
    product(id: $id) {
      id
      businessId
      sku
      name
      description
      unitPrice
      costPrice
      unitOfMeasure
      taxRate
      isTaxable
      trackInventory
      quantityInStock
      lowStockThreshold
      imageUrl
      isActive
    }
  }
''';

static const String updateProduct = r'''
  mutation UpdateProduct($id: ID!, $input: UpdateProductInput!) {
    updateProduct(id: $id, input: $input) {
      id
      name
      unitPrice
      # ... fields
    }
  }
''';

static const String deleteProduct = r'''
  mutation DeleteProduct($id: ID!) {
    deleteProduct(id: $id)
  }
''';
```

### Client Operations
```dart
// Missing client query:

static const String getClient = r'''
  query GetClient($id: ID!) {
    client(id: $id) {
      id
      businessId
      clientType
      companyName
      firstName
      lastName
      email
      phone
      mobile
      website
      taxId
      vatNumber
      paymentTerms
      creditLimit
      currency
      language
      notes
      status
    }
  }
''';
```

---

## 🎯 PRIORITY IMPLEMENTATION ROADMAP

### HIGH PRIORITY (Core Functionality)

#### 1. Invoice Actions (Critical)
**Why:** Users need to manage invoice lifecycle
- [ ] Add `sendInvoice` mutation
- [ ] Add `markInvoiceAsPaid` mutation
- [ ] Add `cancelInvoice` mutation
- [ ] Add `updateInvoice` mutation
- [ ] Add `deleteInvoice` mutation
- [ ] Integrate into invoice details screen
- [ ] Add confirmation dialogs

#### 2. Invoice Items Display (Critical)
**Why:** Users need to see what's on each invoice
- [ ] Add `getInvoiceItems` query
- [ ] Add `getInvoice` query (single invoice with full details)
- [ ] Update invoice details screen to show items
- [ ] Display line items table

#### 3. Payment Management (High)
**Why:** Core feature for tracking payments
- [ ] Create `Payment` model
- [ ] Add all payment GraphQL queries/mutations
- [ ] Create `PaymentRepository`
- [ ] Create `PaymentProvider`
- [ ] Create payment list screen
- [ ] Create payment details screen
- [ ] Create record payment screen
- [ ] Integrate payment recording in invoice details
- [ ] Show payment history in invoice details

### MEDIUM PRIORITY (Enhanced Functionality)

#### 4. Product Management Enhancement
**Why:** Better product catalog management
- [ ] Add `getProduct` query
- [ ] Add `updateProduct` mutation
- [ ] Add `deleteProduct` mutation
- [ ] Create product details screen
- [ ] Create product edit screen
- [ ] Add product search/filter

#### 5. Client Management Enhancement
**Why:** Better client relationship management
- [ ] Add `getClient` query
- [ ] Create client details screen
- [ ] Create client edit screen
- [ ] Show client's invoice history
- [ ] Show client's payment history

### LOW PRIORITY (Nice to Have)

#### 6. Advanced Features
- [ ] Recurring invoices
- [ ] Invoice templates
- [ ] Bulk operations
- [ ] Analytics queries
- [ ] Export functionality
- [ ] Email notifications

---

## 📊 IMPLEMENTATION STATISTICS

### Overall Coverage
- **User Management:** 100% ✅
- **Business Management:** 100% ✅
- **Client Management:** 70% ⚠️
- **Invoice Management:** 40% ⚠️
- **Product Management:** 40% ⚠️
- **Payment Management:** 0% ❌

### Total API Coverage
- **Queries Implemented:** 8 / 15 (53%)
- **Mutations Implemented:** 8 / 20 (40%)
- **Overall:** 16 / 35 (46%)

---

## 🔧 QUICK WINS

These can be implemented quickly to improve functionality:

1. **Invoice Actions** (2-3 hours)
   - Add 5 missing mutations
   - Wire up to invoice details screen buttons
   - Add confirmation dialogs

2. **Invoice Items Display** (1-2 hours)
   - Add `getInvoiceItems` query
   - Update invoice details screen
   - Display items table

3. **Single Invoice Query** (30 minutes)
   - Add `getInvoice` query
   - Use in invoice details screen for full data

---

## 📝 NOTES

### Backend Features Not Used
The backend has these features that aren't being utilized:
- Payment tracking and automatic invoice updates
- Invoice status management (DRAFT → SENT → PAID → CANCELLED)
- Discount calculations (line-item and invoice-level)
- Tax calculations
- Payment method tracking
- Transaction ID tracking
- Refund functionality

### Data Flow Issues
- Invoice details screen doesn't load items from backend
- No way to mark invoices as paid from UI
- No way to send invoices from UI
- No payment history visible anywhere
- Invoice status changes not reflected in real-time

### Recommended Next Steps
1. Implement invoice actions (HIGH PRIORITY)
2. Implement payment management (HIGH PRIORITY)
3. Add invoice items display (HIGH PRIORITY)
4. Enhance client management (MEDIUM)
5. Enhance product management (MEDIUM)

---

## 🚀 GETTING STARTED

To implement missing features:

1. **Add queries to `graphql_queries.dart`**
2. **Add methods to `ApiService`**
3. **Create/update repositories**
4. **Create/update providers**
5. **Update UI screens**
6. **Test with backend**

Example workflow for implementing "Mark as Paid":
```dart
// 1. Add to graphql_queries.dart
static const String markInvoiceAsPaid = r'''
  mutation MarkInvoiceAsPaid($id: ID!) {
    markInvoiceAsPaid(id: $id)
  }
''';

// 2. Add to ApiService
Future<void> markInvoiceAsPaid(String invoiceId) async {
  final result = await _gqlClient.mutate(
    MutationOptions(
      document: gql(GraphQLQueries.markInvoiceAsPaid),
      variables: {'id': invoiceId},
    ),
  );
  // Handle result
}

// 3. Add to InvoiceRepository
Future<void> markAsPaid(String invoiceId) async {
  await _apiService.markInvoiceAsPaid(invoiceId);
}

// 4. Add to InvoiceProvider
Future<void> markInvoiceAsPaid(String invoiceId) async {
  await _repository.markAsPaid(invoiceId);
  await fetchInvoices(); // Refresh list
}

// 5. Use in UI
ElevatedButton(
  onPressed: () async {
    await ref.read(invoiceProvider.notifier)
        .markInvoiceAsPaid(invoice.id);
  },
  child: Text('Mark as Paid'),
)
```

---

**Last Updated:** January 23, 2026
