// lib/data/datasources/remote/graphql_queries.dart

class GraphQLQueries {
  // --- USER QUERIES ---
  static const String me = r'''
    query GetMe {
      me {
        id
        email
        first_name: firstName
        last_name: lastName
        phone
        role
        status
        created_at: createdAt
        updated_at: updatedAt
      }
    }
  ''';

  // --- CLIENT QUERIES ---
  static const String getClients = r'''
    query GetClients($businessId: ID, $skip: Int, $limit: Int) {
      clients(businessId: $businessId, skip: $skip, limit: $limit) {
        id
        business_id: businessId
        client_type: clientType
        company_name: companyName
        first_name: firstName
        last_name: lastName
        email
        phone
        mobile
        website
        tax_id: taxId
        vat_number: vatNumber
        payment_terms: paymentTerms
        credit_limit: creditLimit
        currency
        language
        notes
        status
        created_at: createdAt
        updated_at: updatedAt
      }
    }
  ''';

  // --- PRODUCT QUERIES ---
  static const String getProducts = r'''
    query GetProducts($filter: ProductFilterInput, $skip: Int, $limit: Int) {
      products(filter: $filter, skip: $skip, limit: $limit) {
        id
        business_id: businessId
        sku
        product_name: name
        description
        price: unitPrice
        cost_price: costPrice
        unit: unitOfMeasure
        tax_rate: taxRate
        is_taxable: isTaxable
        track_inventory: trackInventory
        quantity: quantityInStock
        low_stock_threshold: lowStockThreshold
        image_url: imageUrl
        is_active: isActive
        created_at: createdAt
        updated_at: updatedAt
      }
    }
  ''';

  // --- INVOICE QUERIES ---
  static const String getInvoices = r'''
    query GetInvoices($businessId: ID, $clientId: ID, $status: InvoiceStatus, $skip: Int, $limit: Int) {
      invoices(businessId: $businessId, clientId: $clientId, status: $status, skip: $skip, limit: $limit) {
        id
        business_id: businessId
        client_id: clientId
        invoice_number: invoiceNumber
        status
        invoice_date: invoiceDate
        due_date: dueDate
        subtotal
        tax_amount: taxAmount
        discount_amount: discountAmount
        total_amount: totalAmount
        amount_paid: amountPaid
        amount_due: amountDue
        currency
        notes
        payment_terms: paymentTerms
        created_at: createdAt
        updated_at: updatedAt
      }
    }
  ''';

  // --- MUTATIONS ---
  static const String createClient = r'''
    mutation CreateClient($input: CreateClientInput!) {
      createClient(input: $input) {
        id
        business_id: businessId
        client_type: clientType
        email
        company_name: companyName
        first_name: firstName
        last_name: lastName
        status
        created_at: createdAt
        updated_at: updatedAt
      }
    }
  ''';

  static const String createProduct = r'''
    mutation CreateProduct($input: CreateProductInput!) {
      createProduct(input: $input) {
        id
        business_id: businessId
        product_name: name
        price: unitPrice
        status: isActive
        created_at: createdAt
        updated_at: updatedAt
      }
    }
  ''';

  static const String createInvoice = r'''
    mutation CreateInvoice($input: CreateInvoiceInput!) {
      createInvoice(input: $input) {
        id
        business_id: businessId
        client_id: clientId
        invoice_number: invoiceNumber
        total_amount: totalAmount
        status
        created_at: createdAt
        updated_at: updatedAt
      }
    }
  ''';
}
