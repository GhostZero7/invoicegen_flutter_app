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

  // --- BUSINESS QUERIES ---
  static const String getMyBusinesses = r'''
    query GetMyBusinesses {
      myBusinesses {
        id
        user_id: userId
        business_name: businessName
        business_type: businessType
        tax_id: taxId
        vat_number: vatNumber
        registration_number: registrationNumber
        website
        phone
        email
        logo_url: logoUrl
        currency
        timezone
        invoice_prefix: invoicePrefix
        quote_prefix: quotePrefix
        next_invoice_number: nextInvoiceNumber
        next_quote_number: nextQuoteNumber
        payment_terms_default: paymentTermsDefault
        notes_default: notesDefault
        payment_instructions: paymentInstructions
        is_active: isActive
        created_at: createdAt
        updated_at: updatedAt
      }
    }
  ''';

  static const String getBusiness = r'''
    query GetBusiness($id: ID!) {
      business(id: $id) {
        id
        user_id: userId
        business_name: businessName
        business_type: businessType
        tax_id: taxId
        vat_number: vatNumber
        registration_number: registrationNumber
        website
        phone
        email
        logo_url: logoUrl
        currency
        timezone
        invoice_prefix: invoicePrefix
        quote_prefix: quotePrefix
        next_invoice_number: nextInvoiceNumber
        next_quote_number: nextQuoteNumber
        payment_terms_default: paymentTermsDefault
        notes_default: notesDefault
        payment_instructions: paymentInstructions
        is_active: isActive
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
  static const String createBusiness = r'''
    mutation CreateBusiness($input: CreateBusinessInput!) {
      createBusiness(input: $input) {
        id
        user_id: userId
        business_name: businessName
        business_type: businessType
        tax_id: taxId
        vat_number: vatNumber
        registration_number: registrationNumber
        website
        phone
        email
        logo_url: logoUrl
        currency
        timezone
        invoice_prefix: invoicePrefix
        quote_prefix: quotePrefix
        next_invoice_number: nextInvoiceNumber
        next_quote_number: nextQuoteNumber
        payment_terms_default: paymentTermsDefault
        notes_default: notesDefault
        payment_instructions: paymentInstructions
        is_active: isActive
        created_at: createdAt
        updated_at: updatedAt
      }
    }
  ''';

  static const String updateBusiness = r'''
    mutation UpdateBusiness($id: ID!, $input: UpdateBusinessInput!) {
      updateBusiness(id: $id, input: $input) {
        id
        user_id: userId
        business_name: businessName
        business_type: businessType
        tax_id: taxId
        vat_number: vatNumber
        registration_number: registrationNumber
        website
        phone
        email
        logo_url: logoUrl
        currency
        timezone
        invoice_prefix: invoicePrefix
        quote_prefix: quotePrefix
        next_invoice_number: nextInvoiceNumber
        next_quote_number: nextQuoteNumber
        payment_terms_default: paymentTermsDefault
        notes_default: notesDefault
        payment_instructions: paymentInstructions
        is_active: isActive
        created_at: createdAt
        updated_at: updatedAt
      }
    }
  ''';

  static const String deleteBusiness = r'''
    mutation DeleteBusiness($id: ID!) {
      deleteBusiness(id: $id)
    }
  ''';

  static const String createClient = r'''
    mutation CreateClient($input: CreateClientInput!) {
      createClient(input: $input) {
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
        reference_number: referenceNumber
        purchase_order_number: purchaseOrderNumber
        status
        invoice_date: invoiceDate
        due_date: dueDate
        payment_terms: paymentTerms
        subtotal
        tax_amount: taxAmount
        discount_value: discountValue
        discount_type: discountType
        discount_amount: discountAmount
        shipping_amount: shippingAmount
        total_amount: totalAmount
        amount_paid: amountPaid
        amount_due: amountDue
        currency
        notes
        payment_instructions: paymentInstructions
        footer_text: footerText
        is_recurring: isRecurring
        sent_at: sentAt
        viewed_at: viewedAt
        paid_at: paidAt
        cancelled_at: cancelledAt
        created_at: createdAt
        updated_at: updatedAt
      }
    }
  ''';

  static const String updateClient = r'''
    mutation UpdateClient($id: ID!, $input: UpdateClientInput!) {
      updateClient(id: $id, input: $input) {
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

  static const String deleteClient = r'''
    mutation DeleteClient($id: ID!) {
      deleteClient(id: $id) {
        success
        message
      }
    }
  ''';

  static const String getInvoicesForClient = r'''
    query GetInvoicesForClient($clientId: ID!, $skip: Int, $limit: Int) {
      invoices(clientId: $clientId, skip: $skip, limit: $limit) {
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

  // Get single invoice with full details
  static const String getInvoice = r'''
    query GetInvoice($id: ID!) {
      invoice(id: $id) {
        id
        business_id: businessId
        client_id: clientId
        invoice_number: invoiceNumber
        reference_number: referenceNumber
        purchase_order_number: purchaseOrderNumber
        status
        invoice_date: invoiceDate
        due_date: dueDate
        payment_terms: paymentTerms
        subtotal
        tax_amount: taxAmount
        discount_value: discountValue
        discount_type: discountType
        discount_amount: discountAmount
        shipping_amount: shippingAmount
        total_amount: totalAmount
        amount_paid: amountPaid
        amount_due: amountDue
        currency
        notes
        payment_instructions: paymentInstructions
        footer_text: footerText
        is_recurring: isRecurring
        sent_at: sentAt
        viewed_at: viewedAt
        paid_at: paidAt
        cancelled_at: cancelledAt
        created_at: createdAt
        updated_at: updatedAt
      }
    }
  ''';

  // Get invoice items
  static const String getInvoiceItems = r'''
    query GetInvoiceItems($invoiceId: ID!) {
      invoiceItems(invoiceId: $invoiceId) {
        id
        invoice_id: invoiceId
        product_id: productId
        description
        quantity
        unit_price: unitPrice
        unit_of_measure: unitOfMeasure
        tax_rate: taxRate
        tax_amount: taxAmount
        discount_type: discountType
        discount_value: discountValue
        discount_amount: discountAmount
        line_total: lineTotal
        sort_order: sortOrder
      }
    }
  ''';

  // Update invoice
  static const String updateInvoice = r'''
    mutation UpdateInvoice($id: ID!, $input: UpdateInvoiceInput!) {
      updateInvoice(id: $id, input: $input) {
        id
        invoice_number: invoiceNumber
        status
        notes
        updated_at: updatedAt
      }
    }
  ''';

  // Delete invoice
  static const String deleteInvoice = r'''
    mutation DeleteInvoice($id: ID!) {
      deleteInvoice(id: $id)
    }
  ''';

  // Send invoice
  static const String sendInvoice = r'''
    mutation SendInvoice($id: ID!) {
      sendInvoice(id: $id)
    }
  ''';

  // Mark invoice as paid
  static const String markInvoiceAsPaid = r'''
    mutation MarkInvoiceAsPaid($id: ID!) {
      markInvoiceAsPaid(id: $id)
    }
  ''';

  // Cancel invoice
  static const String cancelInvoice = r'''
    mutation CancelInvoice($id: ID!) {
      cancelInvoice(id: $id)
    }
  ''';

  // --- PAYMENT QUERIES ---
  
  // Get payments
  static const String getPayments = r'''
    query GetPayments($invoiceId: ID, $status: PaymentStatus, $skip: Int, $limit: Int) {
      payments(invoiceId: $invoiceId, status: $status, skip: $skip, limit: $limit) {
        id
        invoice_id: invoiceId
        payment_number: paymentNumber
        payment_date: paymentDate
        amount
        payment_method: paymentMethod
        transaction_id: transactionId
        reference_number: referenceNumber
        notes
        status
        created_at: createdAt
        updated_at: updatedAt
      }
    }
  ''';

  // Get single payment
  static const String getPayment = r'''
    query GetPayment($id: ID!) {
      payment(id: $id) {
        id
        invoice_id: invoiceId
        payment_number: paymentNumber
        payment_date: paymentDate
        amount
        payment_method: paymentMethod
        transaction_id: transactionId
        reference_number: referenceNumber
        notes
        status
        created_at: createdAt
        updated_at: updatedAt
      }
    }
  ''';

  // Create payment
  static const String createPayment = r'''
    mutation CreatePayment($input: CreatePaymentInput!) {
      createPayment(input: $input) {
        id
        invoice_id: invoiceId
        payment_number: paymentNumber
        payment_date: paymentDate
        amount
        payment_method: paymentMethod
        transaction_id: transactionId
        reference_number: referenceNumber
        notes
        status
        created_at: createdAt
      }
    }
  ''';

  // Update payment
  static const String updatePayment = r'''
    mutation UpdatePayment($id: ID!, $input: UpdatePaymentInput!) {
      updatePayment(id: $id, input: $input) {
        id
        amount
        notes
        updated_at: updatedAt
      }
    }
  ''';

  // Refund payment
  static const String refundPayment = r'''
    mutation RefundPayment($id: ID!) {
      refundPayment(id: $id)
    }
  ''';

  // Delete payment
  static const String deletePayment = r'''
    mutation DeletePayment($id: ID!) {
      deletePayment(id: $id)
    }
  ''';

  // --- PRODUCT QUERIES ---

  // Get single product
  static const String getProduct = r'''
    query GetProduct($id: ID!) {
      product(id: $id) {
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

  // Update product
  static const String updateProduct = r'''
    mutation UpdateProduct($id: ID!, $input: UpdateProductInput!) {
      updateProduct(id: $id, input: $input) {
        id
        product_name: name
        price: unitPrice
        updated_at: updatedAt
      }
    }
  ''';

  // Delete product
  static const String deleteProduct = r'''
    mutation DeleteProduct($id: ID!) {
      deleteProduct(id: $id)
    }
  ''';

  // --- CLIENT QUERIES ---

  // Get single client
  static const String getClient = r'''
    query GetClient($id: ID!) {
      client(id: $id) {
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
}
