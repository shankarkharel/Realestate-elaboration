

### Database Schema Design

---

#### **1. `buyers` Table**
Stores information about buyers.

| Column     | Data Type     | Constraints             | Description          |
|------------|---------------|-------------------------|----------------------|
| buyer_id   | UUID          | PRIMARY KEY             | Unique identifier for each buyer |
| name       | VARCHAR(100)  | NOT NULL                | Buyer's name |
| email      | VARCHAR(100)  | NOT NULL, UNIQUE        | Buyer's email address |
| phone      | VARCHAR(15)   |                         | Buyer's phone number |

---

#### **2. `sellers` Table**
Stores information about sellers.

| Column     | Data Type     | Constraints             | Description          |
|------------|---------------|-------------------------|----------------------|
| seller_id  | UUID          | PRIMARY KEY             | Unique identifier for each seller |
| name       | VARCHAR(100)  | NOT NULL                | Seller's name |
| email      | VARCHAR(100)  | NOT NULL, UNIQUE        | Seller's email address |
| phone      | VARCHAR(15)   |                         | Seller's phone number |

---

#### **3. `admins` Table**
Stores information about admins.

| Column     | Data Type     | Constraints             | Description          |
|------------|---------------|-------------------------|----------------------|
| admin_id   | UUID          | PRIMARY KEY             | Unique identifier for each admin |
| name       | VARCHAR(100)  | NOT NULL                | Admin's name |
| email      | VARCHAR(100)  | NOT NULL, UNIQUE        | Admin's email address |

---

#### **4. `properties` Table**
Stores information about properties listed by sellers.

| Column       | Data Type     | Constraints             | Description           |
|--------------|---------------|-------------------------|-----------------------|
| property_id  | UUID          | PRIMARY KEY             | Unique identifier for each property |
| address      | TEXT          | NOT NULL                | Property address |
| price        | DECIMAL(15, 2)| NOT NULL                | Property price |
| status       | VARCHAR(50)   | NOT NULL                | Status (e.g., "available", "sold") |
| seller_id    | UUID          | FOREIGN KEY REFERENCES sellers(seller_id) | ID of the seller who owns the property |

---

#### **5. `inquiries` Table**
Stores inquiries made by buyers on properties.

| Column       | Data Type     | Constraints             | Description           |
|--------------|---------------|-------------------------|-----------------------|
| inquiry_id   | UUID          | PRIMARY KEY             | Unique identifier for each inquiry |
| property_id  | UUID          | FOREIGN KEY REFERENCES properties(property_id) | ID of the property being inquired about |
| buyer_id     | UUID          | FOREIGN KEY REFERENCES buyers(buyer_id) | ID of the buyer making the inquiry |
| message      | TEXT          | NOT NULL                | Inquiry message from the buyer |
| date         | DATE          | NOT NULL                | Date of the inquiry |
| status       | VARCHAR(50)   |                         | Status of the inquiry (e.g., "open", "closed") |

---

#### **6. `offers` Table**
Stores offers made by buyers on properties.

| Column       | Data Type     | Constraints             | Description           |
|--------------|---------------|-------------------------|-----------------------|
| offer_id     | UUID          | PRIMARY KEY             | Unique identifier for each offer |
| property_id  | UUID          | FOREIGN KEY REFERENCES properties(property_id) | ID of the property being offered on |
| buyer_id     | UUID          | FOREIGN KEY REFERENCES buyers(buyer_id) | ID of the buyer making the offer |
| offer_amount | DECIMAL(15, 2)| NOT NULL                | Offer amount proposed by the buyer |
| status       | VARCHAR(50)   |                         | Status of the offer (e.g., "pending", "accepted", "rejected") |
| date         | DATE          | NOT NULL                | Date of the offer |

---

#### **7. `visit_requests` Table**
Stores visit requests from buyers to sellers.

| Column       | Data Type     | Constraints             | Description           |
|--------------|---------------|-------------------------|-----------------------|
| visit_id     | UUID          | PRIMARY KEY             | Unique identifier for each visit request |
| property_id  | UUID          | FOREIGN KEY REFERENCES properties(property_id) | ID of the property being visited |
| buyer_id     | UUID          | FOREIGN KEY REFERENCES buyers(buyer_id) | ID of the buyer requesting the visit |
| seller_id    | UUID          | FOREIGN KEY REFERENCES sellers(seller_id) | ID of the seller for the property |
| date         | DATE          | NOT NULL                | Date requested for the visit |
| status       | VARCHAR(50)   |                         | Status of the visit request (e.g., "pending", "confirmed") |

---

#### **8. `chat_channels` Table**
Stores one-to-one chat channels between buyers and sellers for each property.

| Column       | Data Type     | Constraints             | Description           |
|--------------|---------------|-------------------------|-----------------------|
| channel_id   | UUID          | PRIMARY KEY             | Unique identifier for each chat channel |
| property_id  | UUID          | FOREIGN KEY REFERENCES properties(property_id) | ID of the property associated with the chat |
| buyer_id     | UUID          | FOREIGN KEY REFERENCES buyers(buyer_id) | ID of the buyer in the chat |
| seller_id    | UUID          | FOREIGN KEY REFERENCES sellers(seller_id) | ID of the seller in the chat |
| creation_date| TIMESTAMP     | NOT NULL                | Date and time the chat channel was created |

---

#### **9. `messages` Table**
Stores individual messages exchanged within each chat channel.

| Column       | Data Type     | Constraints             | Description           |
|--------------|---------------|-------------------------|-----------------------|
| message_id   | UUID          | PRIMARY KEY             | Unique identifier for each message |
| channel_id   | UUID          | FOREIGN KEY REFERENCES chat_channels(channel_id) | ID of the chat channel the message belongs to |
| sender_id    | UUID          | NOT NULL                | ID of the sender (can be buyer_id or seller_id) |
| receiver_id  | UUID          | NOT NULL                | ID of the receiver (can be buyer_id or seller_id) |
| content      | TEXT          | NOT NULL                | Message content |
| timestamp    | TIMESTAMP     | NOT NULL                | Date and time the message was sent |

---

#### **10. `property_details` Table**
Stores additional details about each property.

| Column       | Data Type     | Constraints             | Description           |
|--------------|---------------|-------------------------|-----------------------|
| details_id   | UUID          | PRIMARY KEY             | Unique identifier for each set of property details |
| property_id  | UUID          | FOREIGN KEY REFERENCES properties(property_id) | ID of the property the details belong to |
| area         | INT           |                         | Area of the property in square feet |
| num_bedrooms | INT           |                         | Number of bedrooms in the property |
| num_bathrooms| INT           |                         | Number of bathrooms in the property |
| description  | TEXT          |                         | Description of the property |
| amenities    | TEXT          |                         | Amenities available at the property (e.g., "Pool, Gym") |

---

#### **11. `search_history` Table**
Stores the search history for each buyer.

| Column       | Data Type     | Constraints             | Description           |
|--------------|---------------|-------------------------|-----------------------|
| search_id    | UUID          | PRIMARY KEY             | Unique identifier for each search |
| buyer_id     | UUID          | FOREIGN KEY REFERENCES buyers(buyer_id) | ID of the buyer who performed the search |
| search_terms | TEXT          |                         | Search terms used by the buyer |
| filters      | TEXT          |                         | Applied filters in JSON format |
| timestamp    | TIMESTAMP     | NOT NULL                | Date and time the search was performed |

---

#### **12. `filter_criteria` Table**
Stores predefined filter criteria for properties.

| Column       | Data Type     | Constraints             | Description           |
|--------------|---------------|-------------------------|-----------------------|
| filter_id    | UUID          | PRIMARY KEY             | Unique identifier for each filter criterion |
| price_range  | VARCHAR(50)   |                         | Price range filter (e.g., "$200,000-$300,000") |
| location     | VARCHAR(100)  |                         | Location filter (e.g., "New York, NY") |
| num_bedrooms | INT           |                         | Minimum number of bedrooms |
| num_bathrooms| INT           |                         | Minimum number of bathrooms |
| amenities    | TEXT          |                         | Amenities filter (e.g., "Pool, Gym") |

---

### Notes

- **UUIDs** are used for primary keys to uniquely identify records and avoid collisions.
- **Foreign keys** are defined to maintain relationships between tables.
- **Status fields** are used in tables like `inquiries`, `offers`, and `visit_requests` to indicate the current state of each record (e.g., "pending", "confirmed").
- **JSON or text fields** for `filters` in `search_history` allow for flexible storage of filter criteria.

