# Business Profile Testing Guide

## ✅ What We've Completed

### Backend
- ✅ GraphQL business profile endpoints (queries & mutations)
- ✅ Business profile types and schemas
- ✅ Removed REST endpoints (converted to GraphQL)
- ✅ Server running on `http://192.168.0.250:8080`

### Frontend
- ✅ Updated GraphQL queries for business profiles
- ✅ API service converted to use GraphQL
- ✅ Business provider and repository ready
- ✅ Business profile screens exist and compile
- ✅ Dashboard shows business profile with clickable link
- ✅ Profile screen has business profile access

## 🧪 Testing Steps

### 1. Test Backend Connection
The Flutter app should now connect to the backend successfully since the server is running.

### 2. Test Business Profile Access
**From Dashboard:**
1. Open the Flutter app
2. Look at the dashboard header
3. You should see either:
   - Current business name (clickable, blue with underline)
   - "Create business profile" (clickable, orange with underline)
4. Tap on it to open Business Profile screen

**From Profile Screen:**
1. Navigate to Profile tab
2. Look for business profile option
3. Tap to access business profiles

### 3. Test Business Profile CRUD Operations

#### Create Business Profile
1. Go to Business Profile screen
2. Tap "+" or "Create Business" button
3. Fill out the form:
   - Business Name: "Test Business"
   - Business Type: Select from dropdown
   - Email: Valid email
   - Currency: Select currency
   - Other optional fields
4. Save and verify it appears in the list

#### View Business Profiles
1. Should see list of business profiles
2. Each card should show:
   - Business name
   - Business type
   - Email
   - Status (Active/Inactive)

#### Edit Business Profile
1. Tap on a business profile card
2. Should open edit screen
3. Modify some fields
4. Save and verify changes

#### Delete Business Profile
1. Long press or swipe on business profile
2. Confirm deletion
3. Verify it's removed from list

### 4. Test Business Selection
1. Create multiple business profiles
2. Select different businesses
3. Verify dashboard header updates
4. Check that selected business is used in invoice creation

## 🔍 What to Look For

### Success Indicators
- ✅ No connection timeout errors
- ✅ Business profiles load from GraphQL
- ✅ CRUD operations work smoothly
- ✅ Dashboard shows selected business
- ✅ Smooth navigation between screens
- ✅ Form validation works properly

### Potential Issues
- ❌ GraphQL query errors
- ❌ Field mapping issues (snake_case vs camelCase)
- ❌ Form validation errors
- ❌ Navigation issues
- ❌ State management problems

## 🐛 Troubleshooting

### If Business Profiles Don't Load
1. Check Flutter console for GraphQL errors
2. Verify backend GraphQL endpoint: `http://192.168.0.250:8080/graphql`
3. Test GraphQL query manually in GraphiQL interface
4. Check authentication token

### If Create/Edit Forms Don't Work
1. Check form validation
2. Verify field mappings in GraphQL mutations
3. Check business model field names
4. Look for type conversion errors

### If Navigation Doesn't Work
1. Check import statements
2. Verify route definitions
3. Check for context issues

## 🎯 Next Steps After Testing

Once business profiles are working:

### Phase 1B: Enhanced Client Management
1. Client detail screen
2. Client edit functionality
3. Client search and filtering
4. Client invoice history

### Phase 1C: Product Catalog
1. Product list screen
2. Product CRUD operations
3. Product categories
4. Product selection in invoices

## 📝 Test Results

**Date:** _____
**Tester:** _____

### Business Profile Access
- [ ] Dashboard business link works
- [ ] Profile screen access works
- [ ] Business list screen loads

### CRUD Operations
- [ ] Create business profile works
- [ ] View business profiles works
- [ ] Edit business profile works
- [ ] Delete business profile works

### Business Selection
- [ ] Multiple businesses can be created
- [ ] Business selection works
- [ ] Dashboard updates with selected business

### Issues Found
1. _____
2. _____
3. _____

### Overall Status
- [ ] ✅ All tests passed - Ready for next phase
- [ ] ⚠️ Minor issues - Needs fixes
- [ ] ❌ Major issues - Needs debugging

---

**Note:** Make sure the backend server is running before testing!