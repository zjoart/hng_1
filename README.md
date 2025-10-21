# hng_1


## Features
This RESTful API service analyzes strings and stores their computed properties. It provides the following endpoints:

1. **POST /strings**: Analyze and store string properties.
2. **GET /strings/{string_value}**: Retrieve properties of a specific string.
3. **GET /strings**: Retrieve all strings with optional filtering.
4. **GET /strings/filter-by-natural-language**: Retrieve strings based on natural language queries.
5. **DELETE /strings/{string_value}**: Delete a specific string.

## Setup Instructions

### Prerequisites
- Dart SDK (>=3.0.0 <4.0.0)
- Dart Frog CLI

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/zjoart/hng_1.git
   ```
2. Navigate to the project directory:
   ```bash
   cd hng_1
   ```
3. Install dependencies:
   ```bash
   dart pub get
   ```

### Running the Application
Start the Dart Frog development server:
```bash
dart_frog dev
```

The server will start at `http://localhost:8080` by default.

## Make / local builds

Builds and release tasks can also be run locally via Make targets. For a list of available Make commands run:

```sh
make help
```

## API Documentation

### 1. Create/Analyze String
**POST /strings**
- **Request Body:**
  ```json
  {
    "value": "string to analyze"
  }
  ```
- **Success Response (201 Created):**
  ```json
  {
    "id": "sha256_hash_value",
    "value": "string to analyze",
    "properties": {
      "length": 17,
      "is_palindrome": false,
      "unique_characters": 12,
      "word_count": 3,
      "sha256_hash": "abc123...",
      "character_frequency_map": {
        "s": 2,
        "t": 3,
        "r": 2
      }
    },
    "created_at": "2025-08-27T10:00:00Z"
  }
  ```
- **Error Responses:**
  - 409 Conflict: String already exists in the system
  - 400 Bad Request: Invalid request body or missing "value" field
  - 422 Unprocessable Entity: Invalid data type for "value" (must be string)

### 2. Get Specific String
**GET /strings/{string_value}**
- **Success Response (200 OK):**
  ```json
  {
    "id": "sha256_hash_value",
    "value": "requested string",
    "properties": { /* same as above */ },
    "created_at": "2025-08-27T10:00:00Z"
  }
  ```
- **Error Responses:**
  - 404 Not Found: String does not exist in the system

### 3. Get All Strings with Filtering
**GET /strings**
- **Query Parameters:**
  - `is_palindrome`: boolean (true/false)
  - `min_length`: integer (minimum string length)
  - `max_length`: integer (maximum string length)
  - `word_count`: integer (exact word count)
  - `contains_character`: string (single character to search for)
- **Success Response (200 OK):**
  ```json
  {
    "data": [
      {
        "id": "hash1",
        "value": "string1",
        "properties": { /* ... */ },
        "created_at": "2025-08-27T10:00:00Z"
      }
    ],
    "count": 15,
    "filters_applied": {
      "is_palindrome": true,
      "min_length": 5,
      "max_length": 20,
      "word_count": 2,
      "contains_character": "a"
    }
  }
  ```
- **Error Response:**
  - 400 Bad Request: Invalid query parameter values or types

### 4. Natural Language Filtering
**GET /strings/filter-by-natural-language**
- **Query Parameter:**
  - `query`: Natural language query string
- **Success Response (200 OK):**
  ```json
  {
    "data": [ /* array of matching strings */ ],
    "count": 3,
    "interpreted_query": {
      "original": "all single word palindromic strings",
      "parsed_filters": {
        "word_count": 1,
        "is_palindrome": true
      }
    }
  }
  ```
- **Error Responses:**
  - 400 Bad Request: Unable to parse natural language query
  - 422 Unprocessable Entity: Query parsed but resulted in conflicting filters

### 5. Delete String
**DELETE /strings/{string_value}**
- **Success Response (204 No Content):** (Empty response body)
- **Error Responses:**
  - 404 Not Found: String does not exist in the system

