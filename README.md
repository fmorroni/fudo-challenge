# Products CRUD API (Ruby + Rack)

This project was built for the **Fudo Challenge**.

## 📦 Installation

### Requirements
- **Ruby** `3.4.7`
- **Bundler** (`gem install bundler`)

### Setup
1. Clone this repository:
   ```bash
   git clone <repo-url>
   cd <repo-folder>
   ```

2. Install dependencies:
   ```bash
   bundle install
   ```

3. Create a `.env` file in the project root with:
   ```bash
   JWT_SECRET=your_jwt_secret_here
   EXTERNAL_API=https://23f0013223494503b54c61e8bee1190c.api.mockbin.io/
   ```

---

## ▶️ Running the Server

### With Ruby (directly)
```bash
bundle exec puma
```

Server will start on **http://localhost:9292** by default.

### With Docker
Build the image:
```bash
docker build -t <image-name> .
```

Run the container:
```bash
docker run -p 9292:9292   -e JWT_SECRET=<some-secret>   -e EXTERNAL_API=https://23f0013223494503b54c61e8bee1190c.api.mockbin.io/   <image-name>
```

---

## 🔐 Authentication Endpoints

### `POST /auth/register`
Register a new user.  
**Body (form-data):**
```
username=<string>
password=<string>
```

**Response:**
```json
{ "username": "<username>" }
```

**CURL example**
```sh
curl --location --request POST 'http://localhost:9292/auth/register?' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'username=Franco' \
--data-urlencode 'password=Asdf_1234' 
```

---

### `POST /auth/login`
Login with existing credentials.  
**Body (form-data):**
```
username=<string>
password=<string>
```

**Response:**
```json
{ "access_token": "<jwt-access-token>" }
```

Use this token in the `Authorization` header for all `/products` endpoints:
```
Authorization: Bearer <token>
```

**CURL example**
```sh
curl --location --request POST 'http://localhost:9292/auth/login?' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'username=Franco' \
--data-urlencode 'password=Asdf_1234' 
```

---

## 🛍️ Product Endpoints

### `POST /products`
Create a product **asynchronously**.

**Headers:**
```
Authorization: Bearer <token>
Content-Type: application/x-www-form-urlencoded
```

**Body:**
```
name=<string>
```

**Response:**
```json
{ "message": "The product is being created" }
```

**CURL example**
```sh
curl --location --request POST 'http://localhost:9292/products?' \
--header 'Authorization: Bearer <token>' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=Cake' 
```

> Product creation simulates a 5-second asynchronous delay before persistence.

---

### `GET /products`
Fetch paginated list of products.

**Headers:**
```
Authorization: Bearer <token>
```

**Query Params:**
- `offset` (optional, default: 0)
- `limit` (optional, default: 10, max: 100)

**Response:**
```json
{
  "offset": 0,
  "limit": 2,
  "products": [
    {
      "id": 1,
      "name": "Apple"
    },
    {
      "id": 2,
      "name": "Banana"
    }
  ],
  "total": 3
}
```

**CURL example**
```sh
curl --location --request GET 'http://localhost:9292/products?offset=0&limit=2' \
--header 'Authorization: Bearer <token>' \
```

---

## ⚙️ Environment Variables

| Variable       | Description                                    |
|----------------|------------------------------------------------|
| `JWT_SECRET`   | Secret key used to sign and verify JWT tokens. |
| `EXTERNAL_API` | URL of the external products API.              |
