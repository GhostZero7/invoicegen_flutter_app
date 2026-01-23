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
        client {
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
}
