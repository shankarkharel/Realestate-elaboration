-- 1. Buyers Table
CREATE TABLE buyers (
    buyer_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15)
);

-- 2. Sellers Table
CREATE TABLE sellers (
    seller_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15)
);

-- 3. Admins Table
CREATE TABLE admins (
    admin_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

-- 4. Properties Table
CREATE TABLE properties (
    property_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    address TEXT NOT NULL,
    price DECIMAL(15, 2) NOT NULL,
    status VARCHAR(50) NOT NULL,
    seller_id UUID NOT NULL REFERENCES sellers(seller_id) ON DELETE CASCADE
);

-- 5. Inquiries Table
CREATE TABLE inquiries (
    inquiry_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    property_id UUID NOT NULL REFERENCES properties(property_id) ON DELETE CASCADE,
    buyer_id UUID NOT NULL REFERENCES buyers(buyer_id) ON DELETE CASCADE,
    message TEXT NOT NULL,
    date DATE NOT NULL,
    status VARCHAR(50) DEFAULT 'open'
);

-- 6. Offers Table
CREATE TABLE offers (
    offer_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    property_id UUID NOT NULL REFERENCES properties(property_id) ON DELETE CASCADE,
    buyer_id UUID NOT NULL REFERENCES buyers(buyer_id) ON DELETE CASCADE,
    offer_amount DECIMAL(15, 2) NOT NULL,
    status VARCHAR(50) DEFAULT 'pending',
    date DATE NOT NULL
);

-- 7. Visit Requests Table
CREATE TABLE visit_requests (
    visit_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    property_id UUID NOT NULL REFERENCES properties(property_id) ON DELETE CASCADE,
    buyer_id UUID NOT NULL REFERENCES buyers(buyer_id) ON DELETE CASCADE,
    seller_id UUID NOT NULL REFERENCES sellers(seller_id) ON DELETE CASCADE,
    date DATE NOT NULL,
    status VARCHAR(50) DEFAULT 'pending'
);

-- 8. Chat Channels Table
CREATE TABLE chat_channels (
    channel_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    property_id UUID NOT NULL REFERENCES properties(property_id) ON DELETE CASCADE,
    buyer_id UUID NOT NULL REFERENCES buyers(buyer_id) ON DELETE CASCADE,
    seller_id UUID NOT NULL REFERENCES sellers(seller_id) ON DELETE CASCADE,
    creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 9. Messages Table
CREATE TABLE messages (
    message_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    channel_id UUID NOT NULL REFERENCES chat_channels(channel_id) ON DELETE CASCADE,
    sender_id UUID NOT NULL,
    receiver_id UUID NOT NULL,
    content TEXT NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 10. Property Details Table
CREATE TABLE property_details (
    details_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    property_id UUID NOT NULL UNIQUE REFERENCES properties(property_id) ON DELETE CASCADE,
    area INT,
    num_bedrooms INT,
    num_bathrooms INT,
    description TEXT,
    amenities TEXT
);

-- 11. Search History Table
CREATE TABLE search_history (
    search_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    buyer_id UUID NOT NULL REFERENCES buyers(buyer_id) ON DELETE CASCADE,
    search_terms TEXT,
    filters JSONB,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 12. Filter Criteria Table
CREATE TABLE filter_criteria (
    filter_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    price_range VARCHAR(50),
    location VARCHAR(100),
    num_bedrooms INT,
    num_bathrooms INT,
    amenities TEXT
);
