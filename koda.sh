#!/bin/bash
# ============================================================
# Koda — B2B Marketplace
# Run this script to scaffold the entire project from scratch.
# Usage: bash install_koda.sh
# ============================================================
set -e

PROJECT="koda"
echo ""
echo "  ██╗  ██╗ ██████╗ ██████╗  █████╗ "
echo "  ██║ ██╔╝██╔═══██╗██╔══██╗██╔══██╗"
echo "  █████╔╝ ██║   ██║██║  ██║███████║"
echo "  ██╔═██╗ ██║   ██║██║  ██║██╔══██║"
echo "  ██║  ██╗╚██████╔╝██████╔╝██║  ██║"
echo "  ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝"
echo ""
echo "  Creating Koda project files..."
echo ""

mkdir -p "$PROJECT"
cd "$PROJECT"


# --- .env.example ---
mkdir -p "."
cat > ".env.example" << 'KODA_FILE_23C9246C'
APP_NAME=Koda
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_URL=http://localhost:8000
APP_TIMEZONE=Africa/Nairobi

APP_LOCALE=en
APP_FALLBACK_LOCALE=en
APP_FAKER_LOCALE=en_US

LOG_CHANNEL=stack
LOG_STACK=single
LOG_DEPRECATIONS_CHANNEL=null
LOG_LEVEL=debug

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=koda
DB_USERNAME=root
DB_PASSWORD=

SESSION_DRIVER=database
SESSION_LIFETIME=120
SESSION_ENCRYPT=false
SESSION_PATH=/
SESSION_DOMAIN=null

BROADCAST_CONNECTION=log
FILESYSTEM_DISK=local
QUEUE_CONNECTION=database

CACHE_STORE=database
CACHE_PREFIX=

MAIL_MAILER=log
MAIL_HOST=127.0.0.1
MAIL_PORT=2525
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM_ADDRESS="hello@koda.com"
MAIL_FROM_NAME="${APP_NAME}"

# Stripe
STRIPE_KEY=your_stripe_publishable_key
STRIPE_SECRET=your_stripe_secret_key
STRIPE_WEBHOOK_SECRET=your_webhook_secret

# Flutterwave
FLUTTERWAVE_PUBLIC_KEY=
FLUTTERWAVE_SECRET_KEY=
FLUTTERWAVE_ENCRYPTION_KEY=

VITE_APP_NAME="${APP_NAME}"
VITE_STRIPE_KEY="${STRIPE_KEY}"

KODA_FILE_23C9246C

# --- README.md ---
mkdir -p "."
cat > "README.md" << 'KODA_FILE_AC036608'
# Koda — Your Professional Business Marketplace

> **Stack:** Laravel 13 · Vue 3 · Inertia.js · Tailwind CSS

---

## Quick Start

### Prerequisites
- PHP 8.3+
- Composer 2+
- Node.js 20+
- MySQL 8+ or PostgreSQL 15+

---

### 1. Clone & Install

```bash
git clone https://github.com/your-org/koda.git
cd koda

# PHP dependencies
composer install

# Node dependencies
npm install
```

---

### 2. Environment Setup

```bash
cp .env.example .env
php artisan key:generate
```

Edit `.env` and set your database credentials:
```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=koda
DB_USERNAME=root
DB_PASSWORD=your_password
```

---

### 3. Database Setup

```bash
# Run migrations
php artisan migrate

# Seed with demo data (roles, admin, vendors, categories, products)
php artisan db:seed
```

**Demo Credentials:**
| Role   | Email              | Password |
|--------|--------------------|----------|
| Admin  | admin@koda.com     | password |
| Vendor | vendor@koda.com    | password |
| Buyer  | buyer@koda.com     | password |

---

### 4. Storage Setup

```bash
php artisan storage:link
```

---

### 5. Build Assets

```bash
# Development
npm run dev

# Production
npm run build
```

---

### 6. Start the Server

```bash
php artisan serve
```

Visit: **http://localhost:8000**

---

## Application Structure

```
koda/
├── app/
│   ├── Http/
│   │   ├── Controllers/
│   │   │   ├── HomeController.php
│   │   │   ├── ProductController.php
│   │   │   ├── CartController.php
│   │   │   ├── CheckoutController.php
│   │   │   ├── VendorController.php
│   │   │   ├── WishlistController.php
│   │   │   ├── Admin/
│   │   │   │   ├── DashboardController.php
│   │   │   │   └── VendorController.php
│   │   │   └── Vendor/
│   │   │       ├── DashboardController.php
│   │   │       ├── ProductController.php
│   │   │       └── OrderController.php
│   │   └── Middleware/
│   │       ├── HandleInertiaRequests.php
│   │       └── EnsureVendorIsActive.php
│   └── Models/
│       ├── User.php
│       ├── VendorProfile.php
│       ├── Product.php
│       ├── Category.php
│       ├── Order.php
│       └── ...
├── resources/js/
│   ├── Pages/
│   │   ├── Public/         # Homepage, Products, Cart, Checkout
│   │   ├── Auth/           # Login, Register
│   │   ├── Buyer/          # Orders, Wishlist
│   │   ├── Vendor/         # Dashboard, Products, Orders
│   │   └── Admin/          # Dashboard, Vendors
│   ├── Components/
│   │   ├── UI/             # Reusable UI components
│   │   ├── Shared/         # ProductCard, VendorCard, StatsCard
│   │   └── Layout/
│   └── Layouts/
│       ├── AppLayout.vue   # Public layout with navbar/footer
│       ├── DashboardLayout.vue  # Admin/Vendor sidebar layout
│       └── GuestLayout.vue
└── routes/
    ├── web.php             # All application routes
    └── auth.php            # Auth routes
```

---

## Pages Overview

### Public
| Route | Page | Description |
|-------|------|-------------|
| `/` | Home | Hero, categories, featured products, top vendors |
| `/products` | Products | Filterable product listing |
| `/products/{slug}` | Product Detail | Images, add to cart, reviews |
| `/vendors` | Vendors | Vendor directory |
| `/vendors/{slug}` | Vendor Store | Vendor storefront |
| `/cart` | Cart | Manage cart, apply promo |
| `/checkout` | Checkout | Shipping, payment, review |
| `/vendor/apply` | Vendor Apply | Vendor application form |

### Buyer (authenticated)
| Route | Description |
|-------|-------------|
| `/orders` | Order history |
| `/orders/{id}` | Order detail + tracking |
| `/wishlist` | Saved products |

### Vendor Dashboard
| Route | Description |
|-------|-------------|
| `/vendor/dashboard` | Stats, charts, recent orders |
| `/vendor/products` | Product management |
| `/vendor/orders` | Order fulfilment |
| `/vendor/profile` | Storefront settings |

### Admin Panel
| Route | Description |
|-------|-------------|
| `/admin/dashboard` | Platform overview |
| `/admin/vendors` | Approve/reject vendors |
| `/admin/products` | Product moderation |
| `/admin/orders` | All orders |

---

## Roles & Permissions (Spatie)

| Role   | Access |
|--------|--------|
| admin  | Full platform access |
| vendor | Vendor dashboard + own products/orders |
| buyer  | Orders, wishlist, checkout |

---

## Payments

Configure in `.env`:
```env
# Stripe
STRIPE_KEY=pk_test_...
STRIPE_SECRET=sk_test_...

# Flutterwave
FLUTTERWAVE_PUBLIC_KEY=FLWPUBK_TEST-...
FLUTTERWAVE_SECRET_KEY=FLWSECK_TEST-...
```

---

## Running Queues (for emails)

```bash
php artisan queue:work
```

---

## Design System

| Token | Value |
|-------|-------|
| Primary BG | `#0a0a0a` |
| Card BG | `#111111` |
| Accent | `#f97316` (orange) |
| Heading Font | Space Grotesk |
| Body Font | Inter |

All Tailwind classes extend the Koda design system defined in `tailwind.config.js`.

Key component classes: `.koda-card`, `.btn-primary`, `.btn-secondary`, `.koda-input`, `.koda-label`, `.badge`, `.badge-accent`

---

## Phase 2 Roadmap

- [ ] Product variants (size, color)
- [ ] Bulk CSV product upload
- [ ] Advanced vendor analytics
- [ ] Promo / flash sale scheduling
- [ ] PDF invoice generation
- [ ] Push notifications
- [ ] Reorder previous orders
- [ ] Product comparison

## Phase 3 Roadmap

- [ ] Multi-currency support
- [ ] Mobile app (Capacitor)
- [ ] Vendor subscription plans
- [ ] B2B bulk quote requests
- [ ] Shipping provider integration (DHL, Sendy)
- [ ] Accounting integration (QuickBooks)

KODA_FILE_AC036608

# --- SETUP.md ---
mkdir -p "."
cat > "SETUP.md" << 'KODA_FILE_166E76FB'
# Koda — Setup Guide

> **Stack:** Laravel 13 · Vue 3 · Inertia.js · Tailwind CSS 3

---

## System Requirements

| Tool       | Version |
|------------|---------|
| PHP        | ≥ 8.3   |
| Composer   | ≥ 2.6   |
| Node.js    | ≥ 20    |
| MySQL      | ≥ 8.0   |
| Redis      | optional (for queues) |

---

## Installation

### 1 — Clone & dependencies

```bash
# Install PHP packages
composer install

# Install Node packages
npm install
```

### 2 — Environment

```bash
cp .env.example .env
php artisan key:generate
```

Edit `.env`:

```env
APP_NAME=Koda
APP_URL=http://localhost:8000

DB_CONNECTION=mysql
DB_DATABASE=koda
DB_USERNAME=root
DB_PASSWORD=your_password

SESSION_DRIVER=database
QUEUE_CONNECTION=database
```

### 3 — Database

```bash
# Create DB first (MySQL):
# CREATE DATABASE koda CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

php artisan migrate
php artisan db:seed            # core data: roles, admin, 1 vendor, 12 categories, 5 products
php artisan db:seed --class=DemoSeeder  # optional: richer demo data
```

### 4 — Storage

```bash
php artisan storage:link
```

### 5 — Build assets

```bash
# Development (hot reload)
npm run dev

# Production
npm run build
```

### 6 — Run

```bash
php artisan serve
# Open http://localhost:8000
```

---

## Demo Accounts

| Role   | Email                     | Password  |
|--------|---------------------------|-----------|
| Admin  | admin@koda.com            | password  |
| Vendor | vendor@koda.com           | password  |
| Buyer  | buyer@koda.com            | password  |
| Buyers | buyer1-5@demo.com         | password  |

---

## Application URLs

### Public
| URL                        | Page                        |
|----------------------------|-----------------------------|
| `/`                        | Homepage                    |
| `/products`                | All products (filterable)   |
| `/products/{slug}`         | Product detail              |
| `/vendors`                 | Vendor directory            |
| `/vendors/{slug}`          | Vendor storefront           |
| `/categories`              | Category browser            |
| `/cart`                    | Shopping cart               |
| `/checkout`                | Checkout (auth required)    |
| `/order-confirmation/{id}` | Order confirmed             |
| `/vendor/apply`            | Vendor application form     |

### Buyer (authenticated)
| URL               | Page              |
|-------------------|-------------------|
| `/orders`         | Order history     |
| `/orders/{id}`    | Order detail      |
| `/wishlist`       | Saved items       |
| `/notifications`  | Notifications     |
| `/profile`        | Account settings  |

### Vendor Dashboard (`/vendor/…`)
| URL                      | Page                   |
|--------------------------|------------------------|
| `/vendor/dashboard`      | Overview & charts      |
| `/vendor/products`       | Product management     |
| `/vendor/products/create`| Add product            |
| `/vendor/orders`         | Order fulfilment       |
| `/vendor/reviews`        | Customer reviews       |
| `/vendor/earnings`       | Revenue & transactions |
| `/vendor/payouts`        | Payout requests        |
| `/vendor/profile`        | Storefront settings    |
| `/vendor/settings`       | Notification prefs     |

### Admin Panel (`/admin/…`)
| URL                   | Page                    |
|-----------------------|-------------------------|
| `/admin/dashboard`    | Platform overview       |
| `/admin/vendors`      | Vendor approvals        |
| `/admin/products`     | Product moderation      |
| `/admin/orders`       | All orders              |
| `/admin/categories`   | Category management     |
| `/admin/reviews`      | Review moderation       |
| `/admin/buyers`       | Buyer directory         |
| `/admin/payouts`      | Payout management       |
| `/admin/promos`       | Promo codes             |
| `/admin/settings`     | Platform settings       |

---

## Queues (for emails & notifications)

```bash
# Run the queue worker (separate terminal)
php artisan queue:work --queue=default

# Or use schedule for production
php artisan schedule:work
```

---

## Payment Configuration

### Stripe
```env
STRIPE_KEY=pk_test_...
STRIPE_SECRET=sk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...
```

### Flutterwave
```env
FLUTTERWAVE_PUBLIC_KEY=FLWPUBK_TEST-...
FLUTTERWAVE_SECRET_KEY=FLWSECK_TEST-...
```

---

## File Uploads

Product images and vendor logos/banners are stored in `storage/app/public`.
After running `php artisan storage:link`, they are served from `/storage/`.

For production, configure an S3 bucket in `.env`:
```env
FILESYSTEM_DISK=s3
AWS_ACCESS_KEY_ID=...
AWS_SECRET_ACCESS_KEY=...
AWS_DEFAULT_REGION=...
AWS_BUCKET=...
```

---

## Project Structure

```
koda/
├── app/
│   ├── Http/
│   │   ├── Controllers/
│   │   │   ├── Admin/          # 10 admin controllers
│   │   │   ├── Auth/           # 6 auth controllers
│   │   │   ├── Buyer/          # 2 buyer controllers
│   │   │   └── Vendor/         # 7 vendor controllers
│   │   └── Middleware/
│   ├── Models/                 # 12 Eloquent models
│   ├── Notifications/          # 3 queued notifications
│   ├── Observers/              # OrderObserver
│   └── Providers/
├── config/                     # 11 config files
├── database/
│   ├── factories/              # 4 model factories
│   ├── migrations/             # 3 migration files (18 tables)
│   └── seeders/                # DatabaseSeeder + DemoSeeder
├── public/
├── resources/
│   ├── css/app.css             # Koda design system
│   └── js/
│       ├── Components/
│       │   ├── Shared/         # 6 shared components
│       │   └── UI/             # 11 UI primitives
│       ├── composables/        # useCart, useFormat, useWishlist
│       ├── Layouts/            # AppLayout, DashboardLayout, GuestLayout
│       ├── Pages/              # 49 page components
│       └── stores/             # authStore, cartStore (Pinia)
└── routes/
    ├── web.php                 # ~75 named routes
    └── auth.php
```

---

## Key Design Tokens

```css
--bg-primary:   #0a0a0a   /* near-black background */
--bg-secondary: #111111   /* card backgrounds */
--accent:       #f97316   /* orange — all CTAs & highlights */
--text-primary: #ffffff
--text-secondary: #a3a3a3
--border:       #262626
```

Heading font: **Space Grotesk** · Body: **Inter** · Code: **JetBrains Mono**

---

## Tailwind Component Classes

```css
.koda-card      /* dark card with border */
.btn-primary    /* orange filled button */
.btn-secondary  /* subtle outlined button */
.btn-outline    /* accent outlined button */
.btn-ghost      /* transparent hover button */
.btn-danger     /* red destructive button */
.koda-input     /* dark styled text input */
.koda-label     /* form label */
.koda-select    /* custom select */
.koda-textarea  /* resizable textarea */
.badge          /* base badge */
.badge-accent   /* orange badge */
.badge-success  /* green badge */
.badge-warning  /* yellow badge */
.badge-error    /* red badge */
.koda-table     /* dark styled table */
.skeleton       /* shimmer loading state */
```

---

## Phase 2 Roadmap

- [ ] Product variants (size, colour, material)
- [ ] Bulk CSV product upload with validation
- [ ] Advanced vendor analytics dashboard
- [ ] Flash sale scheduling
- [ ] PDF invoice download (DomPDF)
- [ ] Autocomplete delivery address
- [ ] Reorder previous orders
- [ ] Product comparison (up to 3)
- [ ] Saved payment methods
- [ ] Abandoned cart email

## Phase 3 Roadmap

- [ ] Multi-currency & internationalisation
- [ ] Mobile app (Capacitor/Ionic)
- [ ] Vendor subscription plans
- [ ] B2B bulk quote requests
- [ ] Shipping provider integration (DHL, Sendy)
- [ ] QuickBooks / Xero accounting sync
- [ ] REST API with Laravel Sanctum
- [ ] Webhook support
- [ ] Fraud detection alerts

KODA_FILE_166E76FB

# --- app/Http/Controllers/Admin/BuyerController.php ---
mkdir -p "app/Http/Controllers/Admin"
cat > "app/Http/Controllers/Admin/BuyerController.php" << 'KODA_FILE_71253111'
<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Inertia\Inertia;

class BuyerController extends Controller
{
    public function index(Request $request)
    {
        $buyers = User::role('buyer')
            ->withCount('orders')
            ->withSum(['orders as total_spent' => fn($q) => $q->where('payment_status', 'paid')], 'total')
            ->when($request->q, fn($q) => $q->where(fn($sq) =>
                $sq->where('name', 'like', "%{$request->q}%")
                   ->orWhere('email', 'like', "%{$request->q}%")
            ))
            ->latest()
            ->paginate(20)
            ->withQueryString();

        $buyers->getCollection()->transform(function ($u) {
            $u->created_at_human = $u->created_at->diffForHumans();
            return $u;
        });

        return Inertia::render('Admin/Buyers/Index', ['buyers' => $buyers]);
    }
}

KODA_FILE_71253111

# --- app/Http/Controllers/Admin/CategoryController.php ---
mkdir -p "app/Http/Controllers/Admin"
cat > "app/Http/Controllers/Admin/CategoryController.php" << 'KODA_FILE_427A94B9'
<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Category;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Inertia\Inertia;

class CategoryController extends Controller
{
    public function index()
    {
        $categories = Category::withCount(['products' => fn($q) => $q->where('status', 'active')])->get();
        return Inertia::render('Admin/Categories/Index', ['categories' => $categories]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'name'        => 'required|string|max:100|unique:categories',
            'icon'        => 'nullable|string|max:10',
            'description' => 'nullable|string|max:500',
        ]);

        Category::create([
            'name'        => $request->name,
            'slug'        => Str::slug($request->name),
            'icon'        => $request->icon,
            'description' => $request->description,
        ]);

        return back()->with('success', 'Category created.');
    }

    public function update(Request $request, Category $category)
    {
        $request->validate([
            'name'        => 'required|string|max:100|unique:categories,name,' . $category->id,
            'icon'        => 'nullable|string|max:10',
            'description' => 'nullable|string|max:500',
        ]);

        $category->update([
            'name'        => $request->name,
            'slug'        => Str::slug($request->name),
            'icon'        => $request->icon,
            'description' => $request->description,
        ]);

        return back()->with('success', 'Category updated.');
    }

    public function destroy(Category $category)
    {
        if ($category->products()->count() > 0) {
            return back()->withErrors(['category' => 'Cannot delete a category with products.']);
        }

        $category->delete();
        return back()->with('success', 'Category deleted.');
    }
}

KODA_FILE_427A94B9

# --- app/Http/Controllers/Admin/DashboardController.php ---
mkdir -p "app/Http/Controllers/Admin"
cat > "app/Http/Controllers/Admin/DashboardController.php" << 'KODA_FILE_A6865818'
<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Order;
use App\Models\OrderItem;
use App\Models\User;
use App\Models\VendorProfile;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class DashboardController extends Controller
{
    public function index()
    {
        $revenue = Order::where('payment_status', 'paid')->sum('total');
        $orders  = Order::count();
        $vendors = VendorProfile::where('status', 'active')->count();
        $buyers  = User::role('buyer')->count();

        // Chart data
        $chartData = Order::where('payment_status','paid')
            ->where('created_at', '>=', now()->subDays(30))
            ->select(DB::raw('DATE(created_at) as date'), DB::raw('SUM(total) as total'))
            ->groupBy('date')->orderBy('date')
            ->pluck('total', 'date');

        $labels  = collect(range(29,0))->map(fn($i) => now()->subDays($i)->format('M d'))->values();
        $revenue_chart = collect(range(29,0))->map(fn($i) => $chartData[now()->subDays($i)->format('Y-m-d')] ?? 0)->values();

        $pendingVendors = VendorProfile::where('status', 'pending')
            ->latest()->take(10)->get()
            ->map(fn($v) => [...$v->only(['id','store_name']), 'created_at_human' => $v->created_at->diffForHumans()]);

        $recentOrders = Order::with('buyer')->latest()->take(8)->get()
            ->map(fn($o) => [...$o->only(['id','order_number','status','total']), 'buyer' => $o->buyer?->only(['name'])]);

        $topVendors = VendorProfile::where('status','active')
            ->withCount('orders')
            ->withSum('orderItemRevenue as revenue', 'subtotal')
            ->orderByDesc('revenue')
            ->take(5)->get();

        return Inertia::render('Admin/Dashboard', [
            'stats' => [
                'revenue'       => $revenue,
                'revenueChange' => 15,
                'orders'        => $orders,
                'ordersChange'  => 9,
                'vendors'       => $vendors,
                'vendorsChange' => 5,
                'buyers'        => $buyers,
                'buyersChange'  => 12,
            ],
            'pendingVendors' => $pendingVendors,
            'recentOrders'   => $recentOrders,
            'topVendors'     => $topVendors,
            'chartLabels'    => $labels,
            'chartRevenue'   => $revenue_chart,
        ]);
    }
}

KODA_FILE_A6865818

# --- app/Http/Controllers/Admin/OrderController.php ---
mkdir -p "app/Http/Controllers/Admin"
cat > "app/Http/Controllers/Admin/OrderController.php" << 'KODA_FILE_6CD89196'
<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Order;
use App\Models\OrderItem;
use Illuminate\Http\Request;
use Inertia\Inertia;

class OrderController extends Controller
{
    public function index(Request $request)
    {
        $orders = Order::with(['buyer', 'items'])
            ->withCount('items')
            ->when($request->status,  fn($q) => $q->where('status', $request->status))
            ->when($request->payment, fn($q) => $q->where('payment_status', $request->payment))
            ->latest()
            ->paginate(20)
            ->withQueryString();

        $orders->getCollection()->transform(function ($order) {
            $order->items_count     = $order->items->count();
            $order->created_at_human = $order->created_at->diffForHumans();
            return $order;
        });

        return Inertia::render('Admin/Orders/Index', ['orders' => $orders]);
    }

    public function show(Order $order)
    {
        $order->load(['buyer', 'items.product.vendor']);
        return Inertia::render('Admin/Orders/Show', ['order' => $order]);
    }

    public function updateStatus(Request $request, Order $order)
    {
        $request->validate(['status' => 'required|in:pending,processing,shipped,delivered,cancelled']);
        $order->update(['status' => $request->status]);
        return back()->with('success', 'Order status updated.');
    }
}

KODA_FILE_6CD89196

# --- app/Http/Controllers/Admin/PayoutController.php ---
mkdir -p "app/Http/Controllers/Admin"
cat > "app/Http/Controllers/Admin/PayoutController.php" << 'KODA_FILE_54F8FD83'
<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\VendorProfile;
use Illuminate\Http\Request;
use Inertia\Inertia;

class PayoutController extends Controller
{
    public function index()
    {
        // Phase 2 will have a payouts table.
        // For now return empty array.
        return Inertia::render('Admin/Payouts/Index', [
            'payouts' => [],
        ]);
    }

    public function update(Request $request, int $id)
    {
        $request->validate([
            'status' => 'required|in:pending,approved,paid,rejected',
        ]);

        // Phase 2: update payout record
        // Payout::findOrFail($id)->update(['status' => $request->status]);

        return back()->with('success', 'Payout status updated.');
    }
}

KODA_FILE_54F8FD83

# --- app/Http/Controllers/Admin/ProductController.php ---
mkdir -p "app/Http/Controllers/Admin"
cat > "app/Http/Controllers/Admin/ProductController.php" << 'KODA_FILE_2FCF2D9B'
<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Category;
use App\Models\Product;
use Illuminate\Http\Request;
use Inertia\Inertia;

class ProductController extends Controller
{
    public function index(Request $request)
    {
        $products = Product::with(['vendor', 'category'])
            ->when($request->status,   fn($q) => $q->where('status', $request->status))
            ->when($request->category, fn($q) => $q->where('category_id', $request->category))
            ->when($request->q,        fn($q) => $q->where('name', 'like', "%{$request->q}%"))
            ->latest()
            ->paginate(24)
            ->withQueryString();

        return Inertia::render('Admin/Products/Index', [
            'products'   => $products,
            'categories' => Category::all(['id', 'name']),
        ]);
    }

    public function toggleFeatured(Request $request, Product $product)
    {
        $product->update(['is_featured' => $request->boolean('is_featured')]);
        return back()->with('success', 'Featured status updated.');
    }

    public function destroy(Product $product)
    {
        $product->delete();
        return back()->with('success', 'Product deleted.');
    }
}

KODA_FILE_2FCF2D9B

# --- app/Http/Controllers/Admin/PromoController.php ---
mkdir -p "app/Http/Controllers/Admin"
cat > "app/Http/Controllers/Admin/PromoController.php" << 'KODA_FILE_DBB4D098'
<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\PromoCode;
use Illuminate\Http\Request;
use Inertia\Inertia;

class PromoController extends Controller
{
    public function index()
    {
        return Inertia::render('Admin/Promos/Index', [
            'promoCodes' => PromoCode::latest()->get(),
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'code'       => 'required|string|max:50|unique:promo_codes',
            'type'       => 'required|in:percent,fixed',
            'value'      => 'required|numeric|min:0',
            'max_uses'   => 'nullable|integer|min:1',
            'expires_at' => 'nullable|date|after:today',
        ]);

        PromoCode::create([
            'code'       => strtoupper($request->code),
            'type'       => $request->type,
            'value'      => $request->value,
            'max_uses'   => $request->max_uses ?? null,
            'expires_at' => $request->expires_at ?? null,
            'is_active'  => true,
        ]);

        return back()->with('success', 'Promo code created.');
    }

    public function destroy(PromoCode $promo)
    {
        $promo->delete();
        return back()->with('success', 'Promo code deleted.');
    }
}

KODA_FILE_DBB4D098

# --- app/Http/Controllers/Admin/ReviewController.php ---
mkdir -p "app/Http/Controllers/Admin"
cat > "app/Http/Controllers/Admin/ReviewController.php" << 'KODA_FILE_C48D9013'
<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Review;
use Inertia\Inertia;

class ReviewController extends Controller
{
    public function index()
    {
        $reviews = Review::with(['user', 'product'])
            ->latest()->get()
            ->map(fn($r) => [
                ...$r->toArray(),
                'created_at_human' => $r->created_at->diffForHumans(),
                'user'    => $r->user?->only(['name']),
                'product' => $r->product?->only(['name', 'slug']),
            ]);

        return Inertia::render('Admin/Reviews/Index', ['reviews' => $reviews]);
    }

    public function approve(Review $review)
    {
        $review->update(['approved' => true]);
        return back()->with('success', 'Review approved.');
    }

    public function destroy(Review $review)
    {
        $review->delete();
        return back()->with('success', 'Review deleted.');
    }
}

KODA_FILE_C48D9013

# --- app/Http/Controllers/Admin/SettingsController.php ---
mkdir -p "app/Http/Controllers/Admin"
cat > "app/Http/Controllers/Admin/SettingsController.php" << 'KODA_FILE_FA451A5D'
<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Inertia\Inertia;

class SettingsController extends Controller
{
    public function index()
    {
        return Inertia::render('Admin/Settings/Index', [
            'settings' => [
                'app_name'                 => config('app.name', 'Koda'),
                'support_email'            => env('MAIL_FROM_ADDRESS', 'support@koda.com'),
                'currency'                 => 'KES',
                'commission_rate'          => 10,
                'min_payout'               => 500,
                'auto_approve_vendors'     => false,
                'require_product_approval' => false,
                'maintenance_mode'         => app()->isDownForMaintenance(),
            ],
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'app_name'        => 'required|string|max:100',
            'support_email'   => 'required|email',
            'commission_rate' => 'required|numeric|min:0|max:50',
            'min_payout'      => 'required|numeric|min:0',
        ]);

        // In production: persist to a settings table or .env via artisan config:cache
        // For now we just flash success
        return back()->with('success', 'Settings saved.');
    }
}

KODA_FILE_FA451A5D

# --- app/Http/Controllers/Admin/VendorController.php ---
mkdir -p "app/Http/Controllers/Admin"
cat > "app/Http/Controllers/Admin/VendorController.php" << 'KODA_FILE_456BBCC3'
<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\VendorProfile;
use Illuminate\Http\Request;
use Inertia\Inertia;

class VendorController extends Controller
{
    public function index(Request $request)
    {
        $vendors = VendorProfile::with('user')
            ->withCount('products')
            ->when($request->status, fn($q) => $q->where('status', $request->status))
            ->when($request->q, fn($q) => $q->where('store_name', 'like', "%{$request->q}%"))
            ->latest()
            ->paginate(20)
            ->withQueryString();

        return Inertia::render('Admin/Vendors/Index', [
            'vendors' => $vendors,
            'filters' => $request->only(['status','q']),
        ]);
    }

    public function show(VendorProfile $vendor)
    {
        $vendor->load(['user', 'products' => fn($q) => $q->latest()->take(5)]);
        return Inertia::render('Admin/Vendors/Show', ['vendor' => $vendor]);
    }

    public function approve(VendorProfile $vendor)
    {
        $vendor->update(['status' => 'active', 'is_verified' => true, 'rejection_reason' => null]);

        // Assign vendor role to user
        $vendor->user->assignRole('vendor');

        // Notify vendor
        $vendor->user->notify(new \App\Notifications\VendorApprovedNotification());

        return back()->with('success', "{$vendor->store_name} has been approved!");
    }

    public function reject(Request $request, VendorProfile $vendor)
    {
        $request->validate(['reason' => 'required|string|min:10']);

        $vendor->update([
            'status'           => 'rejected',
            'rejection_reason' => $request->reason,
        ]);

        // TODO: Send rejection email

        return back()->with('success', 'Vendor application rejected.');
    }

    public function suspend(VendorProfile $vendor)
    {
        $vendor->update(['status' => 'suspended']);
        return back()->with('success', 'Vendor suspended.');
    }

    public function toggleVerified(Request $request, VendorProfile $vendor)
    {
        $vendor->update(['is_verified' => $request->boolean('is_verified')]);
        $action = $vendor->is_verified ? 'granted' : 'removed';
        return back()->with('success', "Verified badge {$action}.");
    }

    public function destroy(VendorProfile $vendor)
    {
        $vendor->products()->delete();
        $vendor->delete();
        return redirect()->route('admin.vendors.index')->with('success', 'Vendor deleted.');
    }
}

KODA_FILE_456BBCC3

# --- app/Http/Controllers/Auth/AuthenticatedSessionController.php ---
mkdir -p "app/Http/Controllers/Auth"
cat > "app/Http/Controllers/Auth/AuthenticatedSessionController.php" << 'KODA_FILE_5A41F259'
<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\LoginRequest;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Inertia\Inertia;
use Inertia\Response;

class AuthenticatedSessionController extends Controller
{
    public function create(): Response
    {
        return Inertia::render('Auth/Login');
    }

    public function store(LoginRequest $request): RedirectResponse
    {
        $request->authenticate();
        $request->session()->regenerate();

        $user = Auth::user();

        // Role-based redirect
        if ($user->hasRole('admin')) {
            return redirect()->intended(route('admin.dashboard'));
        }

        if ($user->hasRole('vendor')) {
            return redirect()->intended(route('vendor.dashboard'));
        }

        return redirect()->intended(route('home'));
    }

    public function destroy(Request $request): RedirectResponse
    {
        Auth::guard('web')->logout();
        $request->session()->invalidate();
        $request->session()->regenerateToken();
        return redirect()->route('home');
    }
}

KODA_FILE_5A41F259

# --- app/Http/Controllers/Auth/EmailVerificationNotificationController.php ---
mkdir -p "app/Http/Controllers/Auth"
cat > "app/Http/Controllers/Auth/EmailVerificationNotificationController.php" << 'KODA_FILE_6CF8EEDB'
<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;

class EmailVerificationNotificationController extends Controller
{
    public function store(Request $request): RedirectResponse
    {
        if ($request->user()->hasVerifiedEmail()) {
            return redirect()->intended(route('home'));
        }
        $request->user()->sendEmailVerificationNotification();
        return back()->with('status', 'verification-link-sent');
    }
}

KODA_FILE_6CF8EEDB

# --- app/Http/Controllers/Auth/NewPasswordController.php ---
mkdir -p "app/Http/Controllers/Auth"
cat > "app/Http/Controllers/Auth/NewPasswordController.php" << 'KODA_FILE_D58251FA'
<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Auth\Events\PasswordReset;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Password;
use Illuminate\Support\Str;
use Illuminate\Validation\Rules;
use Illuminate\Validation\ValidationException;
use Inertia\Inertia;
use Inertia\Response;

class NewPasswordController extends Controller
{
    public function create(Request $request): Response
    {
        return Inertia::render('Auth/ResetPassword', [
            'email' => $request->email,
            'token' => $request->route('token'),
        ]);
    }

    public function store(Request $request): RedirectResponse
    {
        $request->validate([
            'token'    => 'required',
            'email'    => 'required|email',
            'password' => ['required', 'confirmed', Rules\Password::defaults()],
        ]);

        $status = Password::reset(
            $request->only('email', 'password', 'password_confirmation', 'token'),
            function ($user) use ($request) {
                $user->forceFill([
                    'password'       => Hash::make($request->password),
                    'remember_token' => Str::random(60),
                ])->save();
                event(new PasswordReset($user));
            }
        );

        if ($status === Password::PASSWORD_RESET) {
            return redirect()->route('login')->with('status', __($status));
        }

        throw ValidationException::withMessages(['email' => [trans($status)]]);
    }
}

KODA_FILE_D58251FA

# --- app/Http/Controllers/Auth/PasswordResetLinkController.php ---
mkdir -p "app/Http/Controllers/Auth"
cat > "app/Http/Controllers/Auth/PasswordResetLinkController.php" << 'KODA_FILE_F2F59D2E'
<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Password;
use Illuminate\Validation\ValidationException;
use Inertia\Inertia;
use Inertia\Response;

class PasswordResetLinkController extends Controller
{
    public function create(): Response
    {
        return Inertia::render('Auth/ForgotPassword');
    }

    public function store(Request $request): RedirectResponse
    {
        $request->validate(['email' => 'required|email']);

        $status = Password::sendResetLink($request->only('email'));

        if ($status === Password::RESET_LINK_SENT) {
            return back()->with('status', __($status));
        }

        throw ValidationException::withMessages(['email' => [trans($status)]]);
    }
}

KODA_FILE_F2F59D2E

# --- app/Http/Controllers/Auth/RegisteredUserController.php ---
mkdir -p "app/Http/Controllers/Auth"
cat > "app/Http/Controllers/Auth/RegisteredUserController.php" << 'KODA_FILE_165714FC'
<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\VendorProfile;
use Illuminate\Auth\Events\Registered;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use Inertia\Inertia;

class RegisteredUserController extends Controller
{
    public function create()
    {
        return Inertia::render('Auth/Register');
    }

    public function store(Request $request)
    {
        $request->validate([
            'first_name'           => 'required|string|max:100',
            'last_name'            => 'required|string|max:100',
            'email'                => 'required|string|lowercase|email|max:255|unique:users',
            'password'             => 'required|string|min:8|confirmed',
            'role'                 => 'required|in:buyer,vendor',
            'store_name'           => 'required_if:role,vendor|nullable|string|max:100|unique:vendor_profiles',
            'terms'                => 'accepted',
        ]);

        $user = User::create([
            'name'     => $request->first_name . ' ' . $request->last_name,
            'email'    => $request->email,
            'password' => Hash::make($request->password),
        ]);

        $user->assignRole($request->role);

        if ($request->role === 'vendor') {
            VendorProfile::create([
                'user_id'    => $user->id,
                'store_name' => $request->store_name,
                'slug'       => Str::slug($request->store_name) . '-' . Str::random(4),
                'status'     => 'pending',
            ]);
        }

        event(new Registered($user));

        Auth::login($user);

        return redirect()->intended(
            $request->role === 'vendor'
                ? route('vendor.dashboard')
                : route('home')
        );
    }
}

KODA_FILE_165714FC

# --- app/Http/Controllers/Auth/VerifyEmailController.php ---
mkdir -p "app/Http/Controllers/Auth"
cat > "app/Http/Controllers/Auth/VerifyEmailController.php" << 'KODA_FILE_B2956F2B'
<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Auth\Events\Verified;
use Illuminate\Foundation\Auth\EmailVerificationRequest;
use Illuminate\Http\RedirectResponse;

class VerifyEmailController extends Controller
{
    public function __invoke(EmailVerificationRequest $request): RedirectResponse
    {
        if ($request->user()->hasVerifiedEmail()) {
            return redirect()->intended(route('home') . '?verified=1');
        }

        if ($request->user()->markEmailAsVerified()) {
            event(new Verified($request->user()));
        }

        return redirect()->intended(route('home') . '?verified=1');
    }
}

KODA_FILE_B2956F2B

# --- app/Http/Controllers/Buyer/OrderConfirmationController.php ---
mkdir -p "app/Http/Controllers/Buyer"
cat > "app/Http/Controllers/Buyer/OrderConfirmationController.php" << 'KODA_FILE_D8EA6EBB'
<?php

namespace App\Http\Controllers\Buyer;

use App\Http\Controllers\Controller;
use App\Models\Order;
use Inertia\Inertia;

class OrderConfirmationController extends Controller
{
    public function show(Order $order)
    {
        abort_unless($order->buyer_id === auth()->id(), 403);

        $order->load(['items.product.vendor']);
        $order->created_at_human = $order->created_at->diffForHumans();

        return Inertia::render('Public/OrderConfirmation', ['order' => $order]);
    }
}

KODA_FILE_D8EA6EBB

# --- app/Http/Controllers/Buyer/OrderController.php ---
mkdir -p "app/Http/Controllers/Buyer"
cat > "app/Http/Controllers/Buyer/OrderController.php" << 'KODA_FILE_C25FB42B'
<?php

namespace App\Http\Controllers\Buyer;

use App\Http\Controllers\Controller;
use App\Models\Order;
use Inertia\Inertia;

class OrderController extends Controller
{
    public function index()
    {
        $orders = Order::where('buyer_id', auth()->id())
            ->with(['items.product.vendor'])
            ->latest()
            ->paginate(15);

        $orders->getCollection()->transform(function ($order) {
            $order->created_at_human = $order->created_at->diffForHumans();
            return $order;
        });

        return Inertia::render('Buyer/Orders/Index', ['orders' => $orders]);
    }

    public function show(Order $order)
    {
        abort_unless($order->buyer_id === auth()->id(), 403);

        $order->load(['items.product.vendor', 'promoCode']);
        $order->created_at_human = $order->created_at->diffForHumans();

        return Inertia::render('Buyer/Orders/Show', ['order' => $order]);
    }
}

KODA_FILE_C25FB42B

# --- app/Http/Controllers/CartController.php ---
mkdir -p "app/Http/Controllers"
cat > "app/Http/Controllers/CartController.php" << 'KODA_FILE_151B2DE7'
<?php

namespace App\Http\Controllers;

use App\Models\Cart;
use App\Models\CartItem;
use App\Models\Product;
use App\Models\PromoCode;
use Illuminate\Http\Request;
use Inertia\Inertia;

class CartController extends Controller
{
    private function getOrCreateCart(): Cart
    {
        if (auth()->check()) {
            return Cart::firstOrCreate(['user_id' => auth()->id()]);
        }

        $sessionId = session()->getId();
        return Cart::firstOrCreate(['session_id' => $sessionId]);
    }

    public function index()
    {
        $cart = $this->getOrCreateCart();
        $cart->load(['items.product.vendor']);

        $cartItems = $cart->items->map(function ($item) {
            return [
                'id'       => $item->id,
                'quantity' => $item->quantity,
                'subtotal' => $item->subtotal,
                'product'  => [
                    'id'        => $item->product->id,
                    'name'      => $item->product->name,
                    'slug'      => $item->product->slug,
                    'price'     => $item->product->price,
                    'thumbnail' => $item->product->thumbnail,
                    'stock'     => $item->product->stock,
                    'vendor'    => $item->product->vendor?->only(['store_name', 'slug']),
                ],
            ];
        });

        return Inertia::render('Public/Cart', [
            'cartItems' => $cartItems,
        ]);
    }

    public function add(Request $request)
    {
        $request->validate([
            'product_id' => 'required|exists:products,id',
            'quantity'   => 'integer|min:1|max:100',
        ]);

        $product = Product::findOrFail($request->product_id);

        if ($product->stock < ($request->quantity ?? 1)) {
            return back()->with('error', 'Not enough stock available.');
        }

        $cart = $this->getOrCreateCart();
        $item = $cart->items()->where('product_id', $product->id)->first();

        if ($item) {
            $newQty = $item->quantity + ($request->quantity ?? 1);
            if ($newQty > $product->stock) {
                return back()->with('error', 'Cannot add more than available stock.');
            }
            $item->update(['quantity' => $newQty]);
        } else {
            $cart->items()->create([
                'product_id' => $product->id,
                'quantity'   => $request->quantity ?? 1,
            ]);
        }

        return back()->with('success', 'Item added to cart!');
    }

    public function update(Request $request, CartItem $item)
    {
        $request->validate(['quantity' => 'required|integer|min:1']);

        $this->authorize('update', $item);

        $item->update(['quantity' => $request->quantity]);

        return back();
    }

    public function remove(CartItem $item)
    {
        $this->authorize('delete', $item);
        $item->delete();
        return back()->with('success', 'Item removed.');
    }

    public function clear()
    {
        $cart = $this->getOrCreateCart();
        $cart->items()->delete();
        return back()->with('success', 'Cart cleared.');
    }

    public function applyPromo(Request $request)
    {
        $request->validate(['code' => 'required|string']);

        $promo = PromoCode::where('code', strtoupper($request->code))->first();

        if (!$promo || !$promo->isValid()) {
            return back()->withErrors(['code' => 'Invalid or expired promo code.']);
        }

        session(['promo_code_id' => $promo->id]);

        $cart = $this->getOrCreateCart();
        $cart->load('items.product');
        $subtotal = $cart->items->sum('subtotal');

        $discount = $promo->type === 'percent'
            ? ($subtotal * $promo->value / 100)
            : $promo->value;

        return back()->with(['success' => 'Promo applied!', 'discount' => min($discount, $subtotal)]);
    }
}

KODA_FILE_151B2DE7

# --- app/Http/Controllers/CategoryController.php ---
mkdir -p "app/Http/Controllers"
cat > "app/Http/Controllers/CategoryController.php" << 'KODA_FILE_C6F2E7C4'
<?php

namespace App\Http\Controllers;

use App\Models\Category;
use App\Models\Product;
use App\Models\Wishlist;
use Illuminate\Http\Request;
use Inertia\Inertia;

class CategoryController extends Controller
{
    public function index()
    {
        return Inertia::render('Public/Categories/Index', [
            'categories' => Category::withCount([
                'products' => fn($q) => $q->where('status', 'active'),
            ])->get(),
        ]);
    }

    public function show(Request $request, Category $category)
    {
        $query = Product::with(['vendor', 'category'])
            ->active()
            ->where('category_id', $category->id);

        if ($request->filled('q')) {
            $query->where('name', 'like', "%{$request->q}%");
        }

        match ($request->sort) {
            'price_asc'  => $query->orderBy('price'),
            'price_desc' => $query->orderByDesc('price'),
            'rating'     => $query->withCount('reviews')->orderByDesc('reviews_count'),
            'newest'     => $query->latest(),
            default      => $query->latest(),
        };

        $products = $query->paginate(20)->withQueryString();

        if (auth()->check()) {
            $wishlistIds = Wishlist::where('user_id', auth()->id())->pluck('product_id')->toArray();
            $products->getCollection()->transform(function ($p) use ($wishlistIds) {
                $p->in_wishlist = in_array($p->id, $wishlistIds);
                return $p;
            });
        }

        return Inertia::render('Public/Categories/Show', [
            'category' => $category,
            'products' => $products,
            'filters'  => $request->only(['q', 'sort']),
        ]);
    }
}

KODA_FILE_C6F2E7C4

# --- app/Http/Controllers/CheckoutController.php ---
mkdir -p "app/Http/Controllers"
cat > "app/Http/Controllers/CheckoutController.php" << 'KODA_FILE_29C9F29E'
<?php

namespace App\Http\Controllers;

use App\Models\Cart;
use App\Models\Order;
use App\Models\OrderItem;
use App\Models\PromoCode;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class CheckoutController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth');
    }

    public function index()
    {
        $cart = Cart::where('user_id', auth()->id())
            ->with(['items.product.vendor'])
            ->first();

        if (!$cart || $cart->items->isEmpty()) {
            return redirect()->route('cart.index')->with('error', 'Your cart is empty.');
        }

        $cartItems = $cart->items->map(fn($item) => [
            'id'       => $item->id,
            'quantity' => $item->quantity,
            'subtotal' => $item->subtotal,
            'product'  => $item->product->only(['id','name','slug','price','thumbnail']),
        ]);

        return Inertia::render('Public/Checkout', [
            'cartItems' => $cartItems,
            'user'      => auth()->user()->only(['name','email']),
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'first_name'     => 'required|string|max:100',
            'last_name'      => 'required|string|max:100',
            'email'          => 'required|email',
            'address'        => 'required|string|max:255',
            'city'           => 'required|string|max:100',
            'country'        => 'required|string|size:2',
            'payment_method' => 'required|in:stripe,flutterwave,mpesa',
        ]);

        $cart = Cart::where('user_id', auth()->id())->with('items.product')->firstOrFail();

        if ($cart->items->isEmpty()) {
            return back()->with('error', 'Your cart is empty.');
        }

        DB::transaction(function () use ($request, $cart) {
            $subtotal   = $cart->items->sum('subtotal');
            $promoCode  = session('promo_code_id') ? PromoCode::find(session('promo_code_id')) : null;
            $discount   = 0;

            if ($promoCode && $promoCode->isValid()) {
                $discount = $promoCode->type === 'percent'
                    ? ($subtotal * $promoCode->value / 100)
                    : $promoCode->value;
                $discount = min($discount, $subtotal);
                $promoCode->increment('uses');
            }

            $order = Order::create([
                'buyer_id'        => auth()->id(),
                'status'          => 'pending',
                'payment_status'  => 'unpaid',
                'payment_method'  => $request->payment_method,
                'subtotal'        => $subtotal,
                'discount'        => $discount,
                'shipping'        => 0,
                'total'           => max(0, $subtotal - $discount),
                'shipping_name'   => $request->first_name . ' ' . $request->last_name,
                'shipping_email'  => $request->email,
                'shipping_phone'  => $request->phone,
                'shipping_address'=> $request->address,
                'shipping_city'   => $request->city,
                'shipping_country'=> $request->country,
                'promo_code_id'   => $promoCode?->id,
                'notes'           => $request->notes,
            ]);

            foreach ($cart->items as $item) {
                OrderItem::create([
                    'order_id'          => $order->id,
                    'product_id'        => $item->product_id,
                    'vendor_profile_id' => $item->product->vendor_profile_id,
                    'quantity'          => $item->quantity,
                    'unit_price'        => $item->product->price,
                    'subtotal'          => $item->subtotal,
                    'status'            => 'pending',
                ]);

                // Decrement stock
                $item->product->decrement('stock', $item->quantity);
            }

            // Clear cart
            $cart->items()->delete();
            session()->forget('promo_code_id');

            // Notify buyer
            $order->buyer->notify(new \App\Notifications\OrderConfirmedNotification($order));

            // Notify vendors (via observer wired in AppServiceProvider)
            session(['pending_order_id' => $order->id]);
        });

        return redirect()->route('orders.confirmation', session('pending_order_id'))
            ->with('success', 'Order placed successfully!');
    }
}

KODA_FILE_29C9F29E

# --- app/Http/Controllers/HomeController.php ---
mkdir -p "app/Http/Controllers"
cat > "app/Http/Controllers/HomeController.php" << 'KODA_FILE_EB94CA50'
<?php

namespace App\Http\Controllers;

use App\Models\Category;
use App\Models\Product;
use App\Models\VendorProfile;
use Inertia\Inertia;

class HomeController extends Controller
{
    public function index()
    {
        return Inertia::render('Public/Home', [
            'categories'       => Category::withCount(['products' => fn($q) => $q->where('status','active')])->get(),
            'featuredProducts' => Product::with(['vendor','category'])
                ->active()->featured()->latest()->take(10)->get(),
            'trendingProducts' => Product::with(['vendor','category'])
                ->active()->withCount('reviews')->orderByDesc('reviews_count')->take(10)->get(),
            'topVendors'       => VendorProfile::where('status','active')
                ->withCount('products')->orderByDesc('products_count')->take(8)->get(),
        ]);
    }
}

KODA_FILE_EB94CA50

# --- app/Http/Controllers/NotificationController.php ---
mkdir -p "app/Http/Controllers"
cat > "app/Http/Controllers/NotificationController.php" << 'KODA_FILE_8953C183'
<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Inertia\Inertia;

class NotificationController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth');
    }

    public function index()
    {
        $notifications = auth()->user()
            ->notifications()
            ->latest()
            ->paginate(20);

        return Inertia::render('Notifications/Index', [
            'notifications' => $notifications,
        ]);
    }

    public function markRead(Request $request)
    {
        if ($request->id) {
            auth()->user()->notifications()->where('id', $request->id)->update(['read_at' => now()]);
        } else {
            auth()->user()->unreadNotifications->markAsRead();
        }

        return back()->with('success', 'Marked as read.');
    }
}

KODA_FILE_8953C183

# --- app/Http/Controllers/ProductController.php ---
mkdir -p "app/Http/Controllers"
cat > "app/Http/Controllers/ProductController.php" << 'KODA_FILE_1396F448'
<?php

namespace App\Http\Controllers;

use App\Models\Category;
use App\Models\Product;
use App\Models\Wishlist;
use Illuminate\Http\Request;
use Inertia\Inertia;

class ProductController extends Controller
{
    public function index(Request $request)
    {
        $query = Product::with(['vendor', 'category'])->active();

        if ($request->filled('q')) {
            $query->where('name', 'like', "%{$request->q}%")
                  ->orWhere('description', 'like', "%{$request->q}%");
        }

        if ($request->filled('categories')) {
            $query->whereIn('category_id', (array) $request->categories);
        }

        if ($request->filled('minPrice')) {
            $query->where('price', '>=', $request->minPrice);
        }

        if ($request->filled('maxPrice')) {
            $query->where('price', '<=', $request->maxPrice);
        }

        if ($request->filled('minRating')) {
            $query->whereHas('reviews', function ($q) use ($request) {
                $q->where('approved', true)
                  ->groupBy('product_id')
                  ->havingRaw('AVG(rating) >= ?', [$request->minRating]);
            });
        }

        match ($request->sort) {
            'price_asc'  => $query->orderBy('price'),
            'price_desc' => $query->orderByDesc('price'),
            'rating'     => $query->withCount('reviews')->orderByDesc('reviews_count'),
            'newest'     => $query->latest(),
            default      => $query->where('is_featured', true)->orderByDesc('is_featured')->latest(),
        };

        $products = $query->paginate(20)->withQueryString();

        // Append wishlist status for authenticated users
        if (auth()->check()) {
            $wishlistIds = Wishlist::where('user_id', auth()->id())
                ->pluck('product_id')->toArray();

            $products->getCollection()->transform(function ($product) use ($wishlistIds) {
                $product->in_wishlist = in_array($product->id, $wishlistIds);
                return $product;
            });
        }

        return Inertia::render('Public/Products/Index', [
            'products'   => $products,
            'categories' => Category::withCount(['products' => fn($q) => $q->where('status','active')])->get(),
            'filters'    => $request->only(['q','sort','categories','minPrice','maxPrice','minRating']),
        ]);
    }

    public function show(Product $product)
    {
        abort_unless($product->status === 'active', 404);

        $product->load(['vendor', 'category', 'images', 'reviews.user']);

        $product->in_wishlist = auth()->check()
            ? Wishlist::where('user_id', auth()->id())->where('product_id', $product->id)->exists()
            : false;

        $related = Product::with(['vendor'])
            ->active()
            ->where('category_id', $product->category_id)
            ->where('id', '!=', $product->id)
            ->take(5)
            ->get();

        return Inertia::render('Public/Products/Show', [
            'product'        => $product,
            'relatedProducts'=> $related,
        ]);
    }
}

KODA_FILE_1396F448

# --- app/Http/Controllers/ProfileController.php ---
mkdir -p "app/Http/Controllers"
cat > "app/Http/Controllers/ProfileController.php" << 'KODA_FILE_8BF89F93'
<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rules\Password;
use Inertia\Inertia;

class ProfileController extends Controller
{
    public function edit()
    {
        return Inertia::render('Profile/Edit');
    }

    public function update(Request $request)
    {
        $user = $request->user();

        $request->validate([
            'name'  => 'required|string|max:255',
            'email' => 'required|email|max:255|unique:users,email,' . $user->id,
        ]);

        $user->fill($request->only('name', 'email'));

        if ($user->isDirty('email')) {
            $user->email_verified_at = null;
        }

        $user->save();

        return back()->with('success', 'Profile updated.');
    }

    public function updatePassword(Request $request)
    {
        $request->validate([
            'current_password' => 'required|current_password',
            'password'         => ['required', 'confirmed', Password::defaults()],
        ]);

        $request->user()->update(['password' => Hash::make($request->password)]);

        return back()->with('success', 'Password updated successfully.');
    }

    public function destroy(Request $request)
    {
        $request->validate(['password' => 'required|current_password']);

        $user = $request->user();
        Auth::logout();
        $user->delete();

        $request->session()->invalidate();
        $request->session()->regenerateToken();

        return redirect('/')->with('success', 'Account deleted.');
    }
}

KODA_FILE_8BF89F93

# --- app/Http/Controllers/ReviewController.php ---
mkdir -p "app/Http/Controllers"
cat > "app/Http/Controllers/ReviewController.php" << 'KODA_FILE_0E31FA24'
<?php

namespace App\Http\Controllers;

use App\Models\Review;
use Illuminate\Http\Request;

class ReviewController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth');
    }

    public function store(Request $request)
    {
        $request->validate([
            'product_id' => 'required|exists:products,id',
            'rating'     => 'required|integer|min:1|max:5',
            'comment'    => 'nullable|string|max:1000',
        ]);

        // Check if user has purchased the product
        $hasPurchased = auth()->user()
            ->orders()
            ->where('payment_status', 'paid')
            ->whereHas('items', fn($q) => $q->where('product_id', $request->product_id))
            ->exists();

        if (!$hasPurchased) {
            return back()->withErrors(['review' => 'You can only review products you have purchased.']);
        }

        // Prevent duplicate reviews
        $existing = Review::where('user_id', auth()->id())
            ->where('product_id', $request->product_id)
            ->first();

        if ($existing) {
            return back()->withErrors(['review' => 'You have already reviewed this product.']);
        }

        Review::create([
            'user_id'    => auth()->id(),
            'product_id' => $request->product_id,
            'rating'     => $request->rating,
            'comment'    => $request->comment,
            'approved'   => false, // Requires admin approval
        ]);

        return back()->with('success', 'Review submitted! It will appear after approval.');
    }
}

KODA_FILE_0E31FA24

# --- app/Http/Controllers/SearchController.php ---
mkdir -p "app/Http/Controllers"
cat > "app/Http/Controllers/SearchController.php" << 'KODA_FILE_62BD0597'
<?php

namespace App\Http\Controllers;

use App\Models\Category;
use App\Models\Product;
use App\Models\VendorProfile;
use Illuminate\Http\Request;

class SearchController extends Controller
{
    /**
     * API-style autocomplete for navbar search.
     */
    public function autocomplete(Request $request)
    {
        $q = trim($request->get('q', ''));

        if (strlen($q) < 2) {
            return response()->json(['products' => [], 'vendors' => [], 'categories' => []]);
        }

        $products = Product::active()
            ->where('name', 'like', "%{$q}%")
            ->with('vendor')
            ->select(['id', 'name', 'slug', 'thumbnail', 'price', 'vendor_profile_id'])
            ->take(5)
            ->get()
            ->map(fn($p) => [
                'id'        => $p->id,
                'name'      => $p->name,
                'slug'      => $p->slug,
                'price'     => $p->price,
                'thumbnail' => $p->thumbnail,
                'vendor'    => $p->vendor?->store_name,
                'type'      => 'product',
            ]);

        $vendors = VendorProfile::where('status', 'active')
            ->where('store_name', 'like', "%{$q}%")
            ->select(['id', 'store_name', 'slug', 'logo'])
            ->take(3)
            ->get()
            ->map(fn($v) => [
                'id'   => $v->id,
                'name' => $v->store_name,
                'slug' => $v->slug,
                'logo' => $v->logo,
                'type' => 'vendor',
            ]);

        $categories = Category::where('name', 'like', "%{$q}%")
            ->select(['id', 'name', 'slug', 'icon'])
            ->take(3)
            ->get()
            ->map(fn($c) => [
                'id'   => $c->id,
                'name' => $c->name,
                'slug' => $c->slug,
                'icon' => $c->icon,
                'type' => 'category',
            ]);

        return response()->json(compact('products', 'vendors', 'categories'));
    }
}

KODA_FILE_62BD0597

# --- app/Http/Controllers/Vendor/DashboardController.php ---
mkdir -p "app/Http/Controllers/Vendor"
cat > "app/Http/Controllers/Vendor/DashboardController.php" << 'KODA_FILE_F4BBEE18'
<?php

namespace App\Http\Controllers\Vendor;

use App\Http\Controllers\Controller;
use App\Models\Order;
use App\Models\OrderItem;
use App\Models\Product;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class DashboardController extends Controller
{
    public function index()
    {
        $vendor = auth()->user()->vendorProfile;

        abort_unless($vendor && $vendor->status === 'active', 403, 'Vendor account not active.');

        // Revenue & stats
        $revenue = OrderItem::where('vendor_profile_id', $vendor->id)
            ->whereHas('order', fn($q) => $q->where('payment_status', 'paid'))
            ->sum('subtotal');

        $orders = OrderItem::where('vendor_profile_id', $vendor->id)->distinct('order_id')->count('order_id');

        $pendingCount = OrderItem::where('vendor_profile_id', $vendor->id)
            ->where('status', 'pending')->distinct('order_id')->count('order_id');

        // Chart data - last 30 days
        $chartData = OrderItem::where('vendor_profile_id', $vendor->id)
            ->whereHas('order', fn($q) => $q->where('payment_status','paid')->where('created_at', '>=', now()->subDays(30)))
            ->select(DB::raw('DATE(created_at) as date'), DB::raw('SUM(subtotal) as total'))
            ->groupBy('date')
            ->orderBy('date')
            ->pluck('total', 'date');

        $labels  = collect(range(29, 0))->map(fn($i) => now()->subDays($i)->format('M d'))->values();
        $sales   = collect(range(29, 0))->map(fn($i) => $chartData[now()->subDays($i)->format('Y-m-d')] ?? 0)->values();

        // Recent orders
        $recentOrders = Order::whereHas('items', fn($q) => $q->where('vendor_profile_id', $vendor->id))
            ->with(['items' => fn($q) => $q->where('vendor_profile_id', $vendor->id)])
            ->latest()->take(8)->get()
            ->map(fn($o) => [
                'id'           => $o->id,
                'order_number' => $o->order_number,
                'status'       => $o->status,
                'items_count'  => $o->items->sum('quantity'),
                'vendor_total' => $o->items->sum('subtotal'),
            ]);

        // Top products
        $topProducts = Product::where('vendor_profile_id', $vendor->id)
            ->withCount('reviews')
            ->withSum(['orderItems as revenue' => fn($q) => $q->whereHas('order', fn($oq) => $oq->where('payment_status','paid'))], 'subtotal')
            ->orderByDesc('revenue')
            ->take(5)->get();

        return Inertia::render('Vendor/Dashboard', [
            'stats' => [
                'revenue'       => $revenue,
                'revenueChange' => 12,
                'orders'        => $orders,
                'ordersChange'  => 8,
                'products'      => $vendor->products()->count(),
                'balance'       => $vendor->balance,
            ],
            'vendorProfile'     => $vendor->only(['store_name','status','is_verified']),
            'recentOrders'      => $recentOrders,
            'topProducts'       => $topProducts,
            'pendingOrdersCount'=> $pendingCount,
            'chartLabels'       => $labels,
            'chartSales'        => $sales,
        ]);
    }
}

KODA_FILE_F4BBEE18

# --- app/Http/Controllers/Vendor/EarningsController.php ---
mkdir -p "app/Http/Controllers/Vendor"
cat > "app/Http/Controllers/Vendor/EarningsController.php" << 'KODA_FILE_C61C2A12'
<?php

namespace App\Http\Controllers\Vendor;

use App\Http\Controllers\Controller;
use App\Models\OrderItem;
use App\Models\VendorProfile;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class EarningsController extends Controller
{
    private function vendor(): VendorProfile
    {
        return auth()->user()->vendorProfile;
    }

    public function index()
    {
        $vendor = $this->vendor();

        $paidItems = OrderItem::where('vendor_profile_id', $vendor->id)
            ->whereHas('order', fn($q) => $q->where('payment_status', 'paid'));

        $totalGross = (clone $paidItems)->sum('subtotal');
        $commission = round($totalGross * ($vendor->commission_rate / 100), 2);
        $net        = $totalGross - $commission;

        // Chart: last 30 days
        $chartData = (clone $paidItems)
            ->where('order_items.created_at', '>=', now()->subDays(30))
            ->select(DB::raw('DATE(order_items.created_at) as date'), DB::raw('SUM(subtotal) as gross'))
            ->groupBy('date')
            ->orderBy('date')
            ->pluck('gross', 'date');

        $labels   = collect(range(29, 0))->map(fn($i) => now()->subDays($i)->format('M d'))->values();
        $gross    = collect(range(29, 0))->map(fn($i) => (float)($chartData[now()->subDays($i)->format('Y-m-d')] ?? 0))->values();
        $netChart = $gross->map(fn($v) => round($v * (1 - $vendor->commission_rate / 100), 2));

        // Transactions
        $transactions = (clone $paidItems)
            ->with('order')
            ->latest('order_items.created_at')
            ->take(50)
            ->get()
            ->map(fn($item) => [
                'order_id'     => $item->order_id,
                'order_number' => $item->order->order_number,
                'date'         => $item->created_at->format('d M Y'),
                'items'        => $item->quantity,
                'gross'        => $item->subtotal,
                'commission'   => round($item->subtotal * $vendor->commission_rate / 100, 2),
                'net'          => round($item->subtotal * (1 - $vendor->commission_rate / 100), 2),
                'paid'         => true,
            ]);

        return Inertia::render('Vendor/Earnings', [
            'earnings' => [
                'total_gross'     => $totalGross,
                'commission'      => $commission,
                'commission_rate' => $vendor->commission_rate,
                'net'             => $net,
                'balance'         => $vendor->balance,
            ],
            'transactions' => $transactions,
            'chartLabels'  => $labels,
            'chartGross'   => $gross,
            'chartNet'     => $netChart,
        ]);
    }
}

KODA_FILE_C61C2A12

# --- app/Http/Controllers/Vendor/OrderController.php ---
mkdir -p "app/Http/Controllers/Vendor"
cat > "app/Http/Controllers/Vendor/OrderController.php" << 'KODA_FILE_0B431EDE'
<?php

namespace App\Http\Controllers\Vendor;

use App\Http\Controllers\Controller;
use App\Models\Order;
use App\Models\OrderItem;
use Illuminate\Http\Request;
use Inertia\Inertia;

class OrderController extends Controller
{
    private function vendor() { return auth()->user()->vendorProfile; }

    public function index(Request $request)
    {
        $query = Order::whereHas('items', fn($q) => $q->where('vendor_profile_id', $this->vendor()->id))
            ->with(['buyer', 'items' => fn($q) => $q->where('vendor_profile_id', $this->vendor()->id)->with('product')])
            ->latest();

        if ($request->filled('status')) {
            $query->where('status', $request->status);
        }

        $orders = $query->paginate(20)->withQueryString();

        $orders->getCollection()->transform(function ($order) {
            $order->vendor_total    = $order->items->sum('subtotal');
            $order->items_count     = $order->items->sum('quantity');
            return $order;
        });

        return Inertia::render('Vendor/Orders/Index', [
            'orders'  => $orders,
            'filters' => $request->only(['status']),
        ]);
    }

    public function show(Order $order)
    {
        $vendorId = $this->vendor()->id;
        abort_unless(
            $order->items()->where('vendor_profile_id', $vendorId)->exists(),
            403
        );

        $order->load([
            'buyer',
            'items' => fn($q) => $q->where('vendor_profile_id', $vendorId)->with('product'),
        ]);

        return Inertia::render('Vendor/Orders/Show', ['order' => $order]);
    }

    public function updateItemStatus(Request $request, OrderItem $item)
    {
        abort_unless($item->vendor_profile_id === $this->vendor()->id, 403);

        $request->validate(['status' => 'required|in:pending,processing,shipped,delivered,cancelled']);

        $item->update(['status' => $request->status]);

        return back()->with('success', 'Order status updated.');
    }
}

KODA_FILE_0B431EDE

# --- app/Http/Controllers/Vendor/PayoutController.php ---
mkdir -p "app/Http/Controllers/Vendor"
cat > "app/Http/Controllers/Vendor/PayoutController.php" << 'KODA_FILE_538D3700'
<?php

namespace App\Http\Controllers\Vendor;

use App\Http\Controllers\Controller;
use App\Models\VendorProfile;
use Illuminate\Http\Request;
use Inertia\Inertia;

class PayoutController extends Controller
{
    private function vendor(): VendorProfile
    {
        return auth()->user()->vendorProfile;
    }

    public function index()
    {
        $vendor = $this->vendor();

        return Inertia::render('Vendor/Payouts', [
            'balance' => (float) $vendor->balance,
            'payouts' => [], // Phase 2: add payouts table and model
        ]);
    }

    public function store(Request $request)
    {
        $vendor = $this->vendor();

        $request->validate([
            'amount'  => 'required|numeric|min:500|max:' . $vendor->balance,
            'method'  => 'required|in:mpesa,bank,airtel',
            'account' => 'required|string|max:50',
        ]);

        // Deduct from balance
        $vendor->decrement('balance', $request->amount);

        // Phase 2: Create a Payout record and notify admin

        return back()->with('success', 'Payout request submitted! Processing within 1–3 business days.');
    }
}

KODA_FILE_538D3700

# --- app/Http/Controllers/Vendor/ProductController.php ---
mkdir -p "app/Http/Controllers/Vendor"
cat > "app/Http/Controllers/Vendor/ProductController.php" << 'KODA_FILE_899D8F85'
<?php

namespace App\Http\Controllers\Vendor;

use App\Http\Controllers\Controller;
use App\Models\Category;
use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Inertia\Inertia;

class ProductController extends Controller
{
    private function vendor()
    {
        return auth()->user()->vendorProfile;
    }

    public function index(Request $request)
    {
        $products = Product::where('vendor_profile_id', $this->vendor()->id)
            ->with('category')
            ->withCount(['orderItems as orders_count'])
            ->latest()
            ->paginate(20);

        return Inertia::render('Vendor/Products/Index', ['products' => $products]);
    }

    public function create()
    {
        return Inertia::render('Vendor/Products/Form', [
            'categories' => Category::all(['id','name']),
        ]);
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'name'              => 'required|string|max:255',
            'description'       => 'required|string',
            'short_description' => 'nullable|string|max:300',
            'price'             => 'required|numeric|min:0',
            'compare_price'     => 'nullable|numeric|min:0',
            'stock'             => 'required|integer|min:0',
            'sku'               => 'nullable|string|unique:products',
            'category_id'       => 'required|exists:categories,id',
            'status'            => 'required|in:draft,active,inactive',
            'is_featured'       => 'boolean',
            'thumbnail'         => 'nullable|image|max:5120',
        ]);

        $data['vendor_profile_id'] = $this->vendor()->id;

        if ($request->hasFile('thumbnail')) {
            $data['thumbnail'] = $request->file('thumbnail')->store('products', 'public');
        }

        $product = Product::create($data);

        return redirect()->route('vendor.products.index')
            ->with('success', 'Product created successfully!');
    }

    public function edit(Product $product)
    {
        abort_unless($product->vendor_profile_id === $this->vendor()->id, 403);

        return Inertia::render('Vendor/Products/Form', [
            'product'    => $product->load('images'),
            'categories' => Category::all(['id','name']),
        ]);
    }

    public function update(Request $request, Product $product)
    {
        abort_unless($product->vendor_profile_id === $this->vendor()->id, 403);

        $data = $request->validate([
            'name'              => 'required|string|max:255',
            'description'       => 'required|string',
            'short_description' => 'nullable|string|max:300',
            'price'             => 'required|numeric|min:0',
            'compare_price'     => 'nullable|numeric|min:0',
            'stock'             => 'required|integer|min:0',
            'sku'               => 'nullable|string|unique:products,sku,' . $product->id,
            'category_id'       => 'required|exists:categories,id',
            'status'            => 'required|in:draft,active,inactive',
            'is_featured'       => 'boolean',
            'thumbnail'         => 'nullable|image|max:5120',
        ]);

        if ($request->hasFile('thumbnail')) {
            if ($product->thumbnail) {
                Storage::disk('public')->delete($product->thumbnail);
            }
            $data['thumbnail'] = $request->file('thumbnail')->store('products', 'public');
        }

        $product->update($data);

        return redirect()->route('vendor.products.index')
            ->with('success', 'Product updated successfully!');
    }

    public function updateStatus(Request $request, Product $product)
    {
        abort_unless($product->vendor_profile_id === $this->vendor()->id, 403);
        $request->validate(['status' => 'required|in:draft,active,inactive']);
        $product->update(['status' => $request->status]);
        return back()->with('success', 'Status updated.');
    }

    public function destroy(Product $product)
    {
        abort_unless($product->vendor_profile_id === $this->vendor()->id, 403);

        if ($product->thumbnail) {
            Storage::disk('public')->delete($product->thumbnail);
        }

        $product->delete();

        return back()->with('success', 'Product deleted.');
    }
}

KODA_FILE_899D8F85

# --- app/Http/Controllers/Vendor/ProfileController.php ---
mkdir -p "app/Http/Controllers/Vendor"
cat > "app/Http/Controllers/Vendor/ProfileController.php" << 'KODA_FILE_DDB15519'
<?php

namespace App\Http\Controllers\Vendor;

use App\Http\Controllers\Controller;
use App\Models\VendorProfile;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Inertia\Inertia;

class ProfileController extends Controller
{
    private function vendor(): VendorProfile
    {
        return auth()->user()->vendorProfile;
    }

    public function edit()
    {
        return Inertia::render('Vendor/Profile', ['vendor' => $this->vendor()]);
    }

    public function update(Request $request)
    {
        $vendor = $this->vendor();

        $data = $request->validate([
            'store_name'  => 'required|string|max:100|unique:vendor_profiles,store_name,' . $vendor->id,
            'description' => 'nullable|string|max:1000',
            'phone'       => 'nullable|string|max:20',
            'address'     => 'nullable|string|max:255',
            'city'        => 'nullable|string|max:100',
            'country'     => 'nullable|string|size:2',
            'logo'        => 'nullable|image|max:2048',
            'banner'      => 'nullable|image|max:5120',
        ]);

        if ($request->hasFile('logo')) {
            if ($vendor->logo) Storage::disk('public')->delete($vendor->logo);
            $data['logo'] = $request->file('logo')->store('vendors/logos', 'public');
        } else {
            unset($data['logo']);
        }

        if ($request->hasFile('banner')) {
            if ($vendor->banner) Storage::disk('public')->delete($vendor->banner);
            $data['banner'] = $request->file('banner')->store('vendors/banners', 'public');
        } else {
            unset($data['banner']);
        }

        $vendor->update($data);

        return back()->with('success', 'Storefront updated successfully!');
    }
}

KODA_FILE_DDB15519

# --- app/Http/Controllers/Vendor/ReviewController.php ---
mkdir -p "app/Http/Controllers/Vendor"
cat > "app/Http/Controllers/Vendor/ReviewController.php" << 'KODA_FILE_429F1B84'
<?php

namespace App\Http\Controllers\Vendor;

use App\Http\Controllers\Controller;
use App\Models\Review;
use App\Models\VendorProfile;
use Inertia\Inertia;

class ReviewController extends Controller
{
    private function vendor(): VendorProfile
    {
        return auth()->user()->vendorProfile;
    }

    public function index()
    {
        $vendor = $this->vendor();

        $baseQuery = Review::whereHas('product', fn($q) => $q->where('vendor_profile_id', $vendor->id));

        $approved = (clone $baseQuery)->where('approved', true);
        $pending  = (clone $baseQuery)->where('approved', false)->count();

        // Star breakdown
        $breakdown = [];
        for ($i = 1; $i <= 5; $i++) {
            $breakdown[$i] = (clone $approved)->where('rating', $i)->count();
        }

        $reviews = (clone $approved)
            ->with(['user', 'product'])
            ->latest()
            ->paginate(20);

        $reviews->getCollection()->transform(fn($r) => [
            ...$r->toArray(),
            'created_at_human' => $r->created_at->diffForHumans(),
            'user'    => $r->user?->only(['name']),
            'product' => $r->product?->only(['name', 'slug']),
        ]);

        return Inertia::render('Vendor/Reviews', [
            'reviews'     => $reviews->items(),
            'reviewsMeta' => ['links' => $reviews->toArray()['links']],
            'summary'     => [
                'total'      => $approved->count(),
                'avg_rating' => round($approved->avg('rating') ?? 0, 1),
                'five_star'  => $breakdown[5] ?? 0,
                'pending'    => $pending,
                'breakdown'  => $breakdown,
            ],
        ]);
    }
}

KODA_FILE_429F1B84

# --- app/Http/Controllers/VendorController.php ---
mkdir -p "app/Http/Controllers"
cat > "app/Http/Controllers/VendorController.php" << 'KODA_FILE_2146E541'
<?php

namespace App\Http\Controllers;

use App\Models\VendorProfile;
use Illuminate\Http\Request;
use Inertia\Inertia;

class VendorController extends Controller
{
    public function index(Request $request)
    {
        $vendors = VendorProfile::where('status', 'active')
            ->withCount('products')
            ->when($request->q, fn($q) => $q->where('store_name', 'like', "%{$request->q}%"))
            ->latest()
            ->paginate(16)
            ->withQueryString();

        return Inertia::render('Public/Vendors/Index', [
            'vendors' => $vendors,
            'filters' => $request->only(['q']),
        ]);
    }

    public function show(VendorProfile $vendor)
    {
        abort_unless($vendor->status === 'active', 404);

        $vendor->load(['products' => fn($q) => $q->active()->with('category')->latest()]);

        return Inertia::render('Public/Vendors/Show', [
            'vendor'   => $vendor,
            'products' => $vendor->products,
        ]);
    }

    public function applyForm()
    {
        if (auth()->check() && auth()->user()->vendorProfile) {
            return redirect()->route('vendor.dashboard');
        }
        return Inertia::render('Public/Vendors/Apply');
    }

    public function applyStore(Request $request)
    {
        $request->validate([
            'store_name'  => 'required|string|max:100|unique:vendor_profiles',
            'description' => 'required|string|min:20',
            'phone'       => 'required|string',
            'address'     => 'required|string',
            'city'        => 'required|string',
        ]);

        if (!auth()->check()) {
            return redirect()->route('register');
        }

        $user = auth()->user();

        $vendor = VendorProfile::create([
            'user_id'     => $user->id,
            'store_name'  => $request->store_name,
            'slug'        => \Illuminate\Support\Str::slug($request->store_name),
            'description' => $request->description,
            'phone'       => $request->phone,
            'address'     => $request->address,
            'city'        => $request->city,
            'status'      => 'pending',
        ]);

        $user->assignRole('vendor');

        return redirect()->route('vendor.dashboard')
            ->with('success', 'Application submitted! We\'ll review it within 24 hours.');
    }
}

KODA_FILE_2146E541

# --- app/Http/Controllers/WishlistController.php ---
mkdir -p "app/Http/Controllers"
cat > "app/Http/Controllers/WishlistController.php" << 'KODA_FILE_AC2A8648'
<?php

namespace App\Http\Controllers;

use App\Models\Wishlist;
use Illuminate\Http\Request;
use Inertia\Inertia;

class WishlistController extends Controller
{
    public function __construct() { $this->middleware('auth'); }

    public function index()
    {
        $items = Wishlist::where('user_id', auth()->id())
            ->with(['product.vendor', 'product.category'])
            ->latest()->get();

        return Inertia::render('Buyer/Wishlist', ['items' => $items]);
    }

    public function toggle(Request $request)
    {
        $request->validate(['product_id' => 'required|exists:products,id']);

        $existing = Wishlist::where('user_id', auth()->id())
            ->where('product_id', $request->product_id)->first();

        if ($existing) {
            $existing->delete();
            $action = 'removed';
        } else {
            Wishlist::create(['user_id' => auth()->id(), 'product_id' => $request->product_id]);
            $action = 'added';
        }

        return back()->with('success', "Item {$action} " . ($action === 'added' ? 'to' : 'from') . ' wishlist.');
    }
}

KODA_FILE_AC2A8648

# --- app/Http/Middleware/EnsureVendorIsActive.php ---
mkdir -p "app/Http/Middleware"
cat > "app/Http/Middleware/EnsureVendorIsActive.php" << 'KODA_FILE_1A073CAE'
<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class EnsureVendorIsActive
{
    public function handle(Request $request, Closure $next)
    {
        $user = $request->user();

        if (!$user || !$user->hasRole('vendor')) {
            return redirect()->route('vendor.apply');
        }

        $vendor = $user->vendorProfile;

        if (!$vendor) {
            return redirect()->route('vendor.apply')
                ->with('info', 'Please complete your vendor application.');
        }

        if ($vendor->status === 'pending') {
            return redirect()->route('home')
                ->with('info', 'Your vendor application is pending review.');
        }

        if ($vendor->status === 'rejected') {
            return redirect()->route('home')
                ->with('error', 'Your vendor application was rejected: ' . $vendor->rejection_reason);
        }

        if ($vendor->status === 'suspended') {
            return redirect()->route('home')
                ->with('error', 'Your vendor account has been suspended. Contact support.');
        }

        return $next($request);
    }
}

KODA_FILE_1A073CAE

# --- app/Http/Middleware/HandleInertiaRequests.php ---
mkdir -p "app/Http/Middleware"
cat > "app/Http/Middleware/HandleInertiaRequests.php" << 'KODA_FILE_53AD7D90'
<?php

namespace App\Http\Middleware;

use App\Models\Cart;
use Illuminate\Http\Request;
use Inertia\Middleware;
use Tighten\Ziggy\Ziggy;

class HandleInertiaRequests extends Middleware
{
    protected $rootView = 'app';

    public function version(Request $request): ?string
    {
        return parent::version($request);
    }

    public function share(Request $request): array
    {
        $user     = $request->user();
        $cartCount = 0;

        if ($user) {
            $cart = Cart::where('user_id', $user->id)->withCount('items')->first();
            $cartCount = $cart?->items_count ?? 0;
        } else {
            $cart = Cart::where('session_id', session()->getId())->withCount('items')->first();
            $cartCount = $cart?->items_count ?? 0;
        }

        return [
            ...parent::share($request),

            'auth' => [
                'user' => $user ? [
                    'id'    => $user->id,
                    'name'  => $user->name,
                    'email' => $user->email,
                    'roles' => $user->getRoleNames(),
                ] : null,
            ],

            'flash' => [
                'success' => $request->session()->get('success'),
                'error'   => $request->session()->get('error'),
                'info'    => $request->session()->get('info'),
            ],

            'cartCount' => $cartCount,

            'unreadNotifications' => $user
                ? $user->unreadNotifications()->count()
                : 0,

            'ziggy' => fn () => [
                ...(new Ziggy)->toArray(),
                'location' => $request->url(),
            ],
        ];
    }
}

KODA_FILE_53AD7D90

# --- app/Http/Requests/Auth/LoginRequest.php ---
mkdir -p "app/Http/Requests/Auth"
cat > "app/Http/Requests/Auth/LoginRequest.php" << 'KODA_FILE_07814D6F'
<?php

namespace App\Http\Requests\Auth;

use Illuminate\Auth\Events\Lockout;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\RateLimiter;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;

class LoginRequest extends FormRequest
{
    public function authorize(): bool { return true; }

    public function rules(): array
    {
        return [
            'email'    => ['required', 'string', 'email'],
            'password' => ['required', 'string'],
        ];
    }

    public function authenticate(): void
    {
        $this->ensureIsNotRateLimited();

        if (!Auth::attempt($this->only('email', 'password'), $this->boolean('remember'))) {
            RateLimiter::hit($this->throttleKey());
            throw ValidationException::withMessages([
                'email' => trans('auth.failed'),
            ]);
        }

        RateLimiter::clear($this->throttleKey());
    }

    public function ensureIsNotRateLimited(): void
    {
        if (!RateLimiter::tooManyAttempts($this->throttleKey(), 5)) return;

        event(new Lockout($this));

        $seconds = RateLimiter::availableIn($this->throttleKey());
        throw ValidationException::withMessages([
            'email' => trans('auth.throttle', ['seconds' => $seconds, 'minutes' => ceil($seconds / 60)]),
        ]);
    }

    public function throttleKey(): string
    {
        return Str::transliterate(Str::lower($this->string('email')) . '|' . $this->ip());
    }
}

KODA_FILE_07814D6F

# --- app/Models/Cart.php ---
mkdir -p "app/Models"
cat > "app/Models/Cart.php" << 'KODA_FILE_E20C1CDF'
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Cart extends Model
{
    protected $fillable = ['user_id', 'session_id'];

    public function user()  { return $this->belongsTo(User::class); }
    public function items() { return $this->hasMany(CartItem::class); }

    public function getTotalAttribute(): float
    {
        return $this->items->sum(fn($i) => $i->quantity * ($i->product->price ?? 0));
    }
}

KODA_FILE_E20C1CDF

# --- app/Models/CartItem.php ---
mkdir -p "app/Models"
cat > "app/Models/CartItem.php" << 'KODA_FILE_24493400'
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class CartItem extends Model
{
    protected $fillable = ['cart_id', 'product_id', 'quantity'];

    public function cart()    { return $this->belongsTo(Cart::class); }
    public function product() { return $this->belongsTo(Product::class); }

    public function getSubtotalAttribute(): float
    {
        return $this->quantity * ($this->product->price ?? 0);
    }
}

KODA_FILE_24493400

# --- app/Models/Category.php ---
mkdir -p "app/Models"
cat > "app/Models/Category.php" << 'KODA_FILE_8339B5B7'
<?php namespace App\Models;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class Category extends Model {
    protected $fillable = ['name','slug','icon','description','parent_id'];
    protected static function boot() {
        parent::boot();
        static::creating(fn($c) => $c->slug = $c->slug ?? Str::slug($c->name));
    }
    public function products()      { return $this->hasMany(Product::class); }
    public function getRouteKeyName(): string { return 'slug'; }
    public function getProductsCountAttribute(): int { return $this->products()->where('status','active')->count(); }
}

KODA_FILE_8339B5B7

# --- app/Models/Order.php ---
mkdir -p "app/Models"
cat > "app/Models/Order.php" << 'KODA_FILE_899B6DA7'
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class Order extends Model
{
    use HasFactory;

    protected $fillable = [
        'buyer_id', 'order_number', 'status', 'payment_status',
        'payment_method', 'payment_intent_id',
        'subtotal', 'discount', 'shipping', 'total',
        'shipping_name', 'shipping_email', 'shipping_phone',
        'shipping_address', 'shipping_city', 'shipping_country',
        'promo_code_id', 'notes',
    ];

    protected $casts = [
        'subtotal' => 'decimal:2',
        'discount' => 'decimal:2',
        'shipping' => 'decimal:2',
        'total'    => 'decimal:2',
    ];

    protected static function boot()
    {
        parent::boot();
        static::creating(function ($order) {
            $order->order_number = $order->order_number ?? strtoupper('KDA-' . Str::random(8));
        });
    }

    public function buyer()     { return $this->belongsTo(User::class, 'buyer_id'); }
    public function items()     { return $this->hasMany(OrderItem::class); }
    public function promoCode() { return $this->belongsTo(PromoCode::class); }

    public function getCreatedAtHumanAttribute(): string
    {
        return $this->created_at->diffForHumans();
    }

    public function getItemsCountAttribute(): int
    {
        return $this->items()->sum('quantity');
    }
}

KODA_FILE_899B6DA7

# --- app/Models/OrderItem.php ---
mkdir -p "app/Models"
cat > "app/Models/OrderItem.php" << 'KODA_FILE_5A2B1AAD'
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class OrderItem extends Model
{
    protected $fillable = [
        'order_id', 'product_id', 'vendor_profile_id',
        'quantity', 'unit_price', 'subtotal', 'status',
    ];

    protected $casts = [
        'unit_price' => 'decimal:2',
        'subtotal'   => 'decimal:2',
    ];

    public function order()   { return $this->belongsTo(Order::class); }
    public function product() { return $this->belongsTo(Product::class); }
    public function vendor()  { return $this->belongsTo(VendorProfile::class, 'vendor_profile_id'); }
}

KODA_FILE_5A2B1AAD

# --- app/Models/Product.php ---
mkdir -p "app/Models"
cat > "app/Models/Product.php" << 'KODA_FILE_E2311E15'
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class Product extends Model
{
    use HasFactory;

    protected $fillable = [
        'vendor_profile_id', 'category_id',
        'name', 'slug', 'description', 'short_description',
        'price', 'compare_price', 'stock', 'sku',
        'thumbnail', 'status', 'is_featured',
    ];

    protected $casts = [
        'is_featured' => 'boolean',
        'price'       => 'decimal:2',
        'compare_price' => 'decimal:2',
    ];

    protected static function boot()
    {
        parent::boot();
        static::creating(function ($product) {
            $product->slug = $product->slug ?? Str::slug($product->name) . '-' . Str::random(4);
            $product->sku  = $product->sku  ?? strtoupper(Str::random(8));
        });
    }

    // ── Relationships ────────────────────────────────────
    public function vendor()   { return $this->belongsTo(VendorProfile::class, 'vendor_profile_id'); }
    public function category() { return $this->belongsTo(Category::class); }
    public function images()   { return $this->hasMany(ProductImage::class); }
    public function reviews()  { return $this->hasMany(Review::class)->where('approved', true); }

    // ── Accessors ────────────────────────────────────────
    public function getAvgRatingAttribute(): float
    {
        return round($this->reviews()->avg('rating') ?? 0, 1);
    }

    public function getReviewsCountAttribute(): int
    {
        return $this->reviews()->count();
    }

    public function getRouteKeyName(): string { return 'slug'; }

    // ── Scopes ───────────────────────────────────────────
    public function scopeActive($q)    { return $q->where('status', 'active'); }
    public function scopeFeatured($q)  { return $q->where('is_featured', true); }
}

KODA_FILE_E2311E15

# --- app/Models/ProductImage.php ---
mkdir -p "app/Models"
cat > "app/Models/ProductImage.php" << 'KODA_FILE_3E6B0183'
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ProductImage extends Model
{
    protected $fillable = ['product_id', 'url', 'order'];

    public function product() { return $this->belongsTo(Product::class); }
}

KODA_FILE_3E6B0183

# --- app/Models/PromoCode.php ---
mkdir -p "app/Models"
cat > "app/Models/PromoCode.php" << 'KODA_FILE_FBA1F972'
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class PromoCode extends Model
{
    protected $fillable = [
        'code', 'type', 'value', 'max_uses', 'uses', 'expires_at', 'is_active',
    ];

    protected $casts = [
        'is_active'  => 'boolean',
        'expires_at' => 'datetime',
        'value'      => 'decimal:2',
    ];

    public function isValid(): bool
    {
        return $this->is_active
            && ($this->max_uses === null || $this->uses < $this->max_uses)
            && ($this->expires_at === null || $this->expires_at->isFuture());
    }
}

KODA_FILE_FBA1F972

# --- app/Models/Review.php ---
mkdir -p "app/Models"
cat > "app/Models/Review.php" << 'KODA_FILE_6A43F180'
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Review extends Model
{
    protected $fillable = ['user_id', 'product_id', 'rating', 'comment', 'approved'];

    protected $casts = ['approved' => 'boolean'];

    public function user()    { return $this->belongsTo(User::class); }
    public function product() { return $this->belongsTo(Product::class); }

    public function getCreatedAtHumanAttribute(): string
    {
        return $this->created_at->diffForHumans();
    }
}

KODA_FILE_6A43F180

# --- app/Models/User.php ---
mkdir -p "app/Models"
cat > "app/Models/User.php" << 'KODA_FILE_D36E1A71'
<?php

namespace App\Models;

use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Spatie\Permission\Traits\HasRoles;

class User extends Authenticatable implements MustVerifyEmail
{
    use HasFactory, Notifiable, HasRoles;

    protected $fillable = [
        'name',
        'email',
        'password',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected $appends = ['roles_list'];

    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password'          => 'hashed',
        ];
    }

    // ── Relationships ────────────────────────────────────
    public function vendorProfile()
    {
        return $this->hasOne(VendorProfile::class);
    }

    public function orders()
    {
        return $this->hasMany(Order::class, 'buyer_id');
    }

    public function reviews()
    {
        return $this->hasMany(Review::class);
    }

    public function cart()
    {
        return $this->hasOne(Cart::class);
    }

    public function wishlistItems()
    {
        return $this->hasMany(Wishlist::class);
    }

    // ── Accessors ────────────────────────────────────────
    public function getRolesListAttribute(): array
    {
        return $this->roles->pluck('name')->toArray();
    }

    // ── Helpers ──────────────────────────────────────────
    public function isAdmin(): bool
    {
        return $this->hasRole('admin');
    }

    public function isVendor(): bool
    {
        return $this->hasRole('vendor');
    }

    public function isBuyer(): bool
    {
        return $this->hasRole('buyer');
    }
}

KODA_FILE_D36E1A71

# --- app/Models/VendorProfile.php ---
mkdir -p "app/Models"
cat > "app/Models/VendorProfile.php" << 'KODA_FILE_DF0A5742'
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class VendorProfile extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id', 'store_name', 'slug', 'description',
        'logo', 'banner', 'phone', 'address', 'city', 'country',
        'status', 'rejection_reason', 'is_verified', 'commission_rate', 'balance',
    ];

    protected $casts = ['is_verified' => 'boolean'];

    // ── Relationships ────────────────────────────────────
    public function user()       { return $this->belongsTo(User::class); }
    public function products()   { return $this->hasMany(Product::class); }
    public function orderItems() { return $this->hasMany(OrderItem::class); }

    /** Revenue-bearing order items (paid orders only) — used for withSum() */
    public function orderItemRevenue()
    {
        return $this->hasMany(OrderItem::class)
            ->whereHas('order', fn($q) => $q->where('payment_status', 'paid'));
    }

    /** All orders that contain this vendor's items */
    public function orders()
    {
        return $this->hasManyThrough(
            Order::class,
            OrderItem::class,
            'vendor_profile_id',
            'id',
            'id',
            'order_id'
        );
    }

    public function reviews()
    {
        return $this->hasManyThrough(Review::class, Product::class);
    }

    // ── Accessors ────────────────────────────────────────
    public function getAvgRatingAttribute(): float
    {
        return round($this->reviews()->avg('rating') ?? 0, 1);
    }

    public function getProductsCountAttribute(): int
    {
        return $this->products()->where('status', 'active')->count();
    }

    public function getMemberSinceAttribute(): string
    {
        return $this->created_at->format('M Y');
    }

    public function getRouteKeyName(): string { return 'slug'; }
}


KODA_FILE_DF0A5742

# --- app/Models/Wishlist.php ---
mkdir -p "app/Models"
cat > "app/Models/Wishlist.php" << 'KODA_FILE_C924AB05'
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Wishlist extends Model
{
    protected $fillable = ['user_id', 'product_id'];

    public function user()    { return $this->belongsTo(User::class); }
    public function product() { return $this->belongsTo(Product::class); }
}

KODA_FILE_C924AB05

# --- app/Notifications/NewOrderNotification.php ---
mkdir -p "app/Notifications"
cat > "app/Notifications/NewOrderNotification.php" << 'KODA_FILE_5F25239B'
<?php

namespace App\Notifications;

use App\Models\Order;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;

class NewOrderNotification extends Notification implements ShouldQueue
{
    use Queueable;

    public function __construct(public readonly Order $order) {}

    public function via(object $notifiable): array
    {
        return ['database', 'mail'];
    }

    public function toMail(object $notifiable): MailMessage
    {
        return (new MailMessage)
            ->subject("New Order #{$this->order->order_number} — Koda")
            ->greeting("Hello, {$notifiable->name}!")
            ->line("You have a new order on your Koda store.")
            ->line("Order #{$this->order->order_number} — Total: KES " . number_format($this->order->total, 2))
            ->action('View Order', route('vendor.orders.show', $this->order->id))
            ->line('Please process this order promptly.');
    }

    public function toArray(object $notifiable): array
    {
        return [
            'type'         => 'new_order',
            'order_id'     => $this->order->id,
            'order_number' => $this->order->order_number,
            'total'        => $this->order->total,
            'message'      => "New order #{$this->order->order_number} received",
            'url'          => route('vendor.orders.show', $this->order->id),
        ];
    }
}

KODA_FILE_5F25239B

# --- app/Notifications/OrderConfirmedNotification.php ---
mkdir -p "app/Notifications"
cat > "app/Notifications/OrderConfirmedNotification.php" << 'KODA_FILE_A3ACF66D'
<?php

namespace App\Notifications;

use App\Models\Order;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;

class OrderConfirmedNotification extends Notification implements ShouldQueue
{
    use Queueable;

    public function __construct(public readonly Order $order) {}

    public function via(object $notifiable): array
    {
        return ['mail', 'database'];
    }

    public function toMail(object $notifiable): MailMessage
    {
        return (new MailMessage)
            ->subject("Order Confirmed — #{$this->order->order_number}")
            ->greeting("Thank you for your order, {$notifiable->name}!")
            ->line("We've received your order and it's being processed.")
            ->line("Order #{$this->order->order_number}")
            ->line("Total: KES " . number_format($this->order->total, 2))
            ->action('Track Your Order', route('orders.show', $this->order->id))
            ->line("We'll notify you when your order ships.");
    }

    public function toArray(object $notifiable): array
    {
        return [
            'type'         => 'order_confirmed',
            'order_id'     => $this->order->id,
            'order_number' => $this->order->order_number,
            'message'      => "Your order #{$this->order->order_number} is confirmed",
            'url'          => route('orders.show', $this->order->id),
        ];
    }
}

KODA_FILE_A3ACF66D

# --- app/Notifications/VendorApprovedNotification.php ---
mkdir -p "app/Notifications"
cat > "app/Notifications/VendorApprovedNotification.php" << 'KODA_FILE_839AFF07'
<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;

class VendorApprovedNotification extends Notification implements ShouldQueue
{
    use Queueable;

    public function via(object $notifiable): array
    {
        return ['mail', 'database'];
    }

    public function toMail(object $notifiable): MailMessage
    {
        return (new MailMessage)
            ->subject('Your Koda Vendor Application is Approved! 🎉')
            ->greeting("Congratulations, {$notifiable->name}!")
            ->line('Your vendor application has been reviewed and approved.')
            ->line('You can now log in and start listing your products on Koda.')
            ->action('Go to Vendor Dashboard', route('vendor.dashboard'))
            ->line('Welcome to the Koda seller community!');
    }

    public function toArray(object $notifiable): array
    {
        return [
            'type'    => 'vendor_approved',
            'message' => 'Your vendor application has been approved!',
            'url'     => route('vendor.dashboard'),
        ];
    }
}

KODA_FILE_839AFF07

# --- app/Observers/OrderObserver.php ---
mkdir -p "app/Observers"
cat > "app/Observers/OrderObserver.php" << 'KODA_FILE_8D390A81'
<?php

namespace App\Observers;

use App\Models\Order;
use App\Notifications\NewOrderNotification;

class OrderObserver
{
    public function created(Order $order): void
    {
        // Load items with vendor users
        $order->load('items.vendor.user');

        $vendorIds = $order->items->pluck('vendor_profile_id')->unique();

        foreach ($order->items->unique('vendor_profile_id') as $item) {
            $vendorUser = $item->vendor?->user;
            if ($vendorUser) {
                $vendorUser->notify(new NewOrderNotification($order));
            }
        }
    }
}

KODA_FILE_8D390A81

# --- app/Providers/AppServiceProvider.php ---
mkdir -p "app/Providers"
cat > "app/Providers/AppServiceProvider.php" << 'KODA_FILE_78B1250C'
<?php

namespace App\Providers;

use App\Models\Order;
use App\Observers\OrderObserver;
use Illuminate\Support\ServiceProvider;
use Illuminate\Validation\Rules\Password;

class AppServiceProvider extends ServiceProvider
{
    public function register(): void {}

    public function boot(): void
    {
        Password::defaults(function () {
            return Password::min(8);
        });

        Order::observe(OrderObserver::class);
    }
}

KODA_FILE_78B1250C

# --- artisan ---
mkdir -p "."
cat > "artisan" << 'KODA_FILE_8ED881EB'
#!/usr/bin/env php
<?php

use Symfony\Component\Console\Input\ArgvInput;

define('LARAVEL_START', microtime(true));

// Register the Composer autoloader...
require __DIR__.'/vendor/autoload.php';

$app = require_once __DIR__.'/bootstrap/app.php';

$status = $app->handleCommand(new ArgvInput);

exit($status);

KODA_FILE_8ED881EB

# --- bootstrap/app.php ---
mkdir -p "bootstrap"
cat > "bootstrap/app.php" << 'KODA_FILE_20325CB2'
<?php

use App\Http\Middleware\EnsureVendorIsActive;
use App\Http\Middleware\HandleInertiaRequests;
use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php',
        commands: __DIR__.'/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware) {
        $middleware->web(append: [
            HandleInertiaRequests::class,
            \Illuminate\Http\Middleware\AddLinkHeadersForPreloadedAssets::class,
        ]);

        $middleware->alias([
            'role'          => \Spatie\Permission\Middleware\RoleMiddleware::class,
            'permission'    => \Spatie\Permission\Middleware\PermissionMiddleware::class,
            'vendor.active' => EnsureVendorIsActive::class,
        ]);
    })
    ->withExceptions(function (Exceptions $exceptions) {
        //
    })->create();

KODA_FILE_20325CB2

# --- composer.json ---
mkdir -p "."
cat > "composer.json" << 'KODA_FILE_05EB3673'
{
    "name": "koda/marketplace",
    "type": "project",
    "description": "Koda — Your Professional Business Marketplace",
    "keywords": ["laravel", "marketplace", "multivendor", "b2b"],
    "license": "MIT",
    "require": {
        "php": "^8.3",
        "inertiajs/inertia-laravel": "^2.0",
        "laravel/framework": "^13.0",
        "laravel/tinker": "^2.9",
        "spatie/laravel-permission": "^6.9",
        "spatie/laravel-medialibrary": "^11.0",
        "laravel/scout": "^10.0",
        "barryvdh/laravel-dompdf": "^3.0",
        "stripe/stripe-php": "^15.0",
        "tightenco/ziggy": "^2.0"
    },
    "require-dev": {
        "fakerphp/faker": "^1.23",
        "laravel/breeze": "^2.0",
        "laravel/pint": "^1.13",
        "laravel/sail": "^1.26",
        "mockery/mockery": "^1.6",
        "nunomaduro/collision": "^8.0",
        "phpunit/phpunit": "^11.0",
        "laravel/telescope": "^5.0"
    },
    "autoload": {
        "psr-4": {
            "App\\": "app/",
            "Database\\Factories\\": "database/factories/",
            "Database\\Seeders\\": "database/seeders/"
        }
    },
    "autoload-dev": {
        "psr-4": {
            "Tests\\": "tests/"
        }
    },
    "scripts": {
        "post-autoload-dump": [
            "Illuminate\\Foundation\\ComposerScripts::postAutoloadDump",
            "@php artisan package:discover --ansi"
        ],
        "post-update-cmd": [
            "@php artisan vendor:publish --tag=laravel-assets --ansi --force"
        ],
        "post-root-package-install": [
            "@php -r \"file_exists('.env') || copy('.env.example', '.env');\""
        ],
        "post-create-project-cmd": [
            "@php artisan key:generate --ansi",
            "@php artisan migrate --graceful --ansi"
        ]
    },
    "extra": {
        "laravel": {
            "dont-discover": []
        }
    },
    "config": {
        "optimize-autoloader": true,
        "preferred-install": "dist",
        "sort-packages": true,
        "allow-plugins": {
            "pestphp/pest-plugin": true,
            "php-http/discovery": true
        }
    },
    "minimum-stability": "stable",
    "prefer-stable": true
}

KODA_FILE_05EB3673

# --- config/app.php ---
mkdir -p "config"
cat > "config/app.php" << 'KODA_FILE_205A4489'
<?php

return [
    'name'     => env('APP_NAME', 'Koda'),
    'env'      => env('APP_ENV', 'production'),
    'debug'    => (bool) env('APP_DEBUG', false),
    'url'      => env('APP_URL', 'http://localhost'),
    'timezone' => env('APP_TIMEZONE', 'Africa/Nairobi'),
    'locale'   => env('APP_LOCALE', 'en'),
    'fallback_locale' => env('APP_FALLBACK_LOCALE', 'en'),
    'faker_locale'    => env('APP_FAKER_LOCALE', 'en_US'),
    'cipher'   => 'AES-256-CBC',
    'key'      => env('APP_KEY'),
    'previous_keys' => array_filter(explode(',', env('APP_PREVIOUS_KEYS', ''))),
    'maintenance' => ['driver' => 'file'],
    'providers' => Illuminate\Support\ServiceProvider::defaultProviders()->merge([
        App\Providers\AppServiceProvider::class,
    ])->toArray(),
];

KODA_FILE_205A4489

# --- config/auth.php ---
mkdir -p "config"
cat > "config/auth.php" << 'KODA_FILE_79D3271B'
<?php

return [
    'defaults' => [
        'guard'     => env('AUTH_GUARD', 'web'),
        'passwords' => env('AUTH_PASSWORD_BROKER', 'users'),
    ],

    'guards' => [
        'web' => [
            'driver'   => 'session',
            'provider' => 'users',
        ],
    ],

    'providers' => [
        'users' => [
            'driver' => 'eloquent',
            'model'  => env('AUTH_MODEL', App\Models\User::class),
        ],
    ],

    'passwords' => [
        'users' => [
            'provider' => 'users',
            'table'    => env('AUTH_PASSWORD_RESET_TOKEN_TABLE', 'password_reset_tokens'),
            'expire'   => 60,
            'throttle' => 60,
        ],
    ],

    'password_timeout' => env('AUTH_PASSWORD_TIMEOUT', 10800),
];

KODA_FILE_79D3271B

# --- config/cache.php ---
mkdir -p "config"
cat > "config/cache.php" << 'KODA_FILE_36D8EADC'
<?php

use Illuminate\Support\Str;

return [
    'default' => env('CACHE_STORE', 'database'),
    'stores'  => [
        'database' => [
            'driver'     => 'database',
            'connection' => env('DB_CACHE_CONNECTION'),
            'table'      => env('DB_CACHE_TABLE', 'cache'),
            'lock_connection' => env('DB_CACHE_LOCK_CONNECTION'),
            'lock_table' => env('DB_CACHE_LOCK_TABLE'),
        ],
        'file'  => ['driver' => 'file', 'path' => storage_path('framework/cache/data'), 'lock_path' => storage_path('framework/cache/data')],
        'array' => ['driver' => 'array', 'serialize' => false],
        'redis' => [
            'driver'     => 'redis',
            'connection' => env('REDIS_CACHE_CONNECTION', 'cache'),
            'lock_connection' => env('REDIS_CACHE_LOCK_CONNECTION', 'default'),
        ],
    ],
    'prefix' => env('CACHE_PREFIX', Str::slug(env('APP_NAME', 'laravel'), '_').'_cache_'),
];

KODA_FILE_36D8EADC

# --- config/cors.php ---
mkdir -p "config"
cat > "config/cors.php" << 'KODA_FILE_F4E9F2F4'
<?php

return [
    'paths'                    => ['api/*', 'sanctum/csrf-cookie'],
    'allowed_methods'          => ['*'],
    'allowed_origins'          => [env('FRONTEND_URL', 'http://localhost:3000')],
    'allowed_origins_patterns' => [],
    'allowed_headers'          => ['*'],
    'exposed_headers'          => [],
    'max_age'                  => 0,
    'supports_credentials'     => true,
];

KODA_FILE_F4E9F2F4

# --- config/database.php ---
mkdir -p "config"
cat > "config/database.php" << 'KODA_FILE_EAF4CC4A'
<?php

return [
    'default' => env('DB_CONNECTION', 'mysql'),
    'connections' => [
        'mysql' => [
            'driver'    => 'mysql',
            'url'       => env('DB_URL'),
            'host'      => env('DB_HOST', '127.0.0.1'),
            'port'      => env('DB_PORT', '3306'),
            'database'  => env('DB_DATABASE', 'koda'),
            'username'  => env('DB_USERNAME', 'root'),
            'password'  => env('DB_PASSWORD', ''),
            'charset'   => env('DB_CHARSET', 'utf8mb4'),
            'collation' => env('DB_COLLATION', 'utf8mb4_unicode_ci'),
            'prefix'    => '',
            'strict'    => true,
            'engine'    => null,
        ],
        'sqlite' => [
            'driver'                  => 'sqlite',
            'url'                     => env('DB_URL'),
            'database'                => env('DB_DATABASE', database_path('database.sqlite')),
            'prefix'                  => '',
            'foreign_key_constraints' => env('DB_FOREIGN_KEYS', true),
        ],
        'pgsql' => [
            'driver'   => 'pgsql',
            'url'      => env('DB_URL'),
            'host'     => env('DB_HOST', '127.0.0.1'),
            'port'     => env('DB_PORT', '5432'),
            'database' => env('DB_DATABASE', 'koda'),
            'username' => env('DB_USERNAME', 'root'),
            'password' => env('DB_PASSWORD', ''),
            'charset'  => 'utf8',
            'prefix'   => '',
            'schema'   => 'public',
        ],
    ],
    'migrations' => [
        'table' => 'migrations',
        'update_date_on_publish' => true,
    ],
    'redis' => [
        'client' => env('REDIS_CLIENT', 'phpredis'),
        'default' => [
            'url'      => env('REDIS_URL'),
            'host'     => env('REDIS_HOST', '127.0.0.1'),
            'password' => env('REDIS_PASSWORD'),
            'port'     => env('REDIS_PORT', '6379'),
            'database' => env('REDIS_DB', '0'),
        ],
    ],
];

KODA_FILE_EAF4CC4A

# --- config/filesystems.php ---
mkdir -p "config"
cat > "config/filesystems.php" << 'KODA_FILE_B65478A6'
<?php

return [
    'default' => env('FILESYSTEM_DISK', 'local'),

    'disks' => [
        'local' => [
            'driver' => 'local',
            'root'   => storage_path('app/private'),
            'throw'  => false,
        ],
        'public' => [
            'driver'     => 'local',
            'root'       => storage_path('app/public'),
            'url'        => env('APP_URL').'/storage',
            'visibility' => 'public',
            'throw'      => false,
        ],
        's3' => [
            'driver'   => 's3',
            'key'      => env('AWS_ACCESS_KEY_ID'),
            'secret'   => env('AWS_SECRET_ACCESS_KEY'),
            'region'   => env('AWS_DEFAULT_REGION'),
            'bucket'   => env('AWS_BUCKET'),
            'url'      => env('AWS_URL'),
            'endpoint' => env('AWS_ENDPOINT'),
        ],
    ],

    'links' => [
        public_path('storage') => storage_path('app/public'),
    ],
];

KODA_FILE_B65478A6

# --- config/logging.php ---
mkdir -p "config"
cat > "config/logging.php" << 'KODA_FILE_BED684CC'
<?php

return [
    'default'  => env('LOG_CHANNEL', 'stack'),
    'deprecations' => [
        'channel' => env('LOG_DEPRECATIONS_CHANNEL', 'null'),
        'trace'   => env('LOG_DEPRECATIONS_TRACE', false),
    ],
    'channels' => [
        'stack'     => ['driver' => 'stack', 'channels' => explode(',', env('LOG_STACK', 'single')), 'ignore_exceptions' => false],
        'single'    => ['driver' => 'single', 'path' => storage_path('logs/laravel.log'), 'level' => env('LOG_LEVEL', 'debug'), 'replace_placeholders' => true],
        'daily'     => ['driver' => 'daily', 'path' => storage_path('logs/laravel.log'), 'level' => env('LOG_LEVEL', 'debug'), 'days' => env('LOG_DAILY_DAYS', 14), 'replace_placeholders' => true],
        'stderr'    => ['driver' => 'monolog', 'level' => env('LOG_LEVEL', 'debug'), 'handler' => Monolog\Handler\StreamHandler::class, 'formatter' => env('LOG_STDERR_FORMATTER'), 'with' => ['stream' => 'php://stderr'], 'processors' => [Illuminate\Log\Processors\InjectContextProcessor::class]],
        'null'      => ['driver' => 'monolog', 'handler' => Monolog\Handler\NullHandler::class],
    ],
];

KODA_FILE_BED684CC

# --- config/mail.php ---
mkdir -p "config"
cat > "config/mail.php" << 'KODA_FILE_9C3C2511'
<?php

return [
    'default' => env('MAIL_MAILER', 'log'),

    'mailers' => [
        'smtp' => [
            'transport'  => 'smtp',
            'scheme'     => env('MAIL_SCHEME'),
            'url'        => env('MAIL_URL'),
            'host'       => env('MAIL_HOST', '127.0.0.1'),
            'port'       => env('MAIL_PORT', 2525),
            'username'   => env('MAIL_USERNAME'),
            'password'   => env('MAIL_PASSWORD'),
            'timeout'    => null,
            'local_domain' => env('MAIL_EHLO_DOMAIN', parse_url(env('APP_URL', 'http://localhost'), PHP_URL_HOST)),
        ],
        'log' => [
            'transport' => 'log',
            'channel'   => env('MAIL_LOG_CHANNEL'),
        ],
        'array' => ['transport' => 'array'],
    ],

    'from' => [
        'address' => env('MAIL_FROM_ADDRESS', 'hello@koda.com'),
        'name'    => env('MAIL_FROM_NAME', 'Koda'),
    ],
];

KODA_FILE_9C3C2511

# --- config/permission.php ---
mkdir -p "config"
cat > "config/permission.php" << 'KODA_FILE_38A73E9C'
<?php

return [
    'models' => [
        'permission' => Spatie\Permission\Models\Permission::class,
        'role'       => Spatie\Permission\Models\Role::class,
    ],
    'table_names' => [
        'roles'                 => 'roles',
        'permissions'           => 'permissions',
        'model_has_permissions' => 'model_has_permissions',
        'model_has_roles'       => 'model_has_roles',
        'role_has_permissions'  => 'role_has_permissions',
    ],
    'column_names' => [
        'role_pivot_key'       => null,
        'permission_pivot_key' => null,
        'model_morph_key'      => 'model_id',
        'team_foreign_key'     => 'team_id',
    ],
    'register_permission_check_method' => true,
    'register_octane_reset_listener'   => false,
    'teams'                            => false,
    'use_passport_client_credentials'  => false,
    'display_permission_in_exception'  => false,
    'display_role_in_exception'        => false,
    'enable_wildcard_permission'       => false,
    'cache' => [
        'expiration_time'  => \DateInterval::createFromDateString('24 hours'),
        'key'              => 'spatie.permission.cache',
        'store'            => 'default',
    ],
];

KODA_FILE_38A73E9C

# --- config/queue.php ---
mkdir -p "config"
cat > "config/queue.php" << 'KODA_FILE_255D94BA'
<?php

return [
    'default'     => env('QUEUE_CONNECTION', 'database'),
    'connections' => [
        'sync'     => ['driver' => 'sync'],
        'database' => [
            'driver' => 'database',
            'connection' => env('DB_QUEUE_CONNECTION'),
            'table'  => env('DB_QUEUE_TABLE', 'jobs'),
            'queue'  => env('DB_QUEUE', 'default'),
            'retry_after' => (int) env('DB_QUEUE_RETRY_AFTER', 90),
            'after_commit' => false,
        ],
        'redis' => [
            'driver'      => 'redis',
            'connection'  => env('REDIS_QUEUE_CONNECTION', 'default'),
            'queue'       => env('REDIS_QUEUE', 'default'),
            'retry_after' => (int) env('REDIS_QUEUE_RETRY_AFTER', 90),
            'block_for'   => null,
            'after_commit' => false,
        ],
    ],
    'batching'  => ['database' => env('DB_CONNECTION', 'mysql'), 'table' => 'job_batches'],
    'failed'    => ['driver' => env('QUEUE_FAILED_DRIVER', 'database-uuids'), 'database' => env('DB_CONNECTION', 'mysql'), 'table' => 'failed_jobs'],
];

KODA_FILE_255D94BA

# --- config/session.php ---
mkdir -p "config"
cat > "config/session.php" << 'KODA_FILE_12E21352'
<?php

use Illuminate\Support\Str;

return [
    'driver'          => env('SESSION_DRIVER', 'database'),
    'lifetime'        => env('SESSION_LIFETIME', 120),
    'expire_on_close' => env('SESSION_EXPIRE_ON_CLOSE', false),
    'encrypt'         => env('SESSION_ENCRYPT', false),
    'files'           => storage_path('framework/sessions'),
    'connection'      => env('SESSION_CONNECTION'),
    'table'           => env('SESSION_TABLE', 'sessions'),
    'store'           => env('SESSION_STORE'),
    'lottery'         => [2, 100],
    'cookie'          => env('SESSION_COOKIE', Str::slug(env('APP_NAME', 'laravel'), '_').'_session'),
    'path'            => env('SESSION_PATH', '/'),
    'domain'          => env('SESSION_DOMAIN'),
    'secure'          => env('SESSION_SECURE_COOKIE'),
    'http_only'       => env('SESSION_HTTP_ONLY', true),
    'same_site'       => env('SESSION_SAME_SITE', 'lax'),
    'partitioned'     => env('SESSION_PARTITIONED_COOKIE', false),
];

KODA_FILE_12E21352

# --- database/factories/CategoryFactory.php ---
mkdir -p "database/factories"
cat > "database/factories/CategoryFactory.php" << 'KODA_FILE_1534295A'
<?php

namespace Database\Factories;

use App\Models\Category;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;

class CategoryFactory extends Factory
{
    protected $model = Category::class;

    public function definition(): array
    {
        $name = fake()->unique()->word();

        return [
            'name' => ucfirst($name),
            'slug' => Str::slug($name),
            'icon' => '📦',
        ];
    }
}

KODA_FILE_1534295A

# --- database/factories/ProductFactory.php ---
mkdir -p "database/factories"
cat > "database/factories/ProductFactory.php" << 'KODA_FILE_B3A4C515'
<?php

namespace Database\Factories;

use App\Models\Category;
use App\Models\Product;
use App\Models\VendorProfile;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;

class ProductFactory extends Factory
{
    protected $model = Product::class;

    public function definition(): array
    {
        $name = fake()->words(3, true);

        return [
            'vendor_profile_id' => VendorProfile::factory(),
            'category_id'       => Category::factory(),
            'name'              => ucwords($name),
            'slug'              => Str::slug($name) . '-' . Str::random(4),
            'description'       => fake()->paragraphs(2, true),
            'short_description' => fake()->sentence(),
            'price'             => fake()->randomFloat(2, 100, 50000),
            'stock'             => fake()->numberBetween(0, 500),
            'sku'               => strtoupper(Str::random(8)),
            'status'            => 'active',
            'is_featured'       => fake()->boolean(20),
        ];
    }

    public function active(): static
    {
        return $this->state(['status' => 'active']);
    }

    public function featured(): static
    {
        return $this->state(['is_featured' => true]);
    }
}

KODA_FILE_B3A4C515

# --- database/factories/UserFactory.php ---
mkdir -p "database/factories"
cat > "database/factories/UserFactory.php" << 'KODA_FILE_B75363C4'
<?php

namespace Database\Factories;

use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class UserFactory extends Factory
{
    protected $model = User::class;

    protected static ?string $password;

    public function definition(): array
    {
        return [
            'name'              => fake()->name(),
            'email'             => fake()->unique()->safeEmail(),
            'email_verified_at' => now(),
            'password'          => static::$password ??= Hash::make('password'),
            'remember_token'    => Str::random(10),
        ];
    }

    public function unverified(): static
    {
        return $this->state(fn(array $attributes) => [
            'email_verified_at' => null,
        ]);
    }
}

KODA_FILE_B75363C4

# --- database/factories/VendorProfileFactory.php ---
mkdir -p "database/factories"
cat > "database/factories/VendorProfileFactory.php" << 'KODA_FILE_48CC1475'
<?php

namespace Database\Factories;

use App\Models\User;
use App\Models\VendorProfile;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;

class VendorProfileFactory extends Factory
{
    protected $model = VendorProfile::class;

    public function definition(): array
    {
        $name = fake()->company();

        return [
            'user_id'         => User::factory(),
            'store_name'      => $name,
            'slug'            => Str::slug($name) . '-' . Str::random(4),
            'description'     => fake()->paragraph(),
            'phone'           => fake()->phoneNumber(),
            'address'         => fake()->streetAddress(),
            'city'            => fake()->city(),
            'country'         => 'KE',
            'status'          => 'active',
            'is_verified'     => true,
            'commission_rate' => 10.00,
            'balance'         => 0,
        ];
    }

    public function pending(): static
    {
        return $this->state(['status' => 'pending', 'is_verified' => false]);
    }
}

KODA_FILE_48CC1475

# --- database/migrations/2024_01_01_000000_create_base_tables.php ---
mkdir -p "database/migrations"
cat > "database/migrations/2024_01_01_000000_create_base_tables.php" << 'KODA_FILE_6C0ABC24'
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('users', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('email')->unique();
            $table->timestamp('email_verified_at')->nullable();
            $table->string('password');
            $table->rememberToken();
            $table->timestamps();
        });

        Schema::create('password_reset_tokens', function (Blueprint $table) {
            $table->string('email')->primary();
            $table->string('token');
            $table->timestamp('created_at')->nullable();
        });

        Schema::create('sessions', function (Blueprint $table) {
            $table->string('id')->primary();
            $table->foreignId('user_id')->nullable()->index();
            $table->string('ip_address', 45)->nullable();
            $table->text('user_agent')->nullable();
            $table->longText('payload');
            $table->integer('last_activity')->index();
        });

        Schema::create('cache', function (Blueprint $table) {
            $table->string('key')->primary();
            $table->mediumText('value');
            $table->integer('expiration');
        });

        Schema::create('cache_locks', function (Blueprint $table) {
            $table->string('key')->primary();
            $table->string('owner');
            $table->integer('expiration');
        });

        Schema::create('jobs', function (Blueprint $table) {
            $table->id();
            $table->string('queue')->index();
            $table->longText('payload');
            $table->unsignedTinyInteger('attempts');
            $table->unsignedInteger('reserved_at')->nullable();
            $table->unsignedInteger('available_at');
            $table->unsignedInteger('created_at');
        });

        Schema::create('job_batches', function (Blueprint $table) {
            $table->string('id')->primary();
            $table->string('name');
            $table->integer('total_jobs');
            $table->integer('pending_jobs');
            $table->integer('failed_jobs');
            $table->longText('failed_job_ids');
            $table->mediumText('options')->nullable();
            $table->integer('cancelled_at')->nullable();
            $table->integer('created_at');
            $table->integer('finished_at')->nullable();
        });

        Schema::create('failed_jobs', function (Blueprint $table) {
            $table->id();
            $table->string('uuid')->unique();
            $table->text('connection');
            $table->text('queue');
            $table->longText('payload');
            $table->longText('exception');
            $table->timestamp('failed_at')->useCurrent();
        });

        Schema::create('notifications', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->string('type');
            $table->morphs('notifiable');
            $table->text('data');
            $table->timestamp('read_at')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('notifications');
        Schema::dropIfExists('failed_jobs');
        Schema::dropIfExists('job_batches');
        Schema::dropIfExists('jobs');
        Schema::dropIfExists('cache_locks');
        Schema::dropIfExists('cache');
        Schema::dropIfExists('sessions');
        Schema::dropIfExists('password_reset_tokens');
        Schema::dropIfExists('users');
    }
};

KODA_FILE_6C0ABC24

# --- database/migrations/2024_01_02_000000_create_vendor_profiles_table.php ---
mkdir -p "database/migrations"
cat > "database/migrations/2024_01_02_000000_create_vendor_profiles_table.php" << 'KODA_FILE_D10E4155'
<?php
// ═══════════════════════════════════════════════════════
// MIGRATION: create_vendor_profiles_table
// ═══════════════════════════════════════════════════════
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void {
        Schema::create('vendor_profiles', function (Blueprint $t) {
            $t->id();
            $t->foreignId('user_id')->constrained()->cascadeOnDelete();
            $t->string('store_name');
            $t->string('slug')->unique();
            $t->text('description')->nullable();
            $t->string('logo')->nullable();
            $t->string('banner')->nullable();
            $t->string('phone')->nullable();
            $t->string('address')->nullable();
            $t->string('city')->nullable();
            $t->string('country')->default('KE');
            $t->enum('status', ['pending','active','rejected','suspended'])->default('pending');
            $t->text('rejection_reason')->nullable();
            $t->boolean('is_verified')->default(false);
            $t->decimal('commission_rate', 5, 2)->default(10.00);
            $t->decimal('balance', 12, 2)->default(0);
            $t->timestamps();
        });
    }
    public function down(): void { Schema::dropIfExists('vendor_profiles'); }
};

KODA_FILE_D10E4155

# --- database/migrations/2024_01_03_000000_create_marketplace_tables.php ---
mkdir -p "database/migrations"
cat > "database/migrations/2024_01_03_000000_create_marketplace_tables.php" << 'KODA_FILE_AC534ADB'
<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

// ── Categories ───────────────────────────────────────
return new class extends Migration {
    public function up(): void {
        Schema::create('categories', function (Blueprint $t) {
            $t->id();
            $t->string('name');
            $t->string('slug')->unique();
            $t->string('icon')->nullable();
            $t->text('description')->nullable();
            $t->foreignId('parent_id')->nullable()->constrained('categories')->nullOnDelete();
            $t->timestamps();
        });

        Schema::create('products', function (Blueprint $t) {
            $t->id();
            $t->foreignId('vendor_profile_id')->constrained()->cascadeOnDelete();
            $t->foreignId('category_id')->nullable()->constrained()->nullOnDelete();
            $t->string('name');
            $t->string('slug')->unique();
            $t->text('description')->nullable();
            $t->string('short_description')->nullable();
            $t->decimal('price', 12, 2);
            $t->decimal('compare_price', 12, 2)->nullable();
            $t->unsignedInteger('stock')->default(0);
            $t->string('sku')->unique();
            $t->string('thumbnail')->nullable();
            $t->enum('status', ['draft','active','inactive'])->default('draft');
            $t->boolean('is_featured')->default(false);
            $t->timestamps();
        });

        Schema::create('product_images', function (Blueprint $t) {
            $t->id();
            $t->foreignId('product_id')->constrained()->cascadeOnDelete();
            $t->string('url');
            $t->unsignedSmallInteger('order')->default(0);
            $t->timestamps();
        });

        Schema::create('carts', function (Blueprint $t) {
            $t->id();
            $t->foreignId('user_id')->nullable()->constrained()->nullOnDelete();
            $t->string('session_id')->nullable()->index();
            $t->timestamps();
        });

        Schema::create('cart_items', function (Blueprint $t) {
            $t->id();
            $t->foreignId('cart_id')->constrained()->cascadeOnDelete();
            $t->foreignId('product_id')->constrained()->cascadeOnDelete();
            $t->unsignedInteger('quantity')->default(1);
            $t->timestamps();
        });

        Schema::create('wishlists', function (Blueprint $t) {
            $t->id();
            $t->foreignId('user_id')->constrained()->cascadeOnDelete();
            $t->foreignId('product_id')->constrained()->cascadeOnDelete();
            $t->timestamps();
            $t->unique(['user_id','product_id']);
        });

        Schema::create('promo_codes', function (Blueprint $t) {
            $t->id();
            $t->string('code')->unique();
            $t->enum('type', ['percent','fixed']);
            $t->decimal('value', 10, 2);
            $t->unsignedInteger('max_uses')->nullable();
            $t->unsignedInteger('uses')->default(0);
            $t->timestamp('expires_at')->nullable();
            $t->boolean('is_active')->default(true);
            $t->timestamps();
        });

        Schema::create('orders', function (Blueprint $t) {
            $t->id();
            $t->foreignId('buyer_id')->constrained('users')->cascadeOnDelete();
            $t->string('order_number')->unique();
            $t->enum('status', ['pending','processing','shipped','delivered','cancelled'])->default('pending');
            $t->enum('payment_status', ['unpaid','paid','refunded'])->default('unpaid');
            $t->string('payment_method')->nullable();
            $t->string('payment_intent_id')->nullable();
            $t->decimal('subtotal', 12, 2);
            $t->decimal('discount', 12, 2)->default(0);
            $t->decimal('shipping', 12, 2)->default(0);
            $t->decimal('total', 12, 2);
            $t->string('shipping_name');
            $t->string('shipping_email');
            $t->string('shipping_phone')->nullable();
            $t->string('shipping_address');
            $t->string('shipping_city');
            $t->string('shipping_country')->default('KE');
            $t->foreignId('promo_code_id')->nullable()->constrained()->nullOnDelete();
            $t->text('notes')->nullable();
            $t->timestamps();
        });

        Schema::create('order_items', function (Blueprint $t) {
            $t->id();
            $t->foreignId('order_id')->constrained()->cascadeOnDelete();
            $t->foreignId('product_id')->constrained();
            $t->foreignId('vendor_profile_id')->constrained();
            $t->unsignedInteger('quantity');
            $t->decimal('unit_price', 12, 2);
            $t->decimal('subtotal', 12, 2);
            $t->enum('status', ['pending','processing','shipped','delivered','cancelled'])->default('pending');
            $t->timestamps();
        });

        Schema::create('reviews', function (Blueprint $t) {
            $t->id();
            $t->foreignId('user_id')->constrained()->cascadeOnDelete();
            $t->foreignId('product_id')->constrained()->cascadeOnDelete();
            $t->unsignedTinyInteger('rating');
            $t->text('comment')->nullable();
            $t->boolean('approved')->default(false);
            $t->timestamps();
        });
    }

    public function down(): void {
        Schema::dropIfExists('reviews');
        Schema::dropIfExists('order_items');
        Schema::dropIfExists('orders');
        Schema::dropIfExists('promo_codes');
        Schema::dropIfExists('wishlists');
        Schema::dropIfExists('cart_items');
        Schema::dropIfExists('carts');
        Schema::dropIfExists('product_images');
        Schema::dropIfExists('products');
        Schema::dropIfExists('categories');
    }
};

KODA_FILE_AC534ADB

# --- database/seeders/DatabaseSeeder.php ---
mkdir -p "database/seeders"
cat > "database/seeders/DatabaseSeeder.php" << 'KODA_FILE_2DBE376E'
<?php

namespace Database\Seeders;

use App\Models\Category;
use App\Models\User;
use App\Models\VendorProfile;
use App\Models\Product;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use Spatie\Permission\Models\Role;
use Spatie\Permission\Models\Permission;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // ── Roles ────────────────────────────────────────
        $roles = ['admin', 'vendor', 'buyer'];
        foreach ($roles as $role) {
            Role::firstOrCreate(['name' => $role]);
        }

        // ── Admin user ───────────────────────────────────
        $admin = User::firstOrCreate(
            ['email' => 'admin@koda.com'],
            [
                'name'              => 'Koda Admin',
                'password'          => Hash::make('password'),
                'email_verified_at' => now(),
            ]
        );
        $admin->assignRole('admin');

        // ── Demo buyer ───────────────────────────────────
        $buyer = User::firstOrCreate(
            ['email' => 'buyer@koda.com'],
            [
                'name'              => 'John Buyer',
                'password'          => Hash::make('password'),
                'email_verified_at' => now(),
            ]
        );
        $buyer->assignRole('buyer');

        // ── Demo vendor ──────────────────────────────────
        $vendorUser = User::firstOrCreate(
            ['email' => 'vendor@koda.com'],
            [
                'name'              => 'Jane Vendor',
                'password'          => Hash::make('password'),
                'email_verified_at' => now(),
            ]
        );
        $vendorUser->assignRole('vendor');

        $vendor = VendorProfile::firstOrCreate(
            ['user_id' => $vendorUser->id],
            [
                'store_name'  => 'TechSupplies Africa',
                'slug'        => 'techsupplies-africa',
                'description' => 'Premium technology products and office supplies for businesses across Africa.',
                'status'      => 'active',
                'is_verified' => true,
                'city'        => 'Nairobi',
                'country'     => 'KE',
            ]
        );

        // ── Categories ───────────────────────────────────
        $categories = [
            ['name' => 'Electronics',       'icon' => '💻'],
            ['name' => 'Office Supplies',   'icon' => '📎'],
            ['name' => 'Safety Equipment',  'icon' => '🦺'],
            ['name' => 'Industrial Tools',  'icon' => '🔧'],
            ['name' => 'Packaging',         'icon' => '📦'],
            ['name' => 'Cleaning Products', 'icon' => '🧹'],
            ['name' => 'Furniture',         'icon' => '🪑'],
            ['name' => 'Stationery',        'icon' => '✏️'],
            ['name' => 'Hardware',          'icon' => '🔩'],
            ['name' => 'Healthcare',        'icon' => '🏥'],
            ['name' => 'Food & Beverage',   'icon' => '🍱'],
            ['name' => 'Automotive',        'icon' => '🚗'],
        ];

        $createdCategories = [];
        foreach ($categories as $cat) {
            $createdCategories[] = Category::firstOrCreate(
                ['slug' => Str::slug($cat['name'])],
                ['name' => $cat['name'], 'icon' => $cat['icon']]
            );
        }

        // ── Sample products ──────────────────────────────
        $sampleProducts = [
            [
                'name'        => 'Wireless Ergonomic Keyboard',
                'price'       => 4500,
                'stock'       => 50,
                'is_featured' => true,
                'status'      => 'active',
                'category'    => 'Electronics',
                'description' => 'Professional wireless keyboard with ergonomic design, perfect for long working hours. Bluetooth 5.0, 12-month battery life.',
            ],
            [
                'name'        => 'Industrial Safety Helmet',
                'price'       => 1200,
                'stock'       => 200,
                'is_featured' => true,
                'status'      => 'active',
                'category'    => 'Safety Equipment',
                'description' => 'CE certified industrial safety helmet with adjustable suspension system. Meets EN 397 standards.',
            ],
            [
                'name'        => 'A4 Copy Paper (500 sheets)',
                'price'       => 650,
                'stock'       => 1000,
                'is_featured' => false,
                'status'      => 'active',
                'category'    => 'Office Supplies',
                'description' => 'Premium quality A4 copy paper, 80gsm, acid-free for long-lasting documents.',
            ],
            [
                'name'        => 'Cordless Power Drill',
                'price'       => 8900,
                'stock'       => 30,
                'is_featured' => true,
                'status'      => 'active',
                'category'    => 'Industrial Tools',
                'description' => '18V cordless power drill with 2 batteries, charger, and carry case. Variable speed trigger.',
            ],
            [
                'name'        => 'Executive Office Chair',
                'price'       => 25000,
                'stock'       => 15,
                'is_featured' => true,
                'status'      => 'active',
                'category'    => 'Furniture',
                'description' => 'High-back ergonomic executive chair with lumbar support, adjustable armrests, and breathable mesh back.',
            ],
        ];

        foreach ($sampleProducts as $data) {
            $category = collect($createdCategories)->firstWhere('name', $data['category']);
            if (!$category) continue;

            Product::firstOrCreate(
                ['sku' => Str::upper(Str::slug($data['name']) . '-001')],
                [
                    'vendor_profile_id' => $vendor->id,
                    'category_id'       => $category->id,
                    'name'              => $data['name'],
                    'slug'              => Str::slug($data['name']) . '-' . Str::random(4),
                    'description'       => $data['description'],
                    'short_description' => Str::limit($data['description'], 100),
                    'price'             => $data['price'],
                    'stock'             => $data['stock'],
                    'is_featured'       => $data['is_featured'],
                    'status'            => $data['status'],
                ]
            );
        }

        $this->command->info('✅ Koda seed complete!');
        $this->command->info('   Admin:  admin@koda.com / password');
        $this->command->info('   Vendor: vendor@koda.com / password');
        $this->command->info('   Buyer:  buyer@koda.com / password');
    }
}

KODA_FILE_2DBE376E

# --- database/seeders/DemoSeeder.php ---
mkdir -p "database/seeders"
cat > "database/seeders/DemoSeeder.php" << 'KODA_FILE_5E657403'
<?php

namespace Database\Seeders;

use App\Models\Category;
use App\Models\Cart;
use App\Models\CartItem;
use App\Models\Order;
use App\Models\OrderItem;
use App\Models\Product;
use App\Models\Review;
use App\Models\User;
use App\Models\VendorProfile;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use Spatie\Permission\Models\Role;

/**
 * Run after DatabaseSeeder to populate richer demo data.
 * php artisan db:seed --class=DemoSeeder
 */
class DemoSeeder extends Seeder
{
    public function run(): void
    {
        // Ensure roles exist
        foreach (['admin', 'vendor', 'buyer'] as $role) {
            Role::firstOrCreate(['name' => $role]);
        }

        $categories = Category::all();
        if ($categories->isEmpty()) {
            $this->command->error('Run DatabaseSeeder first: php artisan db:seed');
            return;
        }

        // Create 5 more vendors
        $vendors = [];
        $vendorData = [
            ['name' => 'SafetyFirst Kenya',   'city' => 'Nairobi',  'desc' => 'PPE and industrial safety supplies for East Africa.'],
            ['name' => 'OfficeHub Ltd',        'city' => 'Mombasa',  'desc' => 'Complete office solutions — stationery to furniture.'],
            ['name' => 'BuildRight Supplies',  'city' => 'Kampala',  'desc' => 'Construction tools and building materials.'],
            ['name' => 'TechWorld Africa',     'city' => 'Nairobi',  'desc' => 'Electronics, gadgets and IT accessories.'],
            ['name' => 'CleanPro Solutions',   'city' => 'Kigali',   'desc' => 'Commercial cleaning products and janitorial supplies.'],
        ];

        foreach ($vendorData as $vd) {
            $user = User::firstOrCreate(
                ['email' => Str::slug($vd['name']) . '@demo.com'],
                [
                    'name'              => $vd['name'] . ' Admin',
                    'password'          => Hash::make('password'),
                    'email_verified_at' => now(),
                ]
            );
            $user->assignRole('vendor');

            $vendor = VendorProfile::firstOrCreate(
                ['user_id' => $user->id],
                [
                    'store_name'      => $vd['name'],
                    'slug'            => Str::slug($vd['name']) . '-' . Str::random(4),
                    'description'     => $vd['desc'],
                    'city'            => $vd['city'],
                    'country'         => 'KE',
                    'status'          => 'active',
                    'is_verified'     => true,
                    'commission_rate' => 10.00,
                ]
            );
            $vendors[] = $vendor;
        }

        // Create 5 demo buyers
        $buyers = [];
        for ($i = 1; $i <= 5; $i++) {
            $buyer = User::firstOrCreate(
                ['email' => "buyer{$i}@demo.com"],
                [
                    'name'              => "Demo Buyer {$i}",
                    'password'          => Hash::make('password'),
                    'email_verified_at' => now(),
                ]
            );
            $buyer->assignRole('buyer');
            $buyers[] = $buyer;
        }

        // Create products for each vendor
        $sampleProducts = [
            ['name' => 'Safety Gloves (12 pairs)',   'price' => 850,   'stock' => 500, 'cat' => 'Safety Equipment'],
            ['name' => 'Hard Hat ANSI Z89.1',         'price' => 1200,  'stock' => 200, 'cat' => 'Safety Equipment'],
            ['name' => 'High-Vis Vest (XL)',           'price' => 650,   'stock' => 300, 'cat' => 'Safety Equipment'],
            ['name' => 'A4 Printer Paper (5 Reams)',   'price' => 1800,  'stock' => 800, 'cat' => 'Office Supplies'],
            ['name' => 'Ballpoint Pens (50-pack)',     'price' => 450,   'stock' => 1000,'cat' => 'Stationery'],
            ['name' => 'Office Desk (160x80cm)',       'price' => 18500, 'stock' => 12,  'cat' => 'Furniture'],
            ['name' => 'Ergonomic Chair',              'price' => 22000, 'stock' => 8,   'cat' => 'Furniture'],
            ['name' => 'USB-C Hub 7-in-1',             'price' => 3200,  'stock' => 45,  'cat' => 'Electronics'],
            ['name' => 'Wireless Mouse',               'price' => 1800,  'stock' => 80,  'cat' => 'Electronics'],
            ['name' => '27" LED Monitor',              'price' => 32000, 'stock' => 15,  'cat' => 'Electronics'],
            ['name' => 'Power Drill 18V',              'price' => 9500,  'stock' => 25,  'cat' => 'Industrial Tools'],
            ['name' => 'Angle Grinder 4.5"',           'price' => 7800,  'stock' => 20,  'cat' => 'Industrial Tools'],
            ['name' => 'Multi-surface Cleaner 5L',     'price' => 950,   'stock' => 300, 'cat' => 'Cleaning Products'],
            ['name' => 'Industrial Mop Set',           'price' => 2200,  'stock' => 60,  'cat' => 'Cleaning Products'],
            ['name' => 'Cardboard Boxes (50-pack)',    'price' => 3500,  'stock' => 200, 'cat' => 'Packaging'],
        ];

        $allVendors = array_merge([VendorProfile::where('store_name', 'TechSupplies Africa')->first()], $vendors);
        $allVendors = array_filter($allVendors);

        foreach ($sampleProducts as $i => $pd) {
            $category = $categories->firstWhere('name', $pd['cat']) ?? $categories->first();
            $vendor   = $allVendors[$i % count($allVendors)];
            if (!$vendor) continue;

            Product::firstOrCreate(
                ['sku' => strtoupper(Str::slug($pd['name']) . '-demo')],
                [
                    'vendor_profile_id' => $vendor->id,
                    'category_id'       => $category->id,
                    'name'              => $pd['name'],
                    'slug'              => Str::slug($pd['name']) . '-' . Str::random(4),
                    'description'       => "Professional grade {$pd['name']}. Suitable for commercial and industrial use. Meets all relevant quality standards.",
                    'short_description' => "High quality {$pd['name']} for business use.",
                    'price'             => $pd['price'],
                    'stock'             => $pd['stock'],
                    'status'            => 'active',
                    'is_featured'       => $i < 5,
                ]
            );
        }

        // Create sample completed orders
        $products = Product::active()->take(10)->get();
        foreach ($buyers as $buyer) {
            $order = Order::create([
                'buyer_id'        => $buyer->id,
                'status'          => 'delivered',
                'payment_status'  => 'paid',
                'payment_method'  => 'stripe',
                'subtotal'        => 0,
                'discount'        => 0,
                'shipping'        => 0,
                'total'           => 0,
                'shipping_name'   => $buyer->name,
                'shipping_email'  => $buyer->email,
                'shipping_address'=> '123 Business Park',
                'shipping_city'   => 'Nairobi',
                'shipping_country'=> 'KE',
            ]);

            $total = 0;
            foreach ($products->random(2) as $product) {
                $qty      = rand(1, 3);
                $subtotal = $product->price * $qty;
                $total   += $subtotal;

                OrderItem::create([
                    'order_id'          => $order->id,
                    'product_id'        => $product->id,
                    'vendor_profile_id' => $product->vendor_profile_id,
                    'quantity'          => $qty,
                    'unit_price'        => $product->price,
                    'subtotal'          => $subtotal,
                    'status'            => 'delivered',
                ]);

                // Add a review
                Review::firstOrCreate(
                    ['user_id' => $buyer->id, 'product_id' => $product->id],
                    [
                        'rating'   => rand(4, 5),
                        'comment'  => 'Great product, exactly as described. Fast delivery too!',
                        'approved' => true,
                    ]
                );
            }

            $order->update(['subtotal' => $total, 'total' => $total]);
        }

        $this->command->info('✅ Demo data seeded!');
        $this->command->info('   Extra vendors: ' . count($vendors) . ' created');
        $this->command->info('   Demo buyers: ' . count($buyers) . ' created (buyer1@demo.com — buyer5@demo.com / password)');
        $this->command->info('   Products: ' . Product::count() . ' total');
        $this->command->info('   Orders: ' . Order::count() . ' total (all delivered/paid)');
    }
}

KODA_FILE_5E657403

# --- package.json ---
mkdir -p "."
cat > "package.json" << 'KODA_FILE_B34B4D91'
{
    "private": true,
    "type": "module",
    "scripts": {
        "dev": "vite",
        "build": "vite build"
    },
    "dependencies": {
        "@inertiajs/vue3": "^2.0.0",
        "@vitejs/plugin-vue": "^5.0.0",
        "axios": "^1.6.4",
        "pinia": "^2.1.7",
        "vue": "^3.4.0",
        "ziggy-js": "^2.0.0",
        "@vueuse/core": "^10.7.0",
        "vue3-toastify": "^0.2.1",
        "lucide-vue-next": "^0.359.0",
        "chart.js": "^4.4.2",
        "vue-chartjs": "^5.3.0",
        "swiper": "^11.0.7"
    },
    "devDependencies": {
        "autoprefixer": "^10.4.17",
        "laravel-vite-plugin": "^1.0",
        "postcss": "^8.4.35",
        "tailwindcss": "^3.4.1",
        "vite": "^5.0"
    }
}

KODA_FILE_B34B4D91

# --- postcss.config.js ---
mkdir -p "."
cat > "postcss.config.js" << 'KODA_FILE_7B01996D'
export default {
    plugins: {
        tailwindcss: {},
        autoprefixer: {},
    },
};

KODA_FILE_7B01996D

# --- public/.htaccess ---
mkdir -p "public"
cat > "public/.htaccess" << 'KODA_FILE_1EE065ED'
<IfModule mod_rewrite.c>
    <IfModule mod_negotiation.c>
        Options -MultiViews -Indexes
    </IfModule>

    RewriteEngine On

    # Handle Authorization Header
    RewriteCond %{HTTP:Authorization} .
    RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]

    # Redirect Trailing Slashes If Not A Folder...
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteCond %{REQUEST_URI} (.+)/$
    RewriteRule ^ %1 [L,R=301]

    # Send Requests To Front Controller...
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteRule ^ index.php [L]
</IfModule>

KODA_FILE_1EE065ED

# --- public/favicon.svg ---
mkdir -p "public"
cat > "public/favicon.svg" << 'KODA_FILE_100A8E08'
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" fill="none">
  <rect width="32" height="32" rx="8" fill="#f97316"/>
  <path d="M9 7 L9 25 M9 16 L20 7 M9 16 L20 25" stroke="white" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
</svg>

KODA_FILE_100A8E08

# --- public/index.php ---
mkdir -p "public"
cat > "public/index.php" << 'KODA_FILE_E6B62B66'
<?php

use Illuminate\Http\Request;

define('LARAVEL_START', microtime(true));

// Determine if the application is in maintenance mode...
if (file_exists($maintenance = __DIR__.'/../storage/framework/maintenance.php')) {
    require $maintenance;
}

// Register the Composer autoloader...
require __DIR__.'/../vendor/autoload.php';

// Bootstrap Laravel and handle the request...
(require_once __DIR__.'/../bootstrap/app.php')
    ->handleRequest(Request::capture());

KODA_FILE_E6B62B66

# --- public/robots.txt ---
mkdir -p "public"
cat > "public/robots.txt" << 'KODA_FILE_8B7C56E6'
User-agent: *
Disallow: /admin/
Disallow: /vendor/
Disallow: /checkout
Disallow: /cart

KODA_FILE_8B7C56E6

# --- resources/css/app.css ---
mkdir -p "resources/css"
cat > "resources/css/app.css" << 'KODA_FILE_06DD87FF'
@import url('https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=Inter:wght@300;400;500;600&family=JetBrains+Mono:wght@400;500&display=swap');

@tailwind base;
@tailwind components;
@tailwind utilities;

/* ── Koda Design Tokens ───────────────────────────── */
:root {
    --bg-primary:   #0a0a0a;
    --bg-secondary: #111111;
    --bg-tertiary:  #1a1a1a;
    --bg-card:      #141414;
    --bg-input:     #1e1e1e;

    --accent:       #f97316;
    --accent-hover: #ea6c0a;
    --accent-light: #fb923c;
    --accent-muted: #7c3f12;

    --text-primary:   #ffffff;
    --text-secondary: #a3a3a3;
    --text-muted:     #6b6b6b;

    --border:       #262626;
    --border-light: #333333;
    --border-focus: #f97316;

    --success: #22c55e;
    --warning: #eab308;
    --error:   #ef4444;
    --info:    #3b82f6;

    --radius-card: 12px;
    --radius-btn:  8px;
    --shadow-card: 0 4px 24px rgba(0,0,0,0.4);
    --shadow-glow: 0 0 24px rgba(249,115,22,0.15);
}

/* ── Base ──────────────────────────────────────────── */
* {
    scrollbar-width: thin;
    scrollbar-color: var(--border-light) transparent;
}

*::-webkit-scrollbar { width: 6px; height: 6px; }
*::-webkit-scrollbar-track { background: transparent; }
*::-webkit-scrollbar-thumb { background: var(--border-light); border-radius: 3px; }

html {
    background-color: var(--bg-primary);
    color: var(--text-primary);
    font-family: 'Inter', sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
}

body {
    background-color: var(--bg-primary);
    min-height: 100vh;
}

/* ── Typography ────────────────────────────────────── */
h1, h2, h3, h4, h5, h6 {
    font-family: 'Space Grotesk', sans-serif;
    font-weight: 700;
    color: var(--text-primary);
    letter-spacing: -0.02em;
}

/* ── Koda Components ───────────────────────────────── */
@layer components {

    /* Cards */
    .koda-card {
        @apply bg-bg-secondary border border-border rounded-card p-6;
        @apply transition-all duration-200;
        box-shadow: var(--shadow-card);
    }
    .koda-card:hover {
        @apply border-border-light;
    }

    /* Buttons */
    .btn-primary {
        @apply bg-accent hover:bg-accent-hover text-white font-body font-semibold;
        @apply px-5 py-2.5 rounded-btn transition-all duration-200;
        @apply flex items-center justify-center gap-2 text-sm;
        @apply disabled:opacity-50 disabled:cursor-not-allowed;
    }
    .btn-primary:hover:not(:disabled) {
        @apply shadow-glow;
        transform: translateY(-1px);
    }
    .btn-primary:active:not(:disabled) {
        transform: translateY(0);
    }

    .btn-secondary {
        @apply bg-bg-tertiary hover:bg-border text-text-primary font-body font-medium;
        @apply px-5 py-2.5 rounded-btn border border-border transition-all duration-200;
        @apply flex items-center justify-center gap-2 text-sm;
    }

    .btn-outline {
        @apply bg-transparent hover:bg-accent-subtle text-accent border border-accent;
        @apply px-5 py-2.5 rounded-btn font-body font-medium transition-all duration-200;
        @apply flex items-center justify-center gap-2 text-sm;
    }

    .btn-ghost {
        @apply bg-transparent hover:bg-bg-tertiary text-text-secondary hover:text-text-primary;
        @apply px-3 py-2 rounded-btn transition-all duration-200;
        @apply flex items-center justify-center gap-2 text-sm;
    }

    .btn-danger {
        @apply bg-status-error hover:bg-red-600 text-white font-medium;
        @apply px-5 py-2.5 rounded-btn transition-all duration-200;
        @apply flex items-center justify-center gap-2 text-sm;
    }

    /* Form inputs */
    .koda-input {
        @apply w-full bg-bg-input border border-border rounded-btn px-4 py-2.5;
        @apply text-text-primary text-sm placeholder-text-muted;
        @apply transition-all duration-200 outline-none;
    }
    .koda-input:focus {
        @apply border-accent;
        box-shadow: 0 0 0 3px rgba(249,115,22,0.1);
    }

    .koda-label {
        @apply block text-sm font-medium text-text-secondary mb-1.5;
    }

    .koda-select {
        @apply koda-input cursor-pointer;
        background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%23a3a3a3' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='M6 8l4 4 4-4'/%3e%3c/svg%3e");
        background-position: right 0.75rem center;
        background-repeat: no-repeat;
        background-size: 1em;
        appearance: none;
    }

    .koda-textarea {
        @apply koda-input resize-none;
    }

    /* Error state */
    .koda-input.error { @apply border-status-error; }
    .koda-error { @apply text-xs text-status-error mt-1; }

    /* Badges */
    .badge {
        @apply inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-xs font-medium;
    }
    .badge-accent   { @apply bg-accent-subtle text-accent-light border border-accent-muted; }
    .badge-success  { @apply bg-green-950 text-green-400 border border-green-900; }
    .badge-warning  { @apply bg-yellow-950 text-yellow-400 border border-yellow-900; }
    .badge-error    { @apply bg-red-950 text-red-400 border border-red-900; }
    .badge-info     { @apply bg-blue-950 text-blue-400 border border-blue-900; }
    .badge-neutral  { @apply bg-bg-tertiary text-text-secondary border border-border; }

    /* Star rating */
    .star-filled { @apply text-yellow-400; }
    .star-empty  { @apply text-border; }

    /* Table */
    .koda-table { @apply w-full; }
    .koda-table th { @apply text-left text-xs font-semibold text-text-muted uppercase tracking-wider px-4 py-3 border-b border-border; }
    .koda-table td { @apply px-4 py-3.5 text-sm text-text-secondary border-b border-border; }
    .koda-table tr:hover td { @apply bg-bg-tertiary; }

    /* Divider */
    .koda-divider { @apply border-t border-border my-6; }

    /* Skeleton loader */
    .skeleton {
        @apply bg-bg-tertiary rounded animate-pulse;
        background: linear-gradient(90deg, #1a1a1a 25%, #222222 50%, #1a1a1a 75%);
        background-size: 200% 100%;
        animation: shimmer 1.5s infinite;
    }

    /* Nav link */
    .nav-link {
        @apply text-text-secondary hover:text-text-primary text-sm font-medium;
        @apply transition-colors duration-200 px-3 py-2 rounded-btn;
    }
    .nav-link.active {
        @apply text-accent bg-accent-subtle;
    }

    /* Section title */
    .section-title {
        @apply font-heading text-2xl font-bold text-text-primary tracking-tight;
    }
    .section-subtitle {
        @apply text-text-secondary mt-2;
    }

    /* Product card */
    .product-card {
        @apply koda-card cursor-pointer group;
        @apply hover:border-accent/30 hover:shadow-glow;
    }
}

/* ── Utilities ─────────────────────────────────────── */
@layer utilities {
    .text-gradient {
        @apply bg-clip-text text-transparent;
        background-image: linear-gradient(135deg, #f97316, #fb923c);
    }
    .border-gradient {
        border-image: linear-gradient(135deg, #f97316, transparent) 1;
    }
    .bg-noise {
        background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.03'/%3E%3C/svg%3E");
    }
}

/* ── Inertia progress bar ──────────────────────────── */
#nprogress .bar {
    background: var(--accent) !important;
    height: 3px !important;
}

/* ── Transitions ───────────────────────────────────── */
.page-enter-active,
.page-leave-active {
    transition: opacity 0.15s ease, transform 0.15s ease;
}
.page-enter-from {
    opacity: 0;
    transform: translateY(6px);
}
.page-leave-to {
    opacity: 0;
    transform: translateY(-6px);
}

/* ── Swiper overrides ──────────────────────────────── */
.swiper-pagination-bullet { background: var(--border) !important; }
.swiper-pagination-bullet-active { background: var(--accent) !important; }

KODA_FILE_06DD87FF

# --- resources/js/Components/Shared/ProductCard.vue ---
mkdir -p "resources/js/Components/Shared"
cat > "resources/js/Components/Shared/ProductCard.vue" << 'KODA_FILE_02BDC62B'
<template>
  <Link :href="route('products.show', product.slug)" class="product-card group block">
    <!-- Image -->
    <div class="relative aspect-square rounded-lg overflow-hidden bg-bg-tertiary mb-4">
      <img
        v-if="product.thumbnail"
        :src="product.thumbnail"
        :alt="product.name"
        class="w-full h-full object-cover transition-transform duration-300 group-hover:scale-105"
        loading="lazy"
      />
      <div v-else class="w-full h-full flex items-center justify-center">
        <PackageIcon class="w-12 h-12 text-border" />
      </div>
      <!-- Badges -->
      <div class="absolute top-2.5 left-2.5 flex flex-col gap-1.5">
        <span v-if="product.is_featured" class="badge badge-accent text-xs">Featured</span>
        <span v-if="product.stock <= 5 && product.stock > 0" class="badge badge-warning text-xs">Low stock</span>
        <span v-if="product.stock === 0" class="badge badge-error text-xs">Out of stock</span>
      </div>
      <!-- Wishlist -->
      <button
        @click.prevent="toggleWishlist"
        :class="['absolute top-2.5 right-2.5 w-8 h-8 rounded-full bg-bg-secondary/80 backdrop-blur-sm flex items-center justify-center transition-all hover:scale-110', inWishlist ? 'text-red-400' : 'text-text-muted hover:text-red-400']"
      >
        <HeartIcon :class="['w-4 h-4', inWishlist ? 'fill-current' : '']" />
      </button>
    </div>

    <!-- Details -->
    <div class="space-y-2">
      <!-- Vendor -->
      <div class="flex items-center gap-1.5">
        <img
          v-if="product.vendor?.logo"
          :src="product.vendor.logo"
          :alt="product.vendor.store_name"
          class="w-4 h-4 rounded-full object-cover"
        />
        <span class="text-xs text-text-muted truncate">{{ product.vendor?.store_name }}</span>
        <CheckCircleIcon v-if="product.vendor?.is_verified" class="w-3 h-3 text-accent shrink-0" />
      </div>

      <!-- Name -->
      <h3 class="font-heading text-sm font-semibold text-text-primary line-clamp-2 group-hover:text-accent transition-colors">
        {{ product.name }}
      </h3>

      <!-- Rating -->
      <StarRating :model-value="product.avg_rating" :show-count="true" :count="product.reviews_count" />

      <!-- Price -->
      <div class="flex items-center justify-between pt-1">
        <p class="font-heading text-lg font-bold text-accent">
          {{ formatPrice(product.price) }}
        </p>
        <button
          @click.prevent="addToCart"
          :disabled="product.stock === 0"
          class="btn-primary py-1.5 px-3 text-xs"
        >
          <ShoppingCartIcon class="w-3.5 h-3.5" />
          Add
        </button>
      </div>
    </div>
  </Link>
</template>

<script setup>
import { ref } from 'vue';
import { Link, router } from '@inertiajs/vue3';
import { PackageIcon, HeartIcon, CheckCircleIcon, ShoppingCartIcon } from 'lucide-vue-next';
import StarRating from '@/Components/UI/StarRating.vue';

const props = defineProps({
  product: { type: Object, required: true },
});

const inWishlist = ref(props.product.in_wishlist ?? false);

function formatPrice(price) {
  return new Intl.NumberFormat('en-KE', { style: 'currency', currency: 'KES' }).format(price);
}

function addToCart() {
  router.post(route('cart.add'), { product_id: props.product.id, quantity: 1 }, { preserveScroll: true });
}

function toggleWishlist() {
  inWishlist.value = !inWishlist.value;
  router.post(route('wishlist.toggle'), { product_id: props.product.id }, { preserveScroll: true });
}
</script>

KODA_FILE_02BDC62B

# --- resources/js/Components/Shared/ProductCardSkeleton.vue ---
mkdir -p "resources/js/Components/Shared"
cat > "resources/js/Components/Shared/ProductCardSkeleton.vue" << 'KODA_FILE_92FD0CCC'
<template>
  <div class="koda-card space-y-3">
    <div class="skeleton w-full aspect-square rounded-lg" />
    <div class="skeleton h-3 w-1/3 rounded" />
    <div class="skeleton h-4 w-4/5 rounded" />
    <div class="skeleton h-3 w-1/2 rounded" />
    <div class="flex items-center justify-between pt-1">
      <div class="skeleton h-5 w-20 rounded" />
      <div class="skeleton h-8 w-16 rounded-btn" />
    </div>
  </div>
</template>

KODA_FILE_92FD0CCC

# --- resources/js/Components/Shared/ReviewForm.vue ---
mkdir -p "resources/js/Components/Shared"
cat > "resources/js/Components/Shared/ReviewForm.vue" << 'KODA_FILE_1E6B4AFE'
<template>
  <div class="koda-card">
    <h3 class="font-heading text-sm font-bold mb-4">Write a Review</h3>

    <div v-if="!$page.props.auth.user" class="text-center py-6 text-text-muted">
      <p class="text-sm">You need to be logged in to leave a review.</p>
      <Link :href="route('login')" class="btn-primary mt-3 mx-auto">Log in</Link>
    </div>

    <form v-else @submit.prevent="submit" class="space-y-4">
      <div>
        <label class="koda-label mb-2">Your Rating</label>
        <StarRating v-model="form.rating" :interactive="true" />
        <p v-if="errors.rating" class="koda-error mt-1">{{ errors.rating }}</p>
      </div>

      <div>
        <label class="koda-label">Your Review</label>
        <textarea
          v-model="form.comment"
          rows="3"
          class="koda-textarea"
          :class="{ error: errors.comment }"
          placeholder="Share your experience with this product…"
        />
        <p v-if="errors.comment" class="koda-error">{{ errors.comment }}</p>
      </div>

      <button type="submit" :disabled="submitting || form.rating === 0" class="btn-primary">
        <LoaderIcon v-if="submitting" class="w-4 h-4 animate-spin" />
        <StarIcon v-else class="w-4 h-4" />
        Submit Review
      </button>

      <p v-if="submitted" class="text-sm text-status-success flex items-center gap-1.5">
        <CheckCircleIcon class="w-4 h-4" />
        Review submitted! It will appear after approval.
      </p>
    </form>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { Link, router } from '@inertiajs/vue3';
import { StarIcon, LoaderIcon, CheckCircleIcon } from 'lucide-vue-next';
import StarRating from '@/Components/UI/StarRating.vue';

const props = defineProps({
  productId: { type: Number, required: true },
});

const submitting = ref(false);
const submitted  = ref(false);
const errors     = ref({});

const form = ref({ rating: 0, comment: '' });

function submit() {
  if (form.value.rating === 0) { errors.value.rating = 'Please select a rating'; return; }

  submitting.value = true;
  router.post(route('reviews.store'), {
    product_id: props.productId,
    rating:     form.value.rating,
    comment:    form.value.comment,
  }, {
    preserveScroll: true,
    onSuccess: () => { submitted.value = true; form.value = { rating: 0, comment: '' }; },
    onError:   e => { errors.value = e; },
    onFinish:  () => { submitting.value = false; },
  });
}
</script>

KODA_FILE_1E6B4AFE

# --- resources/js/Components/Shared/SearchBox.vue ---
mkdir -p "resources/js/Components/Shared"
cat > "resources/js/Components/Shared/SearchBox.vue" << 'KODA_FILE_B94DC307'
<template>
  <div class="relative" ref="containerRef">
    <div class="relative">
      <SearchIcon class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-text-muted pointer-events-none z-10" />
      <input
        v-model="query"
        @focus="open = true"
        @keydown.enter.prevent="submit"
        @keydown.esc="open = false"
        @keydown.arrow-down.prevent="moveDown"
        @keydown.arrow-up.prevent="moveUp"
        type="text"
        :placeholder="placeholder"
        class="koda-input pl-9 pr-4 text-sm w-full"
        autocomplete="off"
      />
      <button
        v-if="query"
        @click="clear"
        class="absolute right-3 top-1/2 -translate-y-1/2 text-text-muted hover:text-text-primary"
      >
        <XIcon class="w-3.5 h-3.5" />
      </button>
    </div>

    <!-- Dropdown -->
    <Transition name="fade-down">
      <div
        v-if="open && (results.products.length || results.vendors.length || results.categories.length || loading)"
        class="absolute top-full left-0 right-0 mt-1.5 bg-bg-secondary border border-border rounded-card shadow-card-hover z-50 overflow-hidden"
      >
        <!-- Loading -->
        <div v-if="loading" class="p-4 text-center">
          <div class="w-4 h-4 border-2 border-accent border-t-transparent rounded-full animate-spin mx-auto" />
        </div>

        <template v-else>
          <!-- Products -->
          <div v-if="results.products.length">
            <p class="px-4 pt-3 pb-1 text-xs font-semibold text-text-muted uppercase tracking-wider">Products</p>
            <a
              v-for="(item, i) in results.products"
              :key="'p-' + item.id"
              :href="route('products.show', item.slug)"
              :class="['flex items-center gap-3 px-4 py-2.5 hover:bg-bg-tertiary transition-colors', highlighted === `p-${i}` ? 'bg-bg-tertiary' : '']"
            >
              <div class="w-8 h-8 rounded bg-bg-tertiary overflow-hidden shrink-0 border border-border">
                <img v-if="item.thumbnail" :src="item.thumbnail" class="w-full h-full object-cover" />
                <PackageIcon v-else class="w-4 h-4 text-border m-auto mt-2" />
              </div>
              <div class="flex-1 min-w-0">
                <p class="text-sm text-text-primary truncate">{{ item.name }}</p>
                <p class="text-xs text-text-muted">{{ item.vendor }}</p>
              </div>
              <span class="text-xs font-semibold text-accent shrink-0">{{ formatPrice(item.price) }}</span>
            </a>
          </div>

          <!-- Vendors -->
          <div v-if="results.vendors.length">
            <p class="px-4 pt-3 pb-1 text-xs font-semibold text-text-muted uppercase tracking-wider">Vendors</p>
            <a
              v-for="item in results.vendors"
              :key="'v-' + item.id"
              :href="route('vendors.show', item.slug)"
              class="flex items-center gap-3 px-4 py-2.5 hover:bg-bg-tertiary transition-colors"
            >
              <div class="w-8 h-8 rounded-full bg-accent-subtle border border-border flex items-center justify-center shrink-0">
                <img v-if="item.logo" :src="item.logo" class="w-full h-full rounded-full object-cover" />
                <span v-else class="text-accent text-xs font-bold">{{ item.name[0] }}</span>
              </div>
              <div class="flex-1 min-w-0">
                <p class="text-sm text-text-primary truncate">{{ item.name }}</p>
                <p class="text-xs text-text-muted">Vendor</p>
              </div>
            </a>
          </div>

          <!-- Categories -->
          <div v-if="results.categories.length">
            <p class="px-4 pt-3 pb-1 text-xs font-semibold text-text-muted uppercase tracking-wider">Categories</p>
            <a
              v-for="item in results.categories"
              :key="'c-' + item.id"
              :href="route('categories.show', item.slug)"
              class="flex items-center gap-3 px-4 py-2.5 hover:bg-bg-tertiary transition-colors"
            >
              <span class="text-xl">{{ item.icon ?? '📦' }}</span>
              <p class="text-sm text-text-primary">{{ item.name }}</p>
            </a>
          </div>

          <!-- View all -->
          <div class="border-t border-border">
            <button
              @click="submit"
              class="w-full flex items-center justify-center gap-2 px-4 py-3 text-sm text-accent hover:bg-bg-tertiary transition-colors"
            >
              <SearchIcon class="w-4 h-4" />
              Search for "{{ query }}"
            </button>
          </div>
        </template>
      </div>
    </Transition>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue';
import { router } from '@inertiajs/vue3';
import { onClickOutside, useDebounceFn } from '@vueuse/core';
import { SearchIcon, XIcon, PackageIcon } from 'lucide-vue-next';

defineProps({
  placeholder: { type: String, default: 'Search products, vendors…' },
});

const query        = ref('');
const open         = ref(false);
const loading      = ref(false);
const highlighted  = ref(null);
const containerRef = ref(null);

const results = ref({ products: [], vendors: [], categories: [] });

onClickOutside(containerRef, () => { open.value = false; });

const fetchResults = useDebounceFn(async (q) => {
  if (!q || q.length < 2) { results.value = { products: [], vendors: [], categories: [] }; return; }
  loading.value = true;
  try {
    const res = await fetch(route('search.autocomplete') + '?q=' + encodeURIComponent(q));
    results.value = await res.json();
  } catch (e) {
    results.value = { products: [], vendors: [], categories: [] };
  } finally {
    loading.value = false;
  }
}, 250);

watch(query, (q) => {
  if (q.length >= 2) { open.value = true; fetchResults(q); }
  else { results.value = { products: [], vendors: [], categories: [] }; }
});

function submit() {
  if (!query.value.trim()) return;
  open.value = false;
  router.get(route('products.index'), { q: query.value });
}

function clear() {
  query.value = '';
  results.value = { products: [], vendors: [], categories: [] };
}

function moveDown() { /* TODO: keyboard nav */ }
function moveUp()   { /* TODO: keyboard nav */ }

function formatPrice(p) {
  return new Intl.NumberFormat('en-KE', { style: 'currency', currency: 'KES', maximumFractionDigits: 0 }).format(p);
}
</script>

<style scoped>
.fade-down-enter-active, .fade-down-leave-active { transition: opacity 0.15s ease, transform 0.15s ease; }
.fade-down-enter-from { opacity: 0; transform: translateY(-6px); }
.fade-down-leave-to   { opacity: 0; transform: translateY(-6px); }
</style>

KODA_FILE_B94DC307

# --- resources/js/Components/Shared/StatsCard.vue ---
mkdir -p "resources/js/Components/Shared"
cat > "resources/js/Components/Shared/StatsCard.vue" << 'KODA_FILE_80F3D7EE'
<template>
  <div class="koda-card">
    <div class="flex items-start justify-between">
      <div>
        <p class="text-text-muted text-sm font-medium">{{ label }}</p>
        <p class="font-heading text-2xl font-bold text-text-primary mt-1">{{ value }}</p>
        <div v-if="change !== undefined" class="flex items-center gap-1.5 mt-2">
          <TrendingUpIcon v-if="change >= 0" class="w-3.5 h-3.5 text-status-success" />
          <TrendingDownIcon v-else class="w-3.5 h-3.5 text-status-error" />
          <span :class="['text-xs font-medium', change >= 0 ? 'text-status-success' : 'text-status-error']">
            {{ Math.abs(change) }}%
          </span>
          <span class="text-xs text-text-muted">vs last month</span>
        </div>
      </div>
      <div :class="['w-10 h-10 rounded-lg flex items-center justify-center', iconBg]">
        <component :is="icon" class="w-5 h-5" :class="iconColor" />
      </div>
    </div>
  </div>
</template>

<script setup>
import { TrendingUpIcon, TrendingDownIcon } from 'lucide-vue-next';
defineProps({
  label:     { type: String, required: true },
  value:     { type: [String, Number], required: true },
  change:    Number,
  icon:      { type: Object, required: true },
  iconBg:    { type: String, default: 'bg-accent-subtle' },
  iconColor: { type: String, default: 'text-accent' },
});
</script>

KODA_FILE_80F3D7EE

# --- resources/js/Components/Shared/VendorCard.vue ---
mkdir -p "resources/js/Components/Shared"
cat > "resources/js/Components/Shared/VendorCard.vue" << 'KODA_FILE_60A982C5'
<template>
  <Link :href="route('vendors.show', vendor.slug)" class="koda-card group block hover:border-accent/30 hover:shadow-glow transition-all">
    <!-- Banner -->
    <div class="relative h-20 rounded-lg overflow-hidden bg-bg-tertiary mb-4 -mx-1">
      <img v-if="vendor.banner" :src="vendor.banner" :alt="vendor.store_name" class="w-full h-full object-cover" />
      <div v-else class="w-full h-full bg-gradient-to-br from-accent-subtle to-bg-tertiary" />
      <!-- Logo -->
      <div class="absolute -bottom-4 left-4">
        <div class="w-10 h-10 rounded-lg bg-bg-secondary border-2 border-bg-secondary overflow-hidden">
          <img v-if="vendor.logo" :src="vendor.logo" :alt="vendor.store_name" class="w-full h-full object-cover" />
          <div v-else class="w-full h-full bg-accent-subtle flex items-center justify-center">
            <span class="text-accent text-sm font-bold">{{ vendor.store_name?.[0] }}</span>
          </div>
        </div>
      </div>
    </div>

    <div class="mt-5">
      <div class="flex items-start justify-between gap-2">
        <h3 class="font-heading text-sm font-bold text-text-primary group-hover:text-accent transition-colors line-clamp-1">
          {{ vendor.store_name }}
        </h3>
        <CheckCircleIcon v-if="vendor.is_verified" class="w-4 h-4 text-accent shrink-0 mt-0.5" />
      </div>
      <p class="text-xs text-text-muted mt-1 line-clamp-2">{{ vendor.description }}</p>
      <div class="flex items-center justify-between mt-3 pt-3 border-t border-border">
        <StarRating :model-value="vendor.avg_rating" :show-count="true" :count="vendor.reviews_count" />
        <span class="text-xs text-text-muted">{{ vendor.products_count }} products</span>
      </div>
    </div>
  </Link>
</template>

<script setup>
import { Link } from '@inertiajs/vue3';
import { CheckCircleIcon } from 'lucide-vue-next';
import StarRating from '@/Components/UI/StarRating.vue';
defineProps({ vendor: { type: Object, required: true } });
</script>

KODA_FILE_60A982C5

# --- resources/js/Components/UI/Breadcrumb.vue ---
mkdir -p "resources/js/Components/UI"
cat > "resources/js/Components/UI/Breadcrumb.vue" << 'KODA_FILE_728EF08C'
<!-- Breadcrumb.vue -->
<template>
  <nav class="flex items-center gap-1.5 text-xs text-text-muted">
    <template v-for="(item, i) in items" :key="i">
      <ChevronRightIcon v-if="i > 0" class="w-3 h-3 text-text-muted" />
      <Link v-if="item.href" :href="item.href" class="hover:text-text-secondary transition-colors">{{ item.label }}</Link>
      <span v-else class="text-text-secondary">{{ item.label }}</span>
    </template>
  </nav>
</template>

<script setup>
import { Link } from '@inertiajs/vue3';
import { ChevronRightIcon } from 'lucide-vue-next';
defineProps({ items: { type: Array, default: () => [] } });
</script>

KODA_FILE_728EF08C

# --- resources/js/Components/UI/ConfirmDialog.vue ---
mkdir -p "resources/js/Components/UI"
cat > "resources/js/Components/UI/ConfirmDialog.vue" << 'KODA_FILE_5F725CBD'
<template>
  <Modal :model-value="modelValue" @update:model-value="$emit('update:modelValue', $event)" :title="title" max-width="sm">
    <div class="space-y-4">
      <div v-if="danger" class="flex items-start gap-3 p-3 bg-red-950/30 border border-red-900/50 rounded-btn">
        <AlertTriangleIcon class="w-5 h-5 text-status-error shrink-0 mt-0.5" />
        <p class="text-sm text-text-secondary leading-relaxed">{{ message }}</p>
      </div>
      <p v-else class="text-sm text-text-secondary leading-relaxed">{{ message }}</p>
    </div>
    <template #footer>
      <button @click="$emit('update:modelValue', false)" class="btn-ghost">{{ cancelLabel }}</button>
      <button
        @click="() => { $emit('confirm'); $emit('update:modelValue', false); }"
        :class="danger ? 'btn-danger' : 'btn-primary'"
      >
        {{ confirmLabel }}
      </button>
    </template>
  </Modal>
</template>

<script setup>
import { AlertTriangleIcon } from 'lucide-vue-next';
import Modal from '@/Components/UI/Modal.vue';

defineProps({
  modelValue:   { type: Boolean, default: false },
  title:        { type: String,  default: 'Are you sure?' },
  message:      { type: String,  default: 'This action cannot be undone.' },
  confirmLabel: { type: String,  default: 'Confirm' },
  cancelLabel:  { type: String,  default: 'Cancel' },
  danger:       { type: Boolean, default: false },
});

defineEmits(['update:modelValue', 'confirm']);
</script>

KODA_FILE_5F725CBD

# --- resources/js/Components/UI/DataTable.vue ---
mkdir -p "resources/js/Components/UI"
cat > "resources/js/Components/UI/DataTable.vue" << 'KODA_FILE_A673A3D0'
<template>
  <div class="koda-card overflow-hidden p-0">
    <!-- Search + toolbar slot -->
    <div v-if="$slots.toolbar || searchable" class="px-5 py-4 border-b border-border flex items-center justify-between gap-4 flex-wrap">
      <div v-if="searchable" class="relative">
        <SearchIcon class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-text-muted pointer-events-none" />
        <input
          v-model="localSearch"
          type="text"
          :placeholder="searchPlaceholder"
          class="koda-input pl-9 text-sm w-56"
          @input="$emit('search', localSearch)"
        />
      </div>
      <slot name="toolbar" />
    </div>

    <!-- Table -->
    <div class="overflow-x-auto">
      <table class="koda-table w-full">
        <thead>
          <tr>
            <th v-for="col in columns" :key="col.key" :class="col.class">
              {{ col.label }}
            </th>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="(row, i) in rows"
            :key="row.id ?? i"
            :class="['transition-colors', onRowClick ? 'cursor-pointer' : '']"
            @click="onRowClick ? onRowClick(row) : null"
          >
            <td v-for="col in columns" :key="col.key" :class="col.tdClass">
              <slot :name="'cell-' + col.key" :row="row" :value="getVal(row, col.key)">
                <span class="text-sm text-text-secondary">{{ getVal(row, col.key) ?? '—' }}</span>
              </slot>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Empty state -->
    <div v-if="!rows.length" class="text-center py-16 text-text-muted">
      <component :is="emptyIcon" v-if="emptyIcon" class="w-12 h-12 mx-auto mb-3 text-border" />
      <p class="font-heading text-base">{{ emptyTitle }}</p>
      <p v-if="emptySubtitle" class="text-sm mt-1">{{ emptySubtitle }}</p>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { SearchIcon } from 'lucide-vue-next';

const props = defineProps({
  columns:         { type: Array,    required: true },
  rows:            { type: Array,    default: () => [] },
  searchable:      { type: Boolean,  default: false },
  searchPlaceholder: { type: String, default: 'Search…' },
  onRowClick:      { type: Function, default: null },
  emptyIcon:       { type: Object,   default: null },
  emptyTitle:      { type: String,   default: 'No data found' },
  emptySubtitle:   { type: String,   default: '' },
});

defineEmits(['search']);

const localSearch = ref('');

function getVal(row, key) {
  return key.split('.').reduce((obj, k) => obj?.[k], row);
}
</script>

KODA_FILE_A673A3D0

# --- resources/js/Components/UI/EmptyState.vue ---
mkdir -p "resources/js/Components/UI"
cat > "resources/js/Components/UI/EmptyState.vue" << 'KODA_FILE_A53512A1'
<template>
  <div class="text-center py-16 text-text-muted">
    <div v-if="icon" class="w-14 h-14 rounded-xl bg-bg-tertiary flex items-center justify-center mx-auto mb-4">
      <component :is="icon" class="w-7 h-7 text-border" />
    </div>
    <p class="font-heading text-lg text-text-primary">{{ title }}</p>
    <p v-if="subtitle" class="text-sm mt-1 text-text-muted max-w-sm mx-auto">{{ subtitle }}</p>
    <div v-if="$slots.action" class="mt-5">
      <slot name="action" />
    </div>
  </div>
</template>

<script setup>
defineProps({
  icon:     { type: Object,  default: null },
  title:    { type: String,  required: true },
  subtitle: { type: String,  default: '' },
});
</script>

KODA_FILE_A53512A1

# --- resources/js/Components/UI/FlashToast.vue ---
mkdir -p "resources/js/Components/UI"
cat > "resources/js/Components/UI/FlashToast.vue" << 'KODA_FILE_BAFE2042'
<template>
  <div class="fixed top-4 right-4 z-[200] flex flex-col gap-2 pointer-events-none" style="max-width: 360px;">
    <TransitionGroup name="toast">
      <div
        v-for="toast in toasts"
        :key="toast.id"
        :class="[
          'flex items-start gap-3 px-4 py-3 rounded-card border shadow-card-hover pointer-events-auto',
          toastClass(toast.type),
        ]"
      >
        <component :is="toastIcon(toast.type)" class="w-4 h-4 shrink-0 mt-0.5" />
        <p class="text-sm font-medium flex-1 leading-snug">{{ toast.message }}</p>
        <button @click="dismiss(toast.id)" class="text-current opacity-60 hover:opacity-100 transition-opacity shrink-0">
          <XIcon class="w-3.5 h-3.5" />
        </button>
      </div>
    </TransitionGroup>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue';
import { usePage } from '@inertiajs/vue3';
import { CheckCircleIcon, AlertCircleIcon, InfoIcon, AlertTriangleIcon, XIcon } from 'lucide-vue-next';

const page  = usePage();
const toasts = ref([]);
let nextId = 0;

function add(type, message) {
  if (!message) return;
  const id = ++nextId;
  toasts.value.push({ id, type, message });
  setTimeout(() => dismiss(id), 4500);
}

function dismiss(id) {
  toasts.value = toasts.value.filter(t => t.id !== id);
}

watch(
  () => page.props.flash,
  (flash) => {
    if (flash?.success) add('success', flash.success);
    if (flash?.error)   add('error',   flash.error);
    if (flash?.info)    add('info',    flash.info);
    if (flash?.warning) add('warning', flash.warning);
  },
  { deep: true }
);

function toastClass(type) {
  return {
    success: 'bg-green-950 border-green-800 text-green-300',
    error:   'bg-red-950 border-red-800 text-red-300',
    info:    'bg-blue-950 border-blue-800 text-blue-300',
    warning: 'bg-yellow-950 border-yellow-800 text-yellow-300',
  }[type] ?? 'bg-bg-secondary border-border text-text-secondary';
}

function toastIcon(type) {
  return { success: CheckCircleIcon, error: AlertCircleIcon, info: InfoIcon, warning: AlertTriangleIcon }[type] ?? InfoIcon;
}
</script>

<style scoped>
.toast-enter-active { transition: all 0.25s ease; }
.toast-leave-active { transition: all 0.2s ease; }
.toast-enter-from   { opacity: 0; transform: translateX(24px); }
.toast-leave-to     { opacity: 0; transform: translateX(24px); }
.toast-move         { transition: transform 0.2s ease; }
</style>

KODA_FILE_BAFE2042

# --- resources/js/Components/UI/InputError.vue ---
mkdir -p "resources/js/Components/UI"
cat > "resources/js/Components/UI/InputError.vue" << 'KODA_FILE_4B31D475'
<template>
  <p v-if="message" class="koda-error">{{ message }}</p>
</template>

<script setup>
defineProps({ message: String });
</script>

KODA_FILE_4B31D475

# --- resources/js/Components/UI/KodaLogo.vue ---
mkdir -p "resources/js/Components/UI"
cat > "resources/js/Components/UI/KodaLogo.vue" << 'KODA_FILE_CE381A9A'
<template>
  <svg :class="props.class" viewBox="0 0 120 32" fill="none" xmlns="http://www.w3.org/2000/svg" aria-label="Koda">
    <!-- K mark -->
    <rect width="28" height="28" rx="7" x="0" y="2" fill="#f97316"/>
    <path d="M8 8 L8 24 M8 16 L18 8 M8 16 L18 24" stroke="white" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"/>
    <!-- Wordmark -->
    <text x="36" y="22" font-family="'Space Grotesk', sans-serif" font-weight="700" font-size="18" fill="white" letter-spacing="-0.5">oda</text>
  </svg>
</template>

<script setup>
const props = defineProps({ class: String });
</script>

KODA_FILE_CE381A9A

# --- resources/js/Components/UI/Modal.vue ---
mkdir -p "resources/js/Components/UI"
cat > "resources/js/Components/UI/Modal.vue" << 'KODA_FILE_994329C6'
<template>
  <Teleport to="body">
    <Transition name="modal">
      <div v-if="modelValue" class="fixed inset-0 z-[100] flex items-center justify-center p-4" @click.self="$emit('update:modelValue', false)">
        <!-- Backdrop -->
        <div class="absolute inset-0 bg-black/60 backdrop-blur-sm" />
        <!-- Dialog -->
        <div :class="['relative bg-bg-secondary border border-border rounded-xl shadow-card-hover w-full animate-fade-in', maxWidthClass]">
          <!-- Header -->
          <div v-if="title" class="flex items-center justify-between px-6 py-4 border-b border-border">
            <h3 class="font-heading text-lg font-bold text-text-primary">{{ title }}</h3>
            <button @click="$emit('update:modelValue', false)" class="btn-ghost p-1.5">
              <XIcon class="w-4 h-4" />
            </button>
          </div>
          <!-- Body -->
          <div :class="['px-6 py-5', !title ? 'pt-6' : '']">
            <slot />
          </div>
          <!-- Footer -->
          <div v-if="$slots.footer" class="px-6 pb-5 flex items-center justify-end gap-3 border-t border-border pt-4">
            <slot name="footer" />
          </div>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

<script setup>
import { XIcon } from 'lucide-vue-next';
const props = defineProps({
  modelValue: Boolean,
  title: String,
  maxWidth: { type: String, default: 'lg' },
});
defineEmits(['update:modelValue']);
const maxWidthClass = {
  sm: 'max-w-sm', md: 'max-w-md', lg: 'max-w-lg', xl: 'max-w-xl', '2xl': 'max-w-2xl',
}[props.maxWidth] ?? 'max-w-lg';
</script>

<style scoped>
.modal-enter-active, .modal-leave-active { transition: opacity 0.2s; }
.modal-enter-from, .modal-leave-to { opacity: 0; }
</style>

KODA_FILE_994329C6

# --- resources/js/Components/UI/Pagination.vue ---
mkdir -p "resources/js/Components/UI"
cat > "resources/js/Components/UI/Pagination.vue" << 'KODA_FILE_4421FE29'
<template>
  <div v-if="links?.length > 3" class="flex items-center justify-center gap-1 mt-8">
    <template v-for="link in links" :key="link.label">
      <span
        v-if="!link.url"
        class="px-3 py-2 text-sm text-text-muted cursor-not-allowed"
        v-html="link.label"
      />
      <Link
        v-else
        :href="link.url"
        :class="[
          'px-3 py-2 text-sm rounded-btn transition-colors',
          link.active
            ? 'bg-accent text-white font-semibold'
            : 'text-text-secondary hover:text-text-primary hover:bg-bg-tertiary',
        ]"
        v-html="link.label"
        preserve-scroll
      />
    </template>
  </div>
</template>

<script setup>
import { Link } from '@inertiajs/vue3';
defineProps({ links: Array });
</script>

KODA_FILE_4421FE29

# --- resources/js/Components/UI/Skeleton.vue ---
mkdir -p "resources/js/Components/UI"
cat > "resources/js/Components/UI/Skeleton.vue" << 'KODA_FILE_F090CB46'
<template>
  <div :class="['skeleton rounded', heightClass, widthClass, props.class]" />
</template>

<script setup>
import { computed } from 'vue';

const props = defineProps({
  height: { type: String,  default: '4' },   // Tailwind h- value
  width:  { type: String,  default: 'full' }, // Tailwind w- value
  class:  { type: String,  default: '' },
});

const heightClass = computed(() => `h-${props.height}`);
const widthClass  = computed(() => `w-${props.width}`);
</script>

KODA_FILE_F090CB46

# --- resources/js/Components/UI/StarRating.vue ---
mkdir -p "resources/js/Components/UI"
cat > "resources/js/Components/UI/StarRating.vue" << 'KODA_FILE_B4672984'
<template>
  <div class="flex items-center gap-0.5">
    <button
      v-for="i in 5"
      :key="i"
      @click="interactive ? $emit('update:modelValue', i) : null"
      :class="['transition-transform', interactive ? 'cursor-pointer hover:scale-110' : 'cursor-default']"
      type="button"
    >
      <StarIcon
        :class="['w-4 h-4', i <= displayValue ? 'text-yellow-400 fill-yellow-400' : 'text-border']"
      />
    </button>
    <span v-if="showCount && count !== undefined" class="ml-1.5 text-xs text-text-muted">({{ count }})</span>
  </div>
</template>

<script setup>
import { computed } from 'vue';
import { StarIcon } from 'lucide-vue-next';
const props = defineProps({
  modelValue: { type: Number, default: 0 },
  interactive: { type: Boolean, default: false },
  showCount: { type: Boolean, default: false },
  count: Number,
});
defineEmits(['update:modelValue']);
const displayValue = computed(() => Math.round(props.modelValue));
</script>

KODA_FILE_B4672984

# --- resources/js/Layouts/AppLayout.vue ---
mkdir -p "resources/js/Layouts"
cat > "resources/js/Layouts/AppLayout.vue" << 'KODA_FILE_4B6BCC66'
<template>
  <div class="min-h-screen bg-bg-primary flex flex-col">
    <FlashToast />
    <!-- Navbar -->
    <nav class="sticky top-0 z-50 bg-bg-primary/90 backdrop-blur-md border-b border-border">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex items-center justify-between h-16">
          <!-- Logo -->
          <Link :href="route('home')" class="flex items-center gap-2 shrink-0">
            <KodaLogo class="h-8 w-auto" />
          </Link>

          <!-- Desktop Nav -->
          <div class="hidden md:flex items-center gap-1">
            <Link :href="route('products.index')" :class="navLinkClass('products')">Products</Link>
            <Link :href="route('vendors.index')" :class="navLinkClass('vendors')">Vendors</Link>
            <Link :href="route('categories.index')" :class="navLinkClass('categories')">Categories</Link>
          </div>

          <!-- Search -->
          <div class="hidden md:flex flex-1 max-w-sm mx-6">
            <SearchBox class="w-full" />
          </div>

          <!-- Right actions -->
          <div class="flex items-center gap-2">
            <!-- Cart -->
            <Link :href="route('cart.index')" class="btn-ghost relative">
              <ShoppingCartIcon class="w-5 h-5" />
              <span
                v-if="cartCount > 0"
                class="absolute -top-1 -right-1 w-4 h-4 bg-accent rounded-full text-white text-xs flex items-center justify-center font-bold"
              >{{ cartCount }}</span>
            </Link>

            <!-- Auth links -->
            <template v-if="$page.props.auth.user">
              <div class="relative" ref="userMenuRef">
                <button @click="userMenuOpen = !userMenuOpen" class="btn-ghost gap-2">
                  <div class="w-7 h-7 rounded-full bg-accent-muted border border-accent/30 flex items-center justify-center">
                    <span class="text-accent text-xs font-semibold">{{ initials }}</span>
                  </div>
                  <ChevronDownIcon class="w-4 h-4 text-text-muted" :class="{ 'rotate-180': userMenuOpen }" />
                </button>
                <!-- Dropdown -->
                <Transition name="fade-down">
                  <div v-if="userMenuOpen" class="absolute right-0 top-full mt-2 w-52 bg-bg-secondary border border-border rounded-card shadow-card-hover z-50 py-1 overflow-hidden">
                    <div class="px-4 py-3 border-b border-border">
                      <p class="text-sm font-semibold text-text-primary truncate">{{ $page.props.auth.user.name }}</p>
                      <p class="text-xs text-text-muted truncate">{{ $page.props.auth.user.email }}</p>
                    </div>
                    <Link
                      v-for="item in userMenuItems"
                      :key="item.label"
                      :href="item.href"
                      class="flex items-center gap-3 px-4 py-2.5 text-sm text-text-secondary hover:text-text-primary hover:bg-bg-tertiary transition-colors"
                      @click="userMenuOpen = false"
                    >
                      <component :is="item.icon" class="w-4 h-4" />
                      {{ item.label }}
                    </Link>
                    <div class="border-t border-border mt-1">
                      <button
                        @click="logout"
                        class="w-full flex items-center gap-3 px-4 py-2.5 text-sm text-status-error hover:bg-red-950/30 transition-colors"
                      >
                        <LogOutIcon class="w-4 h-4" />
                        Log out
                      </button>
                    </div>
                  </div>
                </Transition>
              </div>
            </template>
            <template v-else>
              <Link :href="route('login')" class="btn-ghost hidden sm:flex">Log in</Link>
              <Link :href="route('register')" class="btn-primary">Get started</Link>
            </template>

            <!-- Mobile menu -->
            <button @click="mobileMenuOpen = !mobileMenuOpen" class="btn-ghost md:hidden">
              <MenuIcon v-if="!mobileMenuOpen" class="w-5 h-5" />
              <XIcon v-else class="w-5 h-5" />
            </button>
          </div>
        </div>
      </div>

      <!-- Mobile Menu -->
      <Transition name="slide-down">
        <div v-if="mobileMenuOpen" class="md:hidden border-t border-border bg-bg-secondary px-4 py-4 space-y-2">
          <div class="relative mb-3">
            <SearchIcon class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-text-muted" />
            <input v-model="searchQuery" @keydown.enter="doSearch" type="text" placeholder="Search..." class="koda-input pl-10 text-sm" />
          </div>
          <Link :href="route('products.index')" class="nav-link block">Products</Link>
          <Link :href="route('vendors.index')" class="nav-link block">Vendors</Link>
          <Link :href="route('categories.index')" class="nav-link block">Categories</Link>
          <Link :href="route('cart.index')" class="nav-link block">Cart ({{ cartCount }})</Link>
          <template v-if="!$page.props.auth.user">
            <div class="pt-3 flex gap-2 border-t border-border">
              <Link :href="route('login')" class="btn-secondary flex-1">Log in</Link>
              <Link :href="route('register')" class="btn-primary flex-1">Sign up</Link>
            </div>
          </template>
        </div>
      </Transition>
    </nav>

    <!-- Page Content -->
    <main class="flex-1">
      <slot />
    </main>

    <!-- Footer -->
    <footer class="bg-bg-secondary border-t border-border mt-24">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
        <div class="grid grid-cols-1 md:grid-cols-4 gap-10">
          <!-- Brand -->
          <div class="md:col-span-1">
            <KodaLogo class="h-8 w-auto mb-4" />
            <p class="text-text-muted text-sm leading-relaxed">
              Your professional B2B marketplace. Source quality products from verified vendors.
            </p>
            <p class="mt-4 text-xs text-text-muted font-mono">Source. Sell. Succeed.</p>
          </div>

          <!-- Links -->
          <div v-for="col in footerLinks" :key="col.title">
            <h4 class="text-text-primary font-semibold font-heading text-sm mb-4">{{ col.title }}</h4>
            <ul class="space-y-2.5">
              <li v-for="link in col.links" :key="link.label">
                <Link :href="link.href" class="text-text-muted hover:text-accent text-sm transition-colors">{{ link.label }}</Link>
              </li>
            </ul>
          </div>
        </div>

        <div class="mt-12 pt-8 border-t border-border flex flex-col sm:flex-row items-center justify-between gap-4">
          <p class="text-text-muted text-sm">&copy; {{ new Date().getFullYear() }} Koda. All rights reserved.</p>
          <div class="flex items-center gap-6">
            <Link href="/privacy" class="text-text-muted hover:text-text-secondary text-sm transition-colors">Privacy</Link>
            <Link href="/terms" class="text-text-muted hover:text-text-secondary text-sm transition-colors">Terms</Link>
          </div>
        </div>
      </div>
    </footer>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue';
import { Link, router, usePage } from '@inertiajs/vue3';
import { onClickOutside } from '@vueuse/core';
import {
  ShoppingCartIcon, SearchIcon, ChevronDownIcon,
  MenuIcon, XIcon, LogOutIcon,
  LayoutDashboardIcon, PackageIcon, HeartIcon, UserIcon
} from 'lucide-vue-next';
import KodaLogo from '@/Components/UI/KodaLogo.vue';
import FlashToast from '@/Components/UI/FlashToast.vue';
import SearchBox from '@/Components/Shared/SearchBox.vue';

const page = usePage();
const searchQuery = ref('');
const userMenuOpen = ref(false);
const mobileMenuOpen = ref(false);
const userMenuRef = ref(null);

onClickOutside(userMenuRef, () => { userMenuOpen.value = false; });

const cartCount = computed(() => page.props.cartCount ?? 0);
const initials = computed(() => {
  const name = page.props.auth?.user?.name || '';
  return name.split(' ').map(n => n[0]).slice(0, 2).join('').toUpperCase();
});

function doSearch() {
  if (searchQuery.value.trim()) {
    router.get(route('products.index'), { q: searchQuery.value });
  }
}

function logout() {
  router.post(route('logout'));
}

function navLinkClass(section) {
  return ['nav-link', page.url.startsWith(`/${section}`) ? 'active' : ''];
}

const userMenuItems = computed(() => {
  const user = page.props.auth?.user;
  const role = user?.roles?.[0];
  const items = [
    { label: 'My Orders',   href: route('buyer.orders.index'),   icon: PackageIcon },
    { label: 'Wishlist',    href: route('buyer.wishlist.index'),  icon: HeartIcon },
    { label: 'Profile',     href: route('profile.edit'),          icon: UserIcon },
  ];
  if (role === 'vendor') {
    items.unshift({ label: 'Vendor Dashboard', href: route('vendor.dashboard'), icon: LayoutDashboardIcon });
  }
  if (role === 'admin') {
    items.unshift({ label: 'Admin Panel', href: route('admin.dashboard'), icon: LayoutDashboardIcon });
  }
  return items;
});

const footerLinks = [
  {
    title: 'Marketplace',
    links: [
      { label: 'Browse Products', href: '/products' },
      { label: 'Find Vendors',    href: '/vendors' },
      { label: 'Categories',      href: '/categories' },
      { label: 'Deals',           href: '/deals' },
    ],
  },
  {
    title: 'Sell on Koda',
    links: [
      { label: 'Become a Vendor', href: '/vendor/apply' },
      { label: 'Vendor Guide',    href: '/vendor/guide' },
      { label: 'Pricing',         href: '/pricing' },
    ],
  },
  {
    title: 'Company',
    links: [
      { label: 'About',    href: '/about' },
      { label: 'Contact',  href: '/contact' },
      { label: 'Privacy',  href: '/privacy' },
      { label: 'Terms',    href: '/terms' },
    ],
  },
];
</script>

<style scoped>
.fade-down-enter-active, .fade-down-leave-active {
  transition: opacity 0.15s ease, transform 0.15s ease;
}
.fade-down-enter-from { opacity: 0; transform: translateY(-6px); }
.fade-down-leave-to   { opacity: 0; transform: translateY(-6px); }

.slide-down-enter-active, .slide-down-leave-active {
  transition: opacity 0.2s ease, transform 0.2s ease;
}
.slide-down-enter-from { opacity: 0; transform: translateY(-8px); }
.slide-down-leave-to   { opacity: 0; transform: translateY(-8px); }
</style>

KODA_FILE_4B6BCC66

# --- resources/js/Layouts/DashboardLayout.vue ---
mkdir -p "resources/js/Layouts"
cat > "resources/js/Layouts/DashboardLayout.vue" << 'KODA_FILE_9AA80F8A'
<template>
  <div class="min-h-screen bg-bg-primary flex">
    <FlashToast />
    <!-- Sidebar -->
    <aside
      :class="[
        'fixed inset-y-0 left-0 z-50 flex flex-col bg-bg-secondary border-r border-border transition-all duration-300',
        sidebarCollapsed ? 'w-16' : 'w-64',
      ]"
    >
      <!-- Logo + toggle -->
      <div class="flex items-center justify-between h-16 px-4 border-b border-border shrink-0">
        <Transition name="fade">
          <KodaLogo v-if="!sidebarCollapsed" class="h-7 w-auto" />
        </Transition>
        <button @click="sidebarCollapsed = !sidebarCollapsed" class="btn-ghost p-2 shrink-0">
          <PanelLeftCloseIcon v-if="!sidebarCollapsed" class="w-4 h-4" />
          <PanelLeftOpenIcon v-else class="w-4 h-4" />
        </button>
      </div>

      <!-- Nav -->
      <nav class="flex-1 overflow-y-auto py-4 px-2 space-y-1">
        <template v-for="item in navItems" :key="item.label">
          <!-- Section divider -->
          <div v-if="item.divider" class="koda-divider my-2" />
          <div v-else-if="item.section && !sidebarCollapsed" class="px-3 pt-3 pb-1">
            <span class="text-xs font-semibold text-text-muted uppercase tracking-widest">{{ item.section }}</span>
          </div>
          <Link
            v-else
            :href="item.href"
            :class="[
              'flex items-center gap-3 px-3 py-2.5 rounded-btn text-sm font-medium transition-all duration-150',
              isActive(item.href)
                ? 'bg-accent-subtle text-accent'
                : 'text-text-secondary hover:text-text-primary hover:bg-bg-tertiary',
              sidebarCollapsed ? 'justify-center' : '',
            ]"
            :title="sidebarCollapsed ? item.label : undefined"
          >
            <component :is="item.icon" class="w-4 h-4 shrink-0" />
            <span v-if="!sidebarCollapsed" class="truncate">{{ item.label }}</span>
            <span v-if="!sidebarCollapsed && item.badge" class="ml-auto badge badge-accent text-xs px-1.5 py-0.5">{{ item.badge }}</span>
          </Link>
        </template>
      </nav>

      <!-- User -->
      <div class="border-t border-border p-3">
        <div :class="['flex items-center gap-3', sidebarCollapsed ? 'justify-center' : '']">
          <div class="w-8 h-8 rounded-full bg-accent-muted border border-accent/30 flex items-center justify-center shrink-0">
            <span class="text-accent text-xs font-bold">{{ initials }}</span>
          </div>
          <div v-if="!sidebarCollapsed" class="flex-1 min-w-0">
            <p class="text-sm font-semibold text-text-primary truncate">{{ $page.props.auth.user?.name }}</p>
            <p class="text-xs text-text-muted truncate">{{ roleName }}</p>
          </div>
          <button v-if="!sidebarCollapsed" @click="logout" class="btn-ghost p-1.5 shrink-0" title="Log out">
            <LogOutIcon class="w-4 h-4 text-text-muted hover:text-status-error transition-colors" />
          </button>
        </div>
      </div>
    </aside>

    <!-- Main content -->
    <div :class="['flex-1 flex flex-col min-h-screen transition-all duration-300', sidebarCollapsed ? 'ml-16' : 'ml-64']">
      <!-- Top bar -->
      <header class="sticky top-0 z-40 h-16 bg-bg-primary/90 backdrop-blur-md border-b border-border flex items-center justify-between px-6">
        <div>
          <h1 class="font-heading text-lg font-bold text-text-primary">{{ pageTitle }}</h1>
          <Breadcrumb v-if="breadcrumbs?.length" :items="breadcrumbs" class="hidden sm:flex" />
        </div>
        <div class="flex items-center gap-3">
          <!-- Notifications bell -->
          <button class="btn-ghost relative">
            <BellIcon class="w-5 h-5" />
            <span v-if="unreadNotifications > 0" class="absolute -top-1 -right-1 w-4 h-4 bg-status-error rounded-full text-white text-xs flex items-center justify-center">
              {{ unreadNotifications > 9 ? '9+' : unreadNotifications }}
            </span>
          </button>
          <!-- Link to storefront -->
          <Link :href="route('home')" class="btn-ghost hidden sm:flex gap-2">
            <ExternalLinkIcon class="w-4 h-4" />
            <span class="text-xs">View store</span>
          </Link>
        </div>
      </header>

      <!-- Slot -->
      <main class="flex-1 p-6">
        <slot />
      </main>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue';
import { Link, router, usePage } from '@inertiajs/vue3';
import {
  PanelLeftCloseIcon, PanelLeftOpenIcon, LogOutIcon,
  BellIcon, ExternalLinkIcon,
} from 'lucide-vue-next';
import KodaLogo from '@/Components/UI/KodaLogo.vue';
import Breadcrumb from '@/Components/UI/Breadcrumb.vue';
import FlashToast from '@/Components/UI/FlashToast.vue';

const props = defineProps({
  navItems:    { type: Array, default: () => [] },
  pageTitle:   { type: String, default: 'Dashboard' },
  breadcrumbs: { type: Array, default: () => [] },
});

const page = usePage();
const sidebarCollapsed = ref(false);

const initials = computed(() => {
  const name = page.props.auth?.user?.name || '';
  return name.split(' ').map(n => n[0]).slice(0, 2).join('').toUpperCase();
});

const roleName = computed(() => {
  const r = page.props.auth?.user?.roles?.[0];
  return r ? r.charAt(0).toUpperCase() + r.slice(1) : 'User';
});

const unreadNotifications = computed(() => page.props.unreadNotifications ?? 0);

function isActive(href) {
  return page.url === href || page.url.startsWith(href + '/');
}

function logout() {
  router.post(route('logout'));
}
</script>

<style scoped>
.fade-enter-active, .fade-leave-active { transition: opacity 0.2s; }
.fade-enter-from, .fade-leave-to { opacity: 0; }
</style>

KODA_FILE_9AA80F8A

# --- resources/js/Layouts/GuestLayout.vue ---
mkdir -p "resources/js/Layouts"
cat > "resources/js/Layouts/GuestLayout.vue" << 'KODA_FILE_B3FC97AC'
<template>
  <div class="min-h-screen bg-bg-primary">
    <slot />
  </div>
</template>

KODA_FILE_B3FC97AC

# --- resources/js/Pages/Admin/Buyers/Index.vue ---
mkdir -p "resources/js/Pages/Admin/Buyers"
cat > "resources/js/Pages/Admin/Buyers/Index.vue" << 'KODA_FILE_055468B4'
<template>
  <DashboardLayout :nav-items="adminNav" page-title="Buyers" :breadcrumbs="[{ label: 'Admin' }, { label: 'Buyers' }]">
    <!-- Toolbar -->
    <div class="flex items-center gap-3 mb-6">
      <div class="relative flex-1 max-w-sm">
        <SearchIcon class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-text-muted pointer-events-none" />
        <input v-model="search" type="text" placeholder="Search buyers…" class="koda-input pl-9 text-sm" />
      </div>
      <p class="text-text-muted text-sm shrink-0">{{ filteredBuyers.length }} buyer(s)</p>
    </div>

    <div class="koda-card overflow-hidden p-0">
      <div class="overflow-x-auto">
        <table class="koda-table">
          <thead>
            <tr>
              <th>Buyer</th>
              <th>Email</th>
              <th>Orders</th>
              <th>Total Spent</th>
              <th>Joined</th>
              <th class="w-20">Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="buyer in filteredBuyers" :key="buyer.id">
              <td>
                <div class="flex items-center gap-3">
                  <div class="w-8 h-8 rounded-full bg-accent-muted border border-accent/20 flex items-center justify-center shrink-0">
                    <span class="text-accent text-xs font-bold">{{ buyer.name?.[0]?.toUpperCase() }}</span>
                  </div>
                  <span class="text-sm font-medium text-text-primary">{{ buyer.name }}</span>
                </div>
              </td>
              <td class="text-xs text-text-muted">{{ buyer.email }}</td>
              <td class="text-xs text-text-secondary">{{ buyer.orders_count }}</td>
              <td class="text-sm font-semibold text-accent">{{ formatPrice(buyer.total_spent ?? 0) }}</td>
              <td class="text-xs text-text-muted">{{ buyer.created_at_human }}</td>
              <td>
                <button @click="viewBuyer(buyer)" class="btn-ghost p-1.5 text-text-muted hover:text-accent">
                  <EyeIcon class="w-3.5 h-3.5" />
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <div v-if="!filteredBuyers.length" class="text-center py-16 text-text-muted">
        <UsersIcon class="w-12 h-12 mx-auto mb-3 text-border" />
        <p>No buyers found</p>
      </div>
    </div>

    <Pagination :links="buyers.links" />
  </DashboardLayout>
</template>

<script setup>
import { ref, computed } from 'vue';
import { router } from '@inertiajs/vue3';
import { SearchIcon, EyeIcon, UsersIcon } from 'lucide-vue-next';
import DashboardLayout from '@/Layouts/DashboardLayout.vue';
import Pagination from '@/Components/UI/Pagination.vue';

const props = defineProps({
  buyers: { type: Object, required: true },
});

const search = ref('');

const filteredBuyers = computed(() => {
  let list = props.buyers.data ?? [];
  if (search.value) {
    const q = search.value.toLowerCase();
    list = list.filter(b => b.name?.toLowerCase().includes(q) || b.email?.toLowerCase().includes(q));
  }
  return list;
});

function formatPrice(p) {
  return new Intl.NumberFormat('en-KE', { style: 'currency', currency: 'KES', maximumFractionDigits: 0 }).format(p);
}

function viewBuyer(buyer) {
  // Future: open buyer detail modal
}

const adminNav = [
  { label: 'Dashboard',   href: route('admin.dashboard'),        icon: 'LayoutDashboardIcon' },
  { section: 'Marketplace' },
  { label: 'Vendors',     href: route('admin.vendors.index'),    icon: 'StoreIcon' },
  { label: 'Products',    href: route('admin.products.index'),   icon: 'PackageIcon' },
  { label: 'Orders',      href: route('admin.orders.index'),     icon: 'ShoppingBagIcon' },
  { label: 'Categories',  href: route('admin.categories.index'), icon: 'TagIcon' },
  { label: 'Reviews',     href: route('admin.reviews.index'),    icon: 'StarIcon' },
  { section: 'Users' },
  { label: 'Buyers',      href: route('admin.buyers.index'),     icon: 'UsersIcon' },
  { section: 'Finance' },
  { label: 'Payouts',     href: route('admin.payouts.index'),    icon: 'BanknoteIcon' },
  { label: 'Promo Codes', href: route('admin.promos.index'),     icon: 'TicketIcon' },
  { section: 'Settings' },
  { label: 'Settings',    href: route('admin.settings.index'),   icon: 'SettingsIcon' },
];
</script>

KODA_FILE_055468B4

# --- resources/js/Pages/Admin/Categories/Index.vue ---
mkdir -p "resources/js/Pages/Admin/Categories"
cat > "resources/js/Pages/Admin/Categories/Index.vue" << 'KODA_FILE_166C030D'
<template>
  <DashboardLayout :nav-items="adminNav" page-title="Categories" :breadcrumbs="[{ label: 'Admin' }, { label: 'Categories' }]">
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
      <!-- Category list -->
      <div class="lg:col-span-2">
        <div class="koda-card overflow-hidden p-0">
          <div class="px-5 py-4 border-b border-border flex items-center justify-between">
            <h3 class="font-heading text-sm font-bold">All Categories</h3>
            <span class="text-xs text-text-muted">{{ categories.length }} total</span>
          </div>
          <table class="koda-table">
            <thead><tr><th>Category</th><th>Products</th><th class="w-24">Actions</th></tr></thead>
            <tbody>
              <tr v-for="cat in categories" :key="cat.id">
                <td>
                  <div class="flex items-center gap-3">
                    <span class="text-xl">{{ cat.icon ?? '📦' }}</span>
                    <div>
                      <p class="text-sm font-medium text-text-primary">{{ cat.name }}</p>
                      <p class="text-xs text-text-muted font-mono">{{ cat.slug }}</p>
                    </div>
                  </div>
                </td>
                <td class="text-xs text-text-muted">{{ cat.products_count }}</td>
                <td>
                  <div class="flex items-center gap-1">
                    <button @click="editCategory(cat)" class="btn-ghost p-1.5 text-text-muted hover:text-accent">
                      <EditIcon class="w-3.5 h-3.5" />
                    </button>
                    <button @click="deleteCategory(cat)" class="btn-ghost p-1.5 text-text-muted hover:text-status-error">
                      <Trash2Icon class="w-3.5 h-3.5" />
                    </button>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
          <div v-if="!categories.length" class="text-center py-12 text-text-muted">
            <TagIcon class="w-10 h-10 mx-auto mb-2 text-border" />
            <p class="text-sm">No categories yet</p>
          </div>
        </div>
      </div>

      <!-- Add / Edit form -->
      <div>
        <div class="koda-card space-y-4 sticky top-24">
          <h3 class="font-heading text-sm font-bold">{{ editing ? 'Edit Category' : 'New Category' }}</h3>
          <form @submit.prevent="submit" class="space-y-4">
            <div>
              <label class="koda-label">Name <span class="text-status-error">*</span></label>
              <input v-model="form.name" type="text" class="koda-input" :class="{ error: errors.name }" placeholder="e.g. Electronics" />
              <p v-if="errors.name" class="koda-error">{{ errors.name }}</p>
            </div>
            <div>
              <label class="koda-label">Icon (emoji)</label>
              <input v-model="form.icon" type="text" class="koda-input" placeholder="💻" maxlength="4" />
            </div>
            <div>
              <label class="koda-label">Description</label>
              <textarea v-model="form.description" rows="2" class="koda-textarea" placeholder="Brief description..." />
            </div>
            <div class="flex gap-2">
              <button type="submit" :disabled="submitting" class="btn-primary flex-1">
                <LoaderIcon v-if="submitting" class="w-4 h-4 animate-spin" />
                {{ editing ? 'Update' : 'Add Category' }}
              </button>
              <button v-if="editing" type="button" @click="resetForm" class="btn-ghost px-3">
                <XIcon class="w-4 h-4" />
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </DashboardLayout>
</template>

<script setup>
import { ref } from 'vue';
import { router } from '@inertiajs/vue3';
import { EditIcon, Trash2Icon, TagIcon, LoaderIcon, XIcon } from 'lucide-vue-next';
import DashboardLayout from '@/Layouts/DashboardLayout.vue';

const props = defineProps({
  categories: { type: Array, default: () => [] },
  errors:     { type: Object, default: () => ({}) },
});

const submitting = ref(false);
const editing    = ref(null);
const form       = ref({ name: '', icon: '', description: '' });

function editCategory(cat) {
  editing.value  = cat;
  form.value     = { name: cat.name, icon: cat.icon ?? '', description: cat.description ?? '' };
}

function resetForm() {
  editing.value  = null;
  form.value     = { name: '', icon: '', description: '' };
}

function submit() {
  submitting.value = true;
  if (editing.value) {
    router.put(route('admin.categories.update', editing.value.id), form.value, {
      preserveScroll: true,
      onFinish: () => { submitting.value = false; resetForm(); },
    });
  } else {
    router.post(route('admin.categories.store'), form.value, {
      preserveScroll: true,
      onFinish: () => { submitting.value = false; resetForm(); },
    });
  }
}

function deleteCategory(cat) {
  if (cat.products_count > 0) {
    alert(`Cannot delete "${cat.name}" — it has ${cat.products_count} product(s).`);
    return;
  }
  if (confirm(`Delete category "${cat.name}"?`)) {
    router.delete(route('admin.categories.destroy', cat.id), { preserveScroll: true });
  }
}

const adminNav = [
  { label: 'Dashboard',   href: route('admin.dashboard'),        icon: 'LayoutDashboardIcon' },
  { section: 'Marketplace' },
  { label: 'Vendors',     href: route('admin.vendors.index'),    icon: 'StoreIcon' },
  { label: 'Products',    href: route('admin.products.index'),   icon: 'PackageIcon' },
  { label: 'Orders',      href: route('admin.orders.index'),     icon: 'ShoppingBagIcon' },
  { label: 'Categories',  href: route('admin.categories.index'), icon: 'TagIcon' },
  { label: 'Reviews',     href: route('admin.reviews.index'),    icon: 'StarIcon' },
  { section: 'Users' },
  { label: 'Buyers',      href: route('admin.buyers.index'),     icon: 'UsersIcon' },
  { section: 'Finance' },
  { label: 'Payouts',     href: route('admin.payouts.index'),    icon: 'BanknoteIcon' },
  { label: 'Promo Codes', href: route('admin.promos.index'),     icon: 'TicketIcon' },
  { section: 'Settings' },
  { label: 'Settings',    href: route('admin.settings.index'),   icon: 'SettingsIcon' },
];
</script>

KODA_FILE_166C030D

# --- resources/js/Pages/Admin/Dashboard.vue ---
mkdir -p "resources/js/Pages/Admin"
cat > "resources/js/Pages/Admin/Dashboard.vue" << 'KODA_FILE_96269B31'
<template>
  <DashboardLayout
    :nav-items="adminNav"
    page-title="Dashboard"
    :breadcrumbs="[{ label: 'Admin' }, { label: 'Dashboard' }]"
  >
    <!-- Stats -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
      <StatsCard label="Total Revenue"    :value="formatPrice(stats.revenue)"    :change="stats.revenueChange"    :icon="DollarSignIcon" />
      <StatsCard label="Total Orders"     :value="stats.orders"                  :change="stats.ordersChange"     :icon="ShoppingBagIcon" icon-bg="bg-blue-950" icon-color="text-blue-400" />
      <StatsCard label="Active Vendors"   :value="stats.vendors"                 :change="stats.vendorsChange"    :icon="StoreIcon"       icon-bg="bg-green-950" icon-color="text-green-400" />
      <StatsCard label="Total Buyers"     :value="stats.buyers"                  :change="stats.buyersChange"     :icon="UsersIcon"       icon-bg="bg-purple-950" icon-color="text-purple-400" />
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-6">
      <!-- Revenue chart -->
      <div class="lg:col-span-2 koda-card">
        <div class="flex items-center justify-between mb-6">
          <h3 class="font-heading text-base font-bold">Revenue Overview</h3>
          <select v-model="chartPeriod" class="koda-select text-xs w-32">
            <option value="7">Last 7 days</option>
            <option value="30">Last 30 days</option>
            <option value="90">Last 3 months</option>
          </select>
        </div>
        <div class="h-56">
          <Line :data="chartData" :options="chartOptions" />
        </div>
      </div>

      <!-- Pending approvals -->
      <div class="koda-card">
        <div class="flex items-center justify-between mb-4">
          <h3 class="font-heading text-base font-bold">Pending Approvals</h3>
          <span class="badge badge-warning">{{ pendingVendors.length }}</span>
        </div>
        <div class="space-y-3">
          <div v-for="vendor in pendingVendors.slice(0, 5)" :key="vendor.id" class="flex items-center gap-3">
            <div class="w-8 h-8 rounded-lg bg-accent-subtle flex items-center justify-center shrink-0">
              <span class="text-accent text-xs font-bold">{{ vendor.store_name?.[0] }}</span>
            </div>
            <div class="flex-1 min-w-0">
              <p class="text-sm font-medium text-text-primary truncate">{{ vendor.store_name }}</p>
              <p class="text-xs text-text-muted">{{ vendor.created_at_human }}</p>
            </div>
            <Link :href="route('admin.vendors.show', vendor.id)" class="btn-outline text-xs px-2.5 py-1">Review</Link>
          </div>
          <Link v-if="pendingVendors.length > 5" :href="route('admin.vendors.index', { status: 'pending' })" class="btn-ghost w-full text-xs text-text-muted justify-center">
            View all {{ pendingVendors.length }} pending
          </Link>
          <div v-if="!pendingVendors.length" class="text-center py-4 text-text-muted text-sm">No pending approvals</div>
        </div>
      </div>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
      <!-- Recent orders -->
      <div class="koda-card">
        <div class="flex items-center justify-between mb-4">
          <h3 class="font-heading text-base font-bold">Recent Orders</h3>
          <Link :href="route('admin.orders.index')" class="text-accent text-xs hover:text-accent-light transition-colors">View all</Link>
        </div>
        <table class="koda-table">
          <thead>
            <tr>
              <th>Order</th>
              <th>Customer</th>
              <th>Amount</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="order in recentOrders" :key="order.id">
              <td class="font-mono text-xs text-text-muted">#{{ order.order_number }}</td>
              <td class="text-text-primary text-xs">{{ order.buyer?.name }}</td>
              <td class="font-semibold text-accent text-xs">{{ formatPrice(order.total) }}</td>
              <td><span :class="orderStatusClass(order.status)">{{ order.status }}</span></td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- Top vendors -->
      <div class="koda-card">
        <div class="flex items-center justify-between mb-4">
          <h3 class="font-heading text-base font-bold">Top Vendors</h3>
          <Link :href="route('admin.vendors.index')" class="text-accent text-xs hover:text-accent-light transition-colors">View all</Link>
        </div>
        <div class="space-y-3">
          <div v-for="(vendor, i) in topVendors" :key="vendor.id" class="flex items-center gap-3">
            <span class="text-xs text-text-muted w-5 text-center font-mono">{{ i + 1 }}</span>
            <div class="w-8 h-8 rounded-lg overflow-hidden bg-bg-tertiary border border-border shrink-0">
              <img v-if="vendor.logo" :src="vendor.logo" class="w-full h-full object-cover" />
            </div>
            <div class="flex-1 min-w-0">
              <p class="text-sm font-medium text-text-primary truncate">{{ vendor.store_name }}</p>
              <p class="text-xs text-text-muted">{{ vendor.orders_count }} orders</p>
            </div>
            <span class="text-sm font-bold text-accent shrink-0">{{ formatPrice(vendor.revenue) }}</span>
          </div>
        </div>
      </div>
    </div>
  </DashboardLayout>
</template>

<script setup>
import { ref, computed } from 'vue';
import { Link } from '@inertiajs/vue3';
import { Line } from 'vue-chartjs';
import {
  Chart as ChartJS, LineElement, PointElement, LinearScale,
  CategoryScale, Tooltip, Filler,
} from 'chart.js';
import {
  DollarSignIcon, ShoppingBagIcon, StoreIcon, UsersIcon,
} from 'lucide-vue-next';
import DashboardLayout from '@/Layouts/DashboardLayout.vue';
import StatsCard from '@/Components/Shared/StatsCard.vue';

ChartJS.register(LineElement, PointElement, LinearScale, CategoryScale, Tooltip, Filler);

const props = defineProps({
  stats:          { type: Object, default: () => ({}) },
  pendingVendors: { type: Array, default: () => [] },
  recentOrders:   { type: Array, default: () => [] },
  topVendors:     { type: Array, default: () => [] },
  chartLabels:    { type: Array, default: () => [] },
  chartRevenue:   { type: Array, default: () => [] },
});

const chartPeriod = ref('30');

const chartData = computed(() => ({
  labels: props.chartLabels,
  datasets: [{
    label: 'Revenue',
    data: props.chartRevenue,
    borderColor: '#f97316',
    backgroundColor: 'rgba(249,115,22,0.08)',
    fill: true,
    tension: 0.4,
    pointBackgroundColor: '#f97316',
    pointRadius: 3,
  }],
}));

const chartOptions = {
  responsive: true,
  maintainAspectRatio: false,
  plugins: { legend: { display: false }, tooltip: { mode: 'index' } },
  scales: {
    x: { grid: { color: '#262626' }, ticks: { color: '#6b6b6b', font: { size: 11 } } },
    y: { grid: { color: '#262626' }, ticks: { color: '#6b6b6b', font: { size: 11 }, callback: v => 'KES ' + v.toLocaleString() } },
  },
};

function formatPrice(p) {
  return new Intl.NumberFormat('en-KE', { style: 'currency', currency: 'KES', maximumFractionDigits: 0 }).format(p ?? 0);
}

function orderStatusClass(status) {
  const map = {
    pending:    'badge badge-warning',
    processing: 'badge badge-info',
    shipped:    'badge badge-neutral',
    delivered:  'badge badge-success',
    cancelled:  'badge badge-error',
  };
  return map[status] ?? 'badge badge-neutral';
}

const adminNav = [
  { label: 'Dashboard',    href: route('admin.dashboard'),         icon: 'LayoutDashboardIcon' },
  { section: 'Marketplace' },
  { label: 'Vendors',      href: route('admin.vendors.index'),      icon: 'StoreIcon' },
  { label: 'Products',     href: route('admin.products.index'),     icon: 'PackageIcon' },
  { label: 'Orders',       href: route('admin.orders.index'),       icon: 'ShoppingBagIcon' },
  { label: 'Categories',   href: route('admin.categories.index'),   icon: 'TagIcon' },
  { label: 'Reviews',      href: route('admin.reviews.index'),      icon: 'StarIcon' },
  { section: 'Users' },
  { label: 'Buyers',       href: route('admin.buyers.index'),       icon: 'UsersIcon' },
  { section: 'Finance' },
  { label: 'Payouts',      href: route('admin.payouts.index'),      icon: 'BanknoteIcon' },
  { label: 'Promo Codes',  href: route('admin.promos.index'),       icon: 'TicketIcon' },
  { section: 'Settings' },
  { label: 'Settings',     href: route('admin.settings.index'),     icon: 'SettingsIcon' },
];
</script>

KODA_FILE_96269B31

# --- resources/js/Pages/Admin/Orders/Index.vue ---
mkdir -p "resources/js/Pages/Admin/Orders"
cat > "resources/js/Pages/Admin/Orders/Index.vue" << 'KODA_FILE_764C5A78'
<template>
  <DashboardLayout :nav-items="adminNav" page-title="Orders" :breadcrumbs="[{ label: 'Admin' }, { label: 'Orders' }]">
    <!-- Stats strip -->
    <div class="grid grid-cols-2 sm:grid-cols-4 gap-3 mb-6">
      <div v-for="s in orderStats" :key="s.label" class="koda-card py-3">
        <p class="text-xs text-text-muted">{{ s.label }}</p>
        <p class="font-heading text-xl font-bold mt-0.5" :class="s.color">{{ s.value }}</p>
      </div>
    </div>

    <!-- Toolbar -->
    <div class="flex items-center gap-3 flex-wrap mb-5">
      <div class="relative">
        <SearchIcon class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-text-muted pointer-events-none" />
        <input v-model="search" type="text" placeholder="Order # or buyer…" class="koda-input pl-9 text-sm w-56" />
      </div>
      <select v-model="statusFilter" class="koda-select text-sm w-40">
        <option value="">All statuses</option>
        <option value="pending">Pending</option>
        <option value="processing">Processing</option>
        <option value="shipped">Shipped</option>
        <option value="delivered">Delivered</option>
        <option value="cancelled">Cancelled</option>
      </select>
      <select v-model="paymentFilter" class="koda-select text-sm w-36">
        <option value="">All payments</option>
        <option value="paid">Paid</option>
        <option value="unpaid">Unpaid</option>
        <option value="refunded">Refunded</option>
      </select>
    </div>

    <div class="koda-card overflow-hidden p-0">
      <div class="overflow-x-auto">
        <table class="koda-table">
          <thead>
            <tr>
              <th>Order #</th>
              <th>Buyer</th>
              <th>Items</th>
              <th>Total</th>
              <th>Payment</th>
              <th>Status</th>
              <th>Date</th>
              <th class="w-16">Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="order in filteredOrders" :key="order.id">
              <td class="font-mono text-sm text-accent font-semibold">#{{ order.order_number }}</td>
              <td>
                <div>
                  <p class="text-sm text-text-primary">{{ order.buyer?.name }}</p>
                  <p class="text-xs text-text-muted">{{ order.shipping_city }}</p>
                </div>
              </td>
              <td class="text-xs text-text-muted">{{ order.items_count }}</td>
              <td class="font-semibold text-text-primary text-sm">{{ formatPrice(order.total) }}</td>
              <td><span :class="paymentBadge(order.payment_status)">{{ order.payment_status }}</span></td>
              <td>
                <select
                  :value="order.status"
                  @change="updateStatus(order, $event.target.value)"
                  :class="['text-xs rounded-full px-2.5 py-1 border-0 cursor-pointer font-medium', statusSelectBg(order.status)]"
                >
                  <option value="pending">Pending</option>
                  <option value="processing">Processing</option>
                  <option value="shipped">Shipped</option>
                  <option value="delivered">Delivered</option>
                  <option value="cancelled">Cancelled</option>
                </select>
              </td>
              <td class="text-xs text-text-muted">{{ order.created_at_human }}</td>
              <td>
                <Link :href="route('admin.orders.show', order.id)" class="btn-ghost p-1.5 text-text-muted hover:text-accent">
                  <EyeIcon class="w-3.5 h-3.5" />
                </Link>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <div v-if="!filteredOrders.length" class="text-center py-16 text-text-muted">
        <ShoppingBagIcon class="w-12 h-12 mx-auto mb-3 text-border" />
        <p>No orders found</p>
      </div>
    </div>

    <Pagination :links="orders.links" />
  </DashboardLayout>
</template>

<script setup>
import { ref, computed } from 'vue';
import { Link, router } from '@inertiajs/vue3';
import { SearchIcon, EyeIcon, ShoppingBagIcon } from 'lucide-vue-next';
import DashboardLayout from '@/Layouts/DashboardLayout.vue';
import Pagination from '@/Components/UI/Pagination.vue';

const props = defineProps({
  orders: { type: Object, required: true },
});

const search        = ref('');
const statusFilter  = ref('');
const paymentFilter = ref('');

const filteredOrders = computed(() => {
  let list = props.orders.data ?? [];
  if (search.value)        list = list.filter(o => o.order_number.includes(search.value) || o.buyer?.name?.toLowerCase().includes(search.value.toLowerCase()));
  if (statusFilter.value)  list = list.filter(o => o.status === statusFilter.value);
  if (paymentFilter.value) list = list.filter(o => o.payment_status === paymentFilter.value);
  return list;
});

const orderStats = computed(() => {
  const data = props.orders.data ?? [];
  return [
    { label: 'Total',      value: props.orders.total ?? data.length, color: 'text-text-primary' },
    { label: 'Pending',    value: data.filter(o => o.status === 'pending').length,   color: 'text-status-warning' },
    { label: 'Delivered',  value: data.filter(o => o.status === 'delivered').length, color: 'text-status-success' },
    { label: 'Cancelled',  value: data.filter(o => o.status === 'cancelled').length, color: 'text-status-error' },
  ];
});

function formatPrice(p) { return new Intl.NumberFormat('en-KE', { style: 'currency', currency: 'KES' }).format(p); }

function paymentBadge(s) { return { paid: 'badge badge-success', unpaid: 'badge badge-warning', refunded: 'badge badge-info' }[s] ?? 'badge badge-neutral'; }
function statusSelectBg(s) {
  return { pending: 'bg-yellow-950 text-yellow-400', processing: 'bg-blue-950 text-blue-400', shipped: 'bg-bg-tertiary text-text-secondary', delivered: 'bg-green-950 text-green-400', cancelled: 'bg-red-950 text-red-400' }[s] ?? 'bg-bg-tertiary text-text-muted';
}

function updateStatus(order, status) {
  router.patch(route('admin.orders.status', order.id), { status }, { preserveScroll: true });
}

const adminNav = [
  { label: 'Dashboard',   href: route('admin.dashboard'),        icon: 'LayoutDashboardIcon' },
  { section: 'Marketplace' },
  { label: 'Vendors',     href: route('admin.vendors.index'),    icon: 'StoreIcon' },
  { label: 'Products',    href: route('admin.products.index'),   icon: 'PackageIcon' },
  { label: 'Orders',      href: route('admin.orders.index'),     icon: 'ShoppingBagIcon' },
  { label: 'Categories',  href: route('admin.categories.index'), icon: 'TagIcon' },
  { label: 'Reviews',     href: route('admin.reviews.index'),    icon: 'StarIcon' },
  { section: 'Users' },
  { label: 'Buyers',      href: route('admin.buyers.index'),     icon: 'UsersIcon' },
  { section: 'Finance' },
  { label: 'Payouts',     href: route('admin.payouts.index'),    icon: 'BanknoteIcon' },
  { label: 'Promo Codes', href: route('admin.promos.index'),     icon: 'TicketIcon' },
  { section: 'Settings' },
  { label: 'Settings',    href: route('admin.settings.index'),   icon: 'SettingsIcon' },
];
</script>

KODA_FILE_764C5A78

# --- resources/js/Pages/Admin/Orders/Show.vue ---
mkdir -p "resources/js/Pages/Admin/Orders"
cat > "resources/js/Pages/Admin/Orders/Show.vue" << 'KODA_FILE_F327A0BB'
<template>
  <DashboardLayout
    :nav-items="adminNav"
    :page-title="'Order #' + order.order_number"
    :breadcrumbs="[{ label: 'Orders', href: route('admin.orders.index') }, { label: '#' + order.order_number }]"
  >
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
      <!-- Items + timeline -->
      <div class="lg:col-span-2 space-y-5">
        <!-- Status bar -->
        <div class="koda-card flex items-center justify-between gap-4 flex-wrap">
          <div>
            <p class="text-xs text-text-muted">Order placed</p>
            <p class="text-sm font-medium text-text-primary">{{ order.created_at_human }}</p>
          </div>
          <div>
            <p class="text-xs text-text-muted">Payment</p>
            <span :class="order.payment_status === 'paid' ? 'badge badge-success' : 'badge badge-warning'">{{ order.payment_status }}</span>
          </div>
          <div>
            <p class="text-xs text-text-muted">Status</p>
            <select
              :value="order.status"
              @change="updateStatus($event.target.value)"
              :class="['text-xs rounded-full px-3 py-1.5 border-0 cursor-pointer font-semibold', statusSelectBg(order.status)]"
            >
              <option value="pending">Pending</option>
              <option value="processing">Processing</option>
              <option value="shipped">Shipped</option>
              <option value="delivered">Delivered</option>
              <option value="cancelled">Cancelled</option>
            </select>
          </div>
          <div>
            <p class="text-xs text-text-muted">Total</p>
            <p class="font-heading font-bold text-accent">{{ formatPrice(order.total) }}</p>
          </div>
        </div>

        <!-- Order items -->
        <div class="koda-card">
          <h3 class="font-heading text-sm font-bold mb-4">Items ({{ order.items?.length }})</h3>
          <div class="space-y-4">
            <div v-for="item in order.items" :key="item.id" class="flex items-center gap-4 pb-4 border-b border-border last:border-0 last:pb-0">
              <div class="w-12 h-12 rounded-lg overflow-hidden bg-bg-tertiary border border-border shrink-0">
                <img v-if="item.product?.thumbnail" :src="item.product.thumbnail" class="w-full h-full object-cover" />
              </div>
              <div class="flex-1 min-w-0">
                <p class="text-sm font-semibold text-text-primary truncate">{{ item.product?.name }}</p>
                <p class="text-xs text-text-muted">{{ item.product?.vendor?.store_name }} · Qty: {{ item.quantity }}</p>
                <span :class="statusBadge(item.status)" class="mt-1 inline-block text-xs">{{ item.status }}</span>
              </div>
              <div class="text-right shrink-0">
                <p class="text-xs text-text-muted">{{ formatPrice(item.unit_price) }} each</p>
                <p class="font-semibold text-accent text-sm">{{ formatPrice(item.subtotal) }}</p>
              </div>
            </div>
          </div>
        </div>

        <!-- Financials -->
        <div class="koda-card">
          <h3 class="font-heading text-sm font-bold mb-4">Order Summary</h3>
          <div class="space-y-2 text-sm text-text-secondary">
            <div class="flex justify-between"><span>Subtotal</span><span>{{ formatPrice(order.subtotal) }}</span></div>
            <div v-if="order.discount > 0" class="flex justify-between text-status-success"><span>Discount</span><span>-{{ formatPrice(order.discount) }}</span></div>
            <div class="flex justify-between"><span>Shipping</span><span>{{ order.shipping > 0 ? formatPrice(order.shipping) : 'Free' }}</span></div>
          </div>
          <div class="flex justify-between font-heading font-bold mt-3 pt-3 border-t border-border text-base">
            <span>Total</span><span class="text-accent">{{ formatPrice(order.total) }}</span>
          </div>
        </div>
      </div>

      <!-- Sidebar -->
      <div class="space-y-4">
        <!-- Buyer -->
        <div class="koda-card">
          <h3 class="font-heading text-sm font-bold mb-3">Buyer</h3>
          <div class="flex items-center gap-3 mb-3">
            <div class="w-8 h-8 rounded-full bg-accent-muted flex items-center justify-center shrink-0">
              <span class="text-accent text-xs font-bold">{{ order.buyer?.name?.[0] }}</span>
            </div>
            <div>
              <p class="text-sm font-medium text-text-primary">{{ order.buyer?.name }}</p>
              <p class="text-xs text-text-muted">{{ order.buyer?.email }}</p>
            </div>
          </div>
        </div>

        <!-- Shipping -->
        <div class="koda-card">
          <h3 class="font-heading text-sm font-bold mb-3 flex items-center gap-2">
            <TruckIcon class="w-4 h-4 text-accent" /> Shipping Address
          </h3>
          <div class="text-sm text-text-secondary space-y-1">
            <p class="font-medium text-text-primary">{{ order.shipping_name }}</p>
            <p>{{ order.shipping_address }}</p>
            <p>{{ order.shipping_city }}, {{ order.shipping_country }}</p>
            <p v-if="order.shipping_phone" class="text-text-muted">{{ order.shipping_phone }}</p>
          </div>
        </div>

        <!-- Payment -->
        <div class="koda-card">
          <h3 class="font-heading text-sm font-bold mb-3">Payment</h3>
          <div class="space-y-1.5 text-sm text-text-secondary">
            <div class="flex justify-between"><span>Method</span><span class="capitalize text-text-primary">{{ order.payment_method }}</span></div>
            <div class="flex justify-between"><span>Status</span>
              <span :class="order.payment_status === 'paid' ? 'badge badge-success' : 'badge badge-warning'">{{ order.payment_status }}</span>
            </div>
          </div>
        </div>

        <!-- Notes -->
        <div v-if="order.notes" class="koda-card">
          <h3 class="font-heading text-sm font-bold mb-2">Order Notes</h3>
          <p class="text-sm text-text-secondary italic">{{ order.notes }}</p>
        </div>

        <Link :href="route('admin.orders.index')" class="btn-ghost w-full justify-center gap-2 text-sm text-text-muted">
          <ArrowLeftIcon class="w-4 h-4" /> Back to Orders
        </Link>
      </div>
    </div>
  </DashboardLayout>
</template>

<script setup>
import { Link, router } from '@inertiajs/vue3';
import { TruckIcon, ArrowLeftIcon } from 'lucide-vue-next';
import DashboardLayout from '@/Layouts/DashboardLayout.vue';

const props = defineProps({ order: { type: Object, required: true } });

function formatPrice(p) {
  return new Intl.NumberFormat('en-KE', { style: 'currency', currency: 'KES' }).format(p ?? 0);
}

function statusBadge(s) {
  return { pending: 'badge badge-warning', processing: 'badge badge-info', shipped: 'badge badge-neutral', delivered: 'badge badge-success', cancelled: 'badge badge-error' }[s] ?? 'badge badge-neutral';
}

function statusSelectBg(s) {
  return { pending: 'bg-yellow-950 text-yellow-400', processing: 'bg-blue-950 text-blue-400', shipped: 'bg-bg-tertiary text-text-secondary', delivered: 'bg-green-950 text-green-400', cancelled: 'bg-red-950 text-red-400' }[s] ?? 'bg-bg-tertiary text-text-muted';
}

function updateStatus(status) {
  router.patch(route('admin.orders.status', props.order.id), { status }, { preserveScroll: true });
}

const adminNav = [
  { label: 'Dashboard',   href: route('admin.dashboard'),        icon: 'LayoutDashboardIcon' },
  { section: 'Marketplace' },
  { label: 'Vendors',     href: route('admin.vendors.index'),    icon: 'StoreIcon' },
  { label: 'Products',    href: route('admin.products.index'),   icon: 'PackageIcon' },
  { label: 'Orders',      href: route('admin.orders.index'),     icon: 'ShoppingBagIcon' },
  { label: 'Categories',  href: route('admin.categories.index'), icon: 'TagIcon' },
  { label: 'Reviews',     href: route('admin.reviews.index'),    icon: 'StarIcon' },
  { section: 'Users' },
  { label: 'Buyers',      href: route('admin.buyers.index'),     icon: 'UsersIcon' },
  { section: 'Finance' },
  { label: 'Payouts',     href: route('admin.payouts.index'),    icon: 'BanknoteIcon' },
  { label: 'Promo Codes', href: route('admin.promos.index'),     icon: 'TicketIcon' },
  { section: 'Settings' },
  { label: 'Settings',    href: route('admin.settings.index'),   icon: 'SettingsIcon' },
];
</script>

KODA_FILE_F327A0BB

# --- resources/js/Pages/Admin/Payouts/Index.vue ---
mkdir -p "resources/js/Pages/Admin/Payouts"
cat > "resources/js/Pages/Admin/Payouts/Index.vue" << 'KODA_FILE_6AEB3CCA'
<template>
  <DashboardLayout :nav-items="adminNav" page-title="Payouts" :breadcrumbs="[{ label: 'Admin' }, { label: 'Payouts' }]">
    <!-- Stats -->
    <div class="grid grid-cols-2 sm:grid-cols-4 gap-4 mb-6">
      <div v-for="s in payoutStats" :key="s.label" class="koda-card py-3">
        <p class="text-xs text-text-muted">{{ s.label }}</p>
        <p class="font-heading text-xl font-bold mt-0.5" :class="s.color">{{ s.value }}</p>
      </div>
    </div>

    <!-- Filter -->
    <div class="flex items-center gap-3 mb-5">
      <select v-model="statusFilter" class="koda-select text-sm w-36">
        <option value="">All statuses</option>
        <option value="pending">Pending</option>
        <option value="approved">Approved</option>
        <option value="paid">Paid</option>
        <option value="rejected">Rejected</option>
      </select>
    </div>

    <div class="koda-card overflow-hidden p-0">
      <div class="overflow-x-auto">
        <table class="koda-table">
          <thead>
            <tr>
              <th>Vendor</th>
              <th>Amount</th>
              <th>Method</th>
              <th>Account</th>
              <th>Status</th>
              <th>Requested</th>
              <th class="w-32">Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="payout in filteredPayouts" :key="payout.id">
              <td class="text-sm text-text-primary">{{ payout.vendor?.store_name }}</td>
              <td class="font-semibold text-accent text-sm">{{ formatPrice(payout.amount) }}</td>
              <td class="text-xs text-text-muted capitalize">{{ payout.method }}</td>
              <td class="text-xs text-text-muted font-mono">{{ payout.account }}</td>
              <td><span :class="statusClass(payout.status)">{{ payout.status }}</span></td>
              <td class="text-xs text-text-muted">{{ payout.created_at_human }}</td>
              <td>
                <div class="flex gap-1" v-if="payout.status === 'pending'">
                  <button @click="process(payout, 'paid')" class="btn-ghost p-1.5 text-status-success hover:bg-green-950/30" title="Mark paid">
                    <CheckIcon class="w-3.5 h-3.5" />
                  </button>
                  <button @click="process(payout, 'rejected')" class="btn-ghost p-1.5 text-status-error hover:bg-red-950/30" title="Reject">
                    <XIcon class="w-3.5 h-3.5" />
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <div v-if="!filteredPayouts.length" class="text-center py-16 text-text-muted">
        <BanknoteIcon class="w-12 h-12 mx-auto mb-3 text-border" />
        <p>No payout requests</p>
      </div>
    </div>
  </DashboardLayout>
</template>

<script setup>
import { ref, computed } from 'vue';
import { router } from '@inertiajs/vue3';
import { CheckIcon, XIcon, BanknoteIcon } from 'lucide-vue-next';
import DashboardLayout from '@/Layouts/DashboardLayout.vue';

const props = defineProps({ payouts: { type: Array, default: () => [] } });

const statusFilter = ref('');

const filteredPayouts = computed(() => {
  if (!statusFilter.value) return props.payouts;
  return props.payouts.filter(p => p.status === statusFilter.value);
});

const payoutStats = computed(() => [
  { label: 'Total Requests', value: props.payouts.length, color: 'text-text-primary' },
  { label: 'Pending',  value: props.payouts.filter(p => p.status === 'pending').length,  color: 'text-status-warning' },
  { label: 'Paid',     value: props.payouts.filter(p => p.status === 'paid').length,     color: 'text-status-success' },
  { label: 'Rejected', value: props.payouts.filter(p => p.status === 'rejected').length, color: 'text-status-error' },
]);

function formatPrice(p) {
  return new Intl.NumberFormat('en-KE', { style: 'currency', currency: 'KES' }).format(p);
}

function statusClass(s) {
  return { pending: 'badge badge-warning', approved: 'badge badge-info', paid: 'badge badge-success', rejected: 'badge badge-error' }[s] ?? 'badge badge-neutral';
}

function process(payout, status) {
  router.patch(route('admin.payouts.update', payout.id), { status }, { preserveScroll: true });
}

const adminNav = [
  { label: 'Dashboard',   href: route('admin.dashboard'),        icon: 'LayoutDashboardIcon' },
  { section: 'Marketplace' },
  { label: 'Vendors',     href: route('admin.vendors.index'),    icon: 'StoreIcon' },
  { label: 'Products',    href: route('admin.products.index'),   icon: 'PackageIcon' },
  { label: 'Orders',      href: route('admin.orders.index'),     icon: 'ShoppingBagIcon' },
  { label: 'Categories',  href: route('admin.categories.index'), icon: 'TagIcon' },
  { label: 'Reviews',     href: route('admin.reviews.index'),    icon: 'StarIcon' },
  { section: 'Users' },
  { label: 'Buyers',      href: route('admin.buyers.index'),     icon: 'UsersIcon' },
  { section: 'Finance' },
  { label: 'Payouts',     href: route('admin.payouts.index'),    icon: 'BanknoteIcon' },
  { label: 'Promo Codes', href: route('admin.promos.index'),     icon: 'TicketIcon' },
  { section: 'Settings' },
  { label: 'Settings',    href: route('admin.settings.index'),   icon: 'SettingsIcon' },
];
</script>

KODA_FILE_6AEB3CCA

# --- resources/js/Pages/Admin/Products/Index.vue ---
mkdir -p "resources/js/Pages/Admin/Products"
cat > "resources/js/Pages/Admin/Products/Index.vue" << 'KODA_FILE_59C0C317'
<template>
  <DashboardLayout :nav-items="adminNav" page-title="Products" :breadcrumbs="[{ label: 'Admin' }, { label: 'Products' }]">
    <!-- Toolbar -->
    <div class="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 mb-6">
      <div class="flex items-center gap-3 flex-wrap">
        <div class="relative">
          <SearchIcon class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-text-muted pointer-events-none" />
          <input v-model="search" type="text" placeholder="Search products..." class="koda-input pl-9 text-sm w-60" />
        </div>
        <select v-model="statusFilter" class="koda-select text-sm w-36">
          <option value="">All statuses</option>
          <option value="active">Active</option>
          <option value="draft">Draft</option>
          <option value="inactive">Inactive</option>
        </select>
        <select v-model="categoryFilter" class="koda-select text-sm w-44">
          <option value="">All categories</option>
          <option v-for="cat in categories" :key="cat.id" :value="cat.id">{{ cat.name }}</option>
        </select>
      </div>
      <p class="text-text-muted text-sm shrink-0">{{ filteredProducts.length }} product(s)</p>
    </div>

    <div class="koda-card overflow-hidden p-0">
      <div class="overflow-x-auto">
        <table class="koda-table">
          <thead>
            <tr>
              <th>Product</th>
              <th>Vendor</th>
              <th>Category</th>
              <th>Price</th>
              <th>Stock</th>
              <th>Status</th>
              <th>Featured</th>
              <th class="w-24">Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="product in filteredProducts" :key="product.id">
              <td>
                <div class="flex items-center gap-3">
                  <div class="w-9 h-9 rounded-lg overflow-hidden bg-bg-tertiary border border-border shrink-0">
                    <img v-if="product.thumbnail" :src="product.thumbnail" class="w-full h-full object-cover" />
                    <PackageIcon v-else class="w-4 h-4 text-border m-auto mt-2.5" />
                  </div>
                  <div class="min-w-0">
                    <p class="text-sm font-medium text-text-primary truncate max-w-48">{{ product.name }}</p>
                    <p class="text-xs text-text-muted font-mono">{{ product.sku }}</p>
                  </div>
                </div>
              </td>
              <td class="text-xs text-text-secondary">{{ product.vendor?.store_name }}</td>
              <td class="text-xs text-text-muted">{{ product.category?.name }}</td>
              <td class="text-sm font-semibold text-accent">{{ formatPrice(product.price) }}</td>
              <td>
                <span :class="['text-xs font-medium', product.stock === 0 ? 'text-status-error' : product.stock <= 5 ? 'text-status-warning' : 'text-text-secondary']">
                  {{ product.stock }}
                </span>
              </td>
              <td><span :class="statusBadge(product.status)">{{ product.status }}</span></td>
              <td>
                <button @click="toggleFeatured(product)" :class="['w-5 h-5 rounded transition-colors', product.is_featured ? 'text-accent' : 'text-border hover:text-text-muted']">
                  <StarIcon :class="['w-4 h-4', product.is_featured ? 'fill-current' : '']" />
                </button>
              </td>
              <td>
                <div class="flex items-center gap-1">
                  <Link :href="route('products.show', product.slug)" target="_blank" class="btn-ghost p-1.5 text-text-muted hover:text-accent">
                    <EyeIcon class="w-3.5 h-3.5" />
                  </Link>
                  <button @click="deleteProduct(product)" class="btn-ghost p-1.5 text-text-muted hover:text-status-error">
                    <Trash2Icon class="w-3.5 h-3.5" />
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <div v-if="!filteredProducts.length" class="text-center py-16 text-text-muted">
        <PackageIcon class="w-12 h-12 mx-auto mb-3 text-border" />
        <p>No products found</p>
      </div>
    </div>

    <Pagination :links="products.links" />
  </DashboardLayout>
</template>

<script setup>
import { ref, computed } from 'vue';
import { Link, router } from '@inertiajs/vue3';
import { SearchIcon, EyeIcon, Trash2Icon, PackageIcon, StarIcon } from 'lucide-vue-next';
import DashboardLayout from '@/Layouts/DashboardLayout.vue';
import Pagination from '@/Components/UI/Pagination.vue';

const props = defineProps({
  products:   { type: Object, required: true },
  categories: { type: Array,  default: () => [] },
});

const search         = ref('');
const statusFilter   = ref('');
const categoryFilter = ref('');

const filteredProducts = computed(() => {
  let list = props.products.data ?? [];
  if (search.value)         list = list.filter(p => p.name.toLowerCase().includes(search.value.toLowerCase()) || p.sku?.includes(search.value));
  if (statusFilter.value)   list = list.filter(p => p.status === statusFilter.value);
  if (categoryFilter.value) list = list.filter(p => p.category_id == categoryFilter.value);
  return list;
});

function formatPrice(p) { return new Intl.NumberFormat('en-KE', { style: 'currency', currency: 'KES' }).format(p); }
function statusBadge(s) { return { active: 'badge badge-success', draft: 'badge badge-warning', inactive: 'badge badge-neutral' }[s] ?? 'badge badge-neutral'; }

function toggleFeatured(product) {
  router.patch(route('admin.products.feature', product.id), { is_featured: !product.is_featured }, { preserveScroll: true });
}

function deleteProduct(product) {
  if (confirm(`Delete "${product.name}"? This cannot be undone.`)) {
    router.delete(route('admin.products.destroy', product.id), { preserveScroll: true });
  }
}

const adminNav = [
  { label: 'Dashboard',   href: route('admin.dashboard'),        icon: 'LayoutDashboardIcon' },
  { section: 'Marketplace' },
  { label: 'Vendors',     href: route('admin.vendors.index'),    icon: 'StoreIcon' },
  { label: 'Products',    href: route('admin.products.index'),   icon: 'PackageIcon' },
  { label: 'Orders',      href: route('admin.orders.index'),     icon: 'ShoppingBagIcon' },
  { label: 'Categories',  href: route('admin.categories.index'), icon: 'TagIcon' },
  { label: 'Reviews',     href: route('admin.reviews.index'),    icon: 'StarIcon' },
  { section: 'Users' },
  { label: 'Buyers',      href: route('admin.buyers.index'),     icon: 'UsersIcon' },
  { section: 'Finance' },
  { label: 'Payouts',     href: route('admin.payouts.index'),    icon: 'BanknoteIcon' },
  { label: 'Promo Codes', href: route('admin.promos.index'),     icon: 'TicketIcon' },
  { section: 'Settings' },
  { label: 'Settings',    href: route('admin.settings.index'),   icon: 'SettingsIcon' },
];
</script>

KODA_FILE_59C0C317

# --- resources/js/Pages/Admin/Promos/Index.vue ---
mkdir -p "resources/js/Pages/Admin/Promos"
cat > "resources/js/Pages/Admin/Promos/Index.vue" << 'KODA_FILE_CE03C5DA'
<template>
  <DashboardLayout :nav-items="adminNav" page-title="Promo Codes" :breadcrumbs="[{ label: 'Admin' }, { label: 'Promo Codes' }]">
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
      <!-- List -->
      <div class="lg:col-span-2">
        <div class="koda-card overflow-hidden p-0">
          <div class="px-5 py-4 border-b border-border flex items-center justify-between">
            <h3 class="font-heading text-sm font-bold">Active Codes</h3>
            <span class="text-xs text-text-muted">{{ promoCodes.length }} total</span>
          </div>
          <table class="koda-table">
            <thead>
              <tr>
                <th>Code</th>
                <th>Type</th>
                <th>Value</th>
                <th>Uses</th>
                <th>Expires</th>
                <th>Status</th>
                <th class="w-16">Del</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="promo in promoCodes" :key="promo.id">
                <td class="font-mono text-sm font-bold text-accent">{{ promo.code }}</td>
                <td class="text-xs text-text-muted capitalize">{{ promo.type }}</td>
                <td class="text-sm font-semibold text-text-primary">
                  {{ promo.type === 'percent' ? promo.value + '%' : formatPrice(promo.value) }}
                </td>
                <td class="text-xs text-text-secondary">
                  {{ promo.uses }}<span v-if="promo.max_uses"> / {{ promo.max_uses }}</span>
                </td>
                <td class="text-xs text-text-muted">{{ promo.expires_at ? new Date(promo.expires_at).toLocaleDateString() : '—' }}</td>
                <td>
                  <span :class="promo.is_active ? 'badge badge-success' : 'badge badge-neutral'">
                    {{ promo.is_active ? 'Active' : 'Inactive' }}
                  </span>
                </td>
                <td>
                  <button @click="deletePromo(promo)" class="btn-ghost p-1.5 text-text-muted hover:text-status-error">
                    <Trash2Icon class="w-3.5 h-3.5" />
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
          <div v-if="!promoCodes.length" class="text-center py-12 text-text-muted">
            <TicketIcon class="w-10 h-10 mx-auto mb-2 text-border" />
            <p class="text-sm">No promo codes yet</p>
          </div>
        </div>
      </div>

      <!-- Create form -->
      <div>
        <div class="koda-card space-y-4 sticky top-24">
          <h3 class="font-heading text-sm font-bold">New Promo Code</h3>
          <form @submit.prevent="submit" class="space-y-4">
            <div>
              <label class="koda-label">Code <span class="text-status-error">*</span></label>
              <input v-model="form.code" type="text" class="koda-input font-mono uppercase" :class="{ error: errors.code }" placeholder="SAVE20" />
              <p v-if="errors.code" class="koda-error">{{ errors.code }}</p>
            </div>
            <div>
              <label class="koda-label">Discount Type</label>
              <div class="flex gap-2">
                <label v-for="t in ['percent','fixed']" :key="t"
                  :class="['flex-1 text-center py-2 rounded-btn border-2 cursor-pointer text-sm font-medium transition-all capitalize', form.type === t ? 'border-accent bg-accent-subtle text-accent' : 'border-border text-text-muted hover:border-border-light']"
                >
                  <input type="radio" :value="t" v-model="form.type" class="sr-only" />
                  {{ t === 'percent' ? '% Percent' : 'KES Fixed' }}
                </label>
              </div>
            </div>
            <div>
              <label class="koda-label">Value <span class="text-status-error">*</span></label>
              <div class="relative">
                <span class="absolute left-3 top-1/2 -translate-y-1/2 text-text-muted text-sm">{{ form.type === 'percent' ? '%' : 'KES' }}</span>
                <input v-model="form.value" type="number" min="0" step="0.01" class="koda-input pl-10" placeholder="0" />
              </div>
            </div>
            <div>
              <label class="koda-label">Max Uses <span class="text-text-muted text-xs">(leave blank = unlimited)</span></label>
              <input v-model="form.max_uses" type="number" min="1" class="koda-input" placeholder="Unlimited" />
            </div>
            <div>
              <label class="koda-label">Expiry Date</label>
              <input v-model="form.expires_at" type="date" class="koda-input" />
            </div>
            <button type="submit" :disabled="submitting" class="btn-primary w-full">
              <LoaderIcon v-if="submitting" class="w-4 h-4 animate-spin" />
              <TicketIcon v-else class="w-4 h-4" />
              Create Code
            </button>
          </form>
        </div>
      </div>
    </div>
  </DashboardLayout>
</template>

<script setup>
import { ref } from 'vue';
import { router } from '@inertiajs/vue3';
import { Trash2Icon, TicketIcon, LoaderIcon } from 'lucide-vue-next';
import DashboardLayout from '@/Layouts/DashboardLayout.vue';

const props = defineProps({
  promoCodes: { type: Array, default: () => [] },
  errors:     { type: Object, default: () => ({}) },
});

const submitting = ref(false);
const form = ref({ code: '', type: 'percent', value: '', max_uses: '', expires_at: '' });

function formatPrice(p) {
  return new Intl.NumberFormat('en-KE', { style: 'currency', currency: 'KES' }).format(p);
}

function submit() {
  submitting.value = true;
  router.post(route('admin.promos.store'), form.value, {
    preserveScroll: true,
    onSuccess: () => { form.value = { code: '', type: 'percent', value: '', max_uses: '', expires_at: '' }; },
    onFinish:  () => { submitting.value = false; },
  });
}

function deletePromo(promo) {
  if (confirm(`Delete code "${promo.code}"?`)) {
    router.delete(route('admin.promos.destroy', promo.id), { preserveScroll: true });
  }
}

const adminNav = [
  { label: 'Dashboard',   href: route('admin.dashboard'),        icon: 'LayoutDashboardIcon' },
  { section: 'Marketplace' },
  { label: 'Vendors',     href: route('admin.vendors.index'),    icon: 'StoreIcon' },
  { label: 'Products',    href: route('admin.products.index'),   icon: 'PackageIcon' },
  { label: 'Orders',      href: route('admin.orders.index'),     icon: 'ShoppingBagIcon' },
  { label: 'Categories',  href: route('admin.categories.index'), icon: 'TagIcon' },
  { label: 'Reviews',     href: route('admin.reviews.index'),    icon: 'StarIcon' },
  { section: 'Users' },
  { label: 'Buyers',      href: route('admin.buyers.index'),     icon: 'UsersIcon' },
  { section: 'Finance' },
  { label: 'Payouts',     href: route('admin.payouts.index'),    icon: 'BanknoteIcon' },
  { label: 'Promo Codes', href: route('admin.promos.index'),     icon: 'TicketIcon' },
  { section: 'Settings' },
  { label: 'Settings',    href: route('admin.settings.index'),   icon: 'SettingsIcon' },
];
</script>

KODA_FILE_CE03C5DA

# --- resources/js/Pages/Admin/Reviews/Index.vue ---
mkdir -p "resources/js/Pages/Admin/Reviews"
cat > "resources/js/Pages/Admin/Reviews/Index.vue" << 'KODA_FILE_B9C769BD'
<template>
  <DashboardLayout :nav-items="adminNav" page-title="Reviews" :breadcrumbs="[{ label: 'Admin' }, { label: 'Reviews' }]">
    <!-- Filter tabs -->
    <div class="flex gap-1 mb-6 border-b border-border">
      <button v-for="tab in ['pending','approved','all']" :key="tab"
        @click="activeTab = tab"
        :class="['px-4 py-3 text-sm font-medium capitalize transition-colors border-b-2 -mb-px', activeTab === tab ? 'border-accent text-accent' : 'border-transparent text-text-muted hover:text-text-secondary']"
      >{{ tab }}</button>
    </div>

    <div class="space-y-3">
      <div v-for="review in filteredReviews" :key="review.id" class="koda-card">
        <div class="flex items-start justify-between gap-4">
          <div class="flex-1 min-w-0">
            <div class="flex items-center gap-3 mb-2 flex-wrap">
              <StarRating :model-value="review.rating" />
              <span class="text-xs text-text-muted">by {{ review.user?.name }}</span>
              <span class="text-xs text-text-muted">on</span>
              <Link :href="route('products.show', review.product?.slug)" class="text-xs text-accent hover:text-accent-light transition-colors truncate">
                {{ review.product?.name }}
              </Link>
              <span class="text-xs text-text-muted ml-auto">{{ review.created_at_human }}</span>
            </div>
            <p class="text-sm text-text-secondary leading-relaxed">{{ review.comment }}</p>
          </div>
          <div class="flex items-center gap-2 shrink-0">
            <span :class="review.approved ? 'badge badge-success' : 'badge badge-warning'">
              {{ review.approved ? 'Approved' : 'Pending' }}
            </span>
            <button v-if="!review.approved" @click="approve(review)" class="btn-ghost p-1.5 text-status-success hover:bg-green-950/30" title="Approve">
              <CheckIcon class="w-4 h-4" />
            </button>
            <button @click="reject(review)" class="btn-ghost p-1.5 text-status-error hover:bg-red-950/30" title="Delete">
              <Trash2Icon class="w-4 h-4" />
            </button>
          </div>
        </div>
      </div>

      <div v-if="!filteredReviews.length" class="text-center py-16 text-text-muted">
        <StarIcon class="w-12 h-12 mx-auto mb-3 text-border" />
        <p>No reviews in this category</p>
      </div>
    </div>
  </DashboardLayout>
</template>

<script setup>
import { ref, computed } from 'vue';
import { Link, router } from '@inertiajs/vue3';
import { CheckIcon, Trash2Icon, StarIcon } from 'lucide-vue-next';
import DashboardLayout from '@/Layouts/DashboardLayout.vue';
import StarRating from '@/Components/UI/StarRating.vue';

const props = defineProps({ reviews: { type: Array, default: () => [] } });
const activeTab = ref('pending');

const filteredReviews = computed(() => {
  if (activeTab.value === 'all')      return props.reviews;
  if (activeTab.value === 'pending')  return props.reviews.filter(r => !r.approved);
  if (activeTab.value === 'approved') return props.reviews.filter(r => r.approved);
  return props.reviews;
});

function approve(review) { router.patch(route('admin.reviews.approve', review.id), {}, { preserveScroll: true }); }
function reject(review)  { router.delete(route('admin.reviews.destroy', review.id), { preserveScroll: true }); }

const adminNav = [
  { label: 'Dashboard',   href: route('admin.dashboard'),        icon: 'LayoutDashboardIcon' },
  { section: 'Marketplace' },
  { label: 'Vendors',     href: route('admin.vendors.index'),    icon: 'StoreIcon' },
  { label: 'Products',    href: route('admin.products.index'),   icon: 'PackageIcon' },
  { label: 'Orders',      href: route('admin.orders.index'),     icon: 'ShoppingBagIcon' },
  { label: 'Categories',  href: route('admin.categories.index'), icon: 'TagIcon' },
  { label: 'Reviews',     href: route('admin.reviews.index'),    icon: 'StarIcon' },
  { section: 'Users' },
  { label: 'Buyers',      href: route('admin.buyers.index'),     icon: 'UsersIcon' },
  { section: 'Finance' },
  { label: 'Payouts',     href: route('admin.payouts.index'),    icon: 'BanknoteIcon' },
  { label: 'Promo Codes', href: route('admin.promos.index'),     icon: 'TicketIcon' },
  { section: 'Settings' },
  { label: 'Settings',    href: route('admin.settings.index'),   icon: 'SettingsIcon' },
];
</script>

KODA_FILE_B9C769BD

# --- resources/js/Pages/Admin/Settings/Index.vue ---
mkdir -p "resources/js/Pages/Admin/Settings"
cat > "resources/js/Pages/Admin/Settings/Index.vue" << 'KODA_FILE_3D08691B'
<template>
  <DashboardLayout :nav-items="adminNav" page-title="Platform Settings" :breadcrumbs="[{ label: 'Admin' }, { label: 'Settings' }]">
    <div class="max-w-2xl space-y-6">
      <!-- General -->
      <div class="koda-card space-y-5">
        <h3 class="font-heading text-base font-bold">General</h3>
        <div>
          <label class="koda-label">Platform Name</label>
          <input v-model="form.app_name" type="text" class="koda-input" />
        </div>
        <div>
          <label class="koda-label">Support Email</label>
          <input v-model="form.support_email" type="email" class="koda-input" />
        </div>
        <div>
          <label class="koda-label">Default Currency</label>
          <select v-model="form.currency" class="koda-select">
            <option value="KES">KES — Kenyan Shilling</option>
            <option value="USD">USD — US Dollar</option>
            <option value="UGX">UGX — Ugandan Shilling</option>
            <option value="TZS">TZS — Tanzanian Shilling</option>
          </select>
        </div>
      </div>

      <!-- Commission -->
      <div class="koda-card space-y-5">
        <h3 class="font-heading text-base font-bold">Commission & Fees</h3>
        <div>
          <label class="koda-label">Default Commission Rate (%)</label>
          <input v-model="form.commission_rate" type="number" min="0" max="50" step="0.5" class="koda-input w-40" />
          <p class="text-xs text-text-muted mt-1">Applied to all vendors unless overridden per vendor.</p>
        </div>
        <div>
          <label class="koda-label">Minimum Payout Amount (KES)</label>
          <input v-model="form.min_payout" type="number" min="0" class="koda-input w-40" />
        </div>
      </div>

      <!-- Vendor -->
      <div class="koda-card space-y-5">
        <h3 class="font-heading text-base font-bold">Vendor Settings</h3>
        <label class="flex items-center gap-3 cursor-pointer">
          <div class="relative">
            <input type="checkbox" v-model="form.auto_approve_vendors" class="sr-only peer" />
            <div class="w-10 h-5 bg-border rounded-full peer peer-checked:bg-accent transition-colors" />
            <div class="absolute top-0.5 left-0.5 w-4 h-4 bg-white rounded-full transition-transform peer-checked:translate-x-5" />
          </div>
          <div>
            <p class="text-sm font-medium text-text-primary">Auto-approve vendor applications</p>
            <p class="text-xs text-text-muted">Skip manual review (not recommended)</p>
          </div>
        </label>
        <label class="flex items-center gap-3 cursor-pointer">
          <div class="relative">
            <input type="checkbox" v-model="form.require_product_approval" class="sr-only peer" />
            <div class="w-10 h-5 bg-border rounded-full peer peer-checked:bg-accent transition-colors" />
            <div class="absolute top-0.5 left-0.5 w-4 h-4 bg-white rounded-full transition-transform peer-checked:translate-x-5" />
          </div>
          <div>
            <p class="text-sm font-medium text-text-primary">Require product approval</p>
            <p class="text-xs text-text-muted">Admin must approve products before they go live</p>
          </div>
        </label>
      </div>

      <!-- Maintenance -->
      <div class="koda-card space-y-5">
        <h3 class="font-heading text-base font-bold">Maintenance</h3>
        <label class="flex items-center gap-3 cursor-pointer">
          <div class="relative">
            <input type="checkbox" v-model="form.maintenance_mode" class="sr-only peer" />
            <div class="w-10 h-5 bg-border rounded-full peer peer-checked:bg-status-error transition-colors" />
            <div class="absolute top-0.5 left-0.5 w-4 h-4 bg-white rounded-full transition-transform peer-checked:translate-x-5" />
          </div>
          <div>
            <p class="text-sm font-medium text-text-primary">Maintenance Mode</p>
            <p class="text-xs text-text-muted">Show maintenance page to all non-admin visitors</p>
          </div>
        </label>
      </div>

      <div class="flex items-center gap-3">
        <button @click="save" :disabled="saving" class="btn-primary px-8">
          <LoaderIcon v-if="saving" class="w-4 h-4 animate-spin" />
          Save Settings
        </button>
        <p v-if="saved" class="text-sm text-status-success flex items-center gap-1.5">
          <CheckCircleIcon class="w-4 h-4" /> Settings saved
        </p>
      </div>
    </div>
  </DashboardLayout>
</template>

<script setup>
import { ref } from 'vue';
import { router } from '@inertiajs/vue3';
import { LoaderIcon, CheckCircleIcon } from 'lucide-vue-next';
import DashboardLayout from '@/Layouts/DashboardLayout.vue';

const props = defineProps({ settings: { type: Object, default: () => ({}) } });

const saving = ref(false);
const saved  = ref(false);

const form = ref({
  app_name:               props.settings.app_name              ?? 'Koda',
  support_email:          props.settings.support_email         ?? 'support@koda.com',
  currency:               props.settings.currency              ?? 'KES',
  commission_rate:        props.settings.commission_rate       ?? 10,
  min_payout:             props.settings.min_payout            ?? 500,
  auto_approve_vendors:   props.settings.auto_approve_vendors  ?? false,
  require_product_approval: props.settings.require_product_approval ?? false,
  maintenance_mode:       props.settings.maintenance_mode      ?? false,
});

function save() {
  saving.value = true;
  router.post(route('admin.settings.store'), form.value, {
    preserveScroll: true,
    onFinish: () => { saving.value = false; saved.value = true; setTimeout(() => { saved.value = false; }, 3000); },
  });
}

const adminNav = [
  { label: 'Dashboard',   href: route('admin.dashboard'),        icon: 'LayoutDashboardIcon' },
  { section: 'Marketplace' },
  { label: 'Vendors',     href: route('admin.vendors.index'),    icon: 'StoreIcon' },
  { label: 'Products',    href: route('admin.products.index'),   icon: 'PackageIcon' },
  { label: 'Orders',      href: route('admin.orders.index'),     icon: 'ShoppingBagIcon' },
  { label: 'Categories',  href: route('admin.categories.index'), icon: 'TagIcon' },
  { label: 'Reviews',     href: route('admin.reviews.index'),    icon: 'StarIcon' },
  { section: 'Users' },
  { label: 'Buyers',      href: route('admin.buyers.index'),     icon: 'UsersIcon' },
  { section: 'Finance' },
  { label: 'Payouts',     href: route('admin.payouts.index'),    icon: 'BanknoteIcon' },
  { label: 'Promo Codes', href: route('admin.promos.index'),     icon: 'TicketIcon' },
  { section: 'Settings' },
  { label: 'Settings',    href: route('admin.settings.index'),   icon: 'SettingsIcon' },
];
</script>

KODA_FILE_3D08691B

# --- resources/js/Pages/Admin/Vendors/Index.vue ---
mkdir -p "resources/js/Pages/Admin/Vendors"
cat > "resources/js/Pages/Admin/Vendors/Index.vue" << 'KODA_FILE_D1F78F7A'
<template>
  <DashboardLayout :nav-items="adminNav" page-title="Vendors" :breadcrumbs="[{ label: 'Admin' }, { label: 'Vendors' }]">
    <!-- Toolbar -->
    <div class="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 mb-6">
      <div class="flex items-center gap-3 flex-wrap">
        <div class="relative">
          <SearchIcon class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-text-muted pointer-events-none" />
          <input v-model="search" type="text" placeholder="Search vendors..." class="koda-input pl-9 text-sm w-56" />
        </div>
        <select v-model="statusFilter" class="koda-select text-sm w-36">
          <option value="">All statuses</option>
          <option value="pending">Pending</option>
          <option value="active">Active</option>
          <option value="rejected">Rejected</option>
          <option value="suspended">Suspended</option>
        </select>
      </div>
      <div class="flex items-center gap-2 text-sm text-text-muted">
        <span class="badge badge-warning">{{ pendingCount }} pending</span>
      </div>
    </div>

    <!-- Stats row -->
    <div class="grid grid-cols-2 sm:grid-cols-4 gap-3 mb-6">
      <div v-for="stat in vendorStats" :key="stat.label" class="koda-card py-3">
        <p class="text-xs text-text-muted">{{ stat.label }}</p>
        <p class="font-heading text-xl font-bold mt-0.5" :class="stat.color">{{ stat.value }}</p>
      </div>
    </div>

    <!-- Vendors table -->
    <div class="koda-card overflow-hidden p-0">
      <div class="overflow-x-auto">
        <table class="koda-table">
          <thead>
            <tr>
              <th>Vendor</th>
              <th>Owner</th>
              <th>Products</th>
              <th>Status</th>
              <th>Applied</th>
              <th class="w-40">Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="vendor in filteredVendors" :key="vendor.id">
              <td>
                <div class="flex items-center gap-3">
                  <div class="w-9 h-9 rounded-lg overflow-hidden bg-bg-tertiary border border-border shrink-0">
                    <img v-if="vendor.logo" :src="vendor.logo" class="w-full h-full object-cover" />
                    <div v-else class="w-full h-full bg-accent-subtle flex items-center justify-center">
                      <span class="text-accent text-xs font-bold">{{ vendor.store_name?.[0] }}</span>
                    </div>
                  </div>
                  <div>
                    <div class="flex items-center gap-1.5">
                      <p class="text-sm font-semibold text-text-primary">{{ vendor.store_name }}</p>
                      <CheckCircleIcon v-if="vendor.is_verified" class="w-3.5 h-3.5 text-accent" />
                    </div>
                    <p class="text-xs text-text-muted">{{ vendor.city }}</p>
                  </div>
                </div>
              </td>
              <td class="text-xs text-text-secondary">{{ vendor.user?.name }}</td>
              <td class="text-xs text-text-muted">{{ vendor.products_count }}</td>
              <td>
                <span :class="statusBadgeClass(vendor.status)">{{ vendor.status }}</span>
              </td>
              <td class="text-xs text-text-muted">{{ vendor.created_at_human }}</td>
              <td>
                <div class="flex items-center gap-1">
                  <Link :href="route('admin.vendors.show', vendor.id)" class="btn-ghost p-1.5 text-text-muted hover:text-text-primary" title="View">
                    <EyeIcon class="w-3.5 h-3.5" />
                  </Link>
                  <button
                    v-if="vendor.status === 'pending' || vendor.status === 'rejected'"
                    @click="approveVendor(vendor)"
                    class="btn-ghost p-1.5 text-text-muted hover:text-status-success"
                    title="Approve"
                  >
                    <CheckIcon class="w-3.5 h-3.5" />
                  </button>
                  <button
                    v-if="vendor.status === 'pending'"
                    @click="openRejectModal(vendor)"
                    class="btn-ghost p-1.5 text-text-muted hover:text-status-error"
                    title="Reject"
                  >
                    <XIcon class="w-3.5 h-3.5" />
                  </button>
                  <button
                    v-if="vendor.status === 'active'"
                    @click="suspendVendor(vendor)"
                    class="btn-ghost p-1.5 text-text-muted hover:text-status-warning"
                    title="Suspend"
                  >
                    <BanIcon class="w-3.5 h-3.5" />
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <div v-if="!filteredVendors.length" class="text-center py-16 text-text-muted">
        <StoreIcon class="w-12 h-12 mx-auto mb-3 text-border" />
        <p>No vendors found</p>
      </div>
    </div>

    <Pagination :links="vendors.links" />

    <!-- Reject modal -->
    <Modal v-model="rejectModalOpen" title="Reject Vendor Application">
      <div class="space-y-4">
        <p class="text-sm text-text-secondary">
          Rejecting <strong class="text-text-primary">{{ selectedVendor?.store_name }}</strong>.
          Please provide a reason so the applicant can reapply.
        </p>
        <div>
          <label class="koda-label">Rejection Reason <span class="text-status-error">*</span></label>
          <textarea v-model="rejectReason" rows="3" class="koda-textarea" placeholder="e.g. Incomplete business information, product category not supported..." />
        </div>
      </div>
      <template #footer>
        <button @click="rejectModalOpen = false" class="btn-ghost">Cancel</button>
        <button @click="confirmReject" :disabled="!rejectReason.trim()" class="btn-danger">
          Reject Application
        </button>
      </template>
    </Modal>
  </DashboardLayout>
</template>

<script setup>
import { ref, computed } from 'vue';
import { Link, router } from '@inertiajs/vue3';
import { SearchIcon, EyeIcon, CheckIcon, XIcon, BanIcon, StoreIcon, CheckCircleIcon } from 'lucide-vue-next';
import DashboardLayout from '@/Layouts/DashboardLayout.vue';
import Pagination from '@/Components/UI/Pagination.vue';
import Modal from '@/Components/UI/Modal.vue';

const props = defineProps({
  vendors: { type: Object, required: true },
  filters: { type: Object, default: () => ({}) },
});

const search = ref(props.filters.q ?? '');
const statusFilter = ref(props.filters.status ?? '');
const rejectModalOpen = ref(false);
const selectedVendor = ref(null);
const rejectReason = ref('');

const pendingCount = computed(() => props.vendors.data.filter(v => v.status === 'pending').length);

const filteredVendors = computed(() => {
  let list = props.vendors.data;
  if (search.value) list = list.filter(v => v.store_name.toLowerCase().includes(search.value.toLowerCase()));
  if (statusFilter.value) list = list.filter(v => v.status === statusFilter.value);
  return list;
});

const vendorStats = computed(() => [
  { label: 'Total',     value: props.vendors.total ?? props.vendors.data.length, color: 'text-text-primary' },
  { label: 'Active',    value: props.vendors.data.filter(v => v.status === 'active').length,    color: 'text-status-success' },
  { label: 'Pending',   value: props.vendors.data.filter(v => v.status === 'pending').length,   color: 'text-status-warning' },
  { label: 'Suspended', value: props.vendors.data.filter(v => v.status === 'suspended').length, color: 'text-status-error' },
]);

function statusBadgeClass(s) {
  return { pending: 'badge badge-warning', active: 'badge badge-success', rejected: 'badge badge-error', suspended: 'badge badge-neutral' }[s] ?? 'badge badge-neutral';
}

function approveVendor(vendor) {
  router.post(route('admin.vendors.approve', vendor.id), {}, { preserveScroll: true });
}

function openRejectModal(vendor) {
  selectedVendor.value = vendor;
  rejectReason.value = '';
  rejectModalOpen.value = true;
}

function confirmReject() {
  router.post(route('admin.vendors.reject', selectedVendor.value.id), { reason: rejectReason.value }, {
    preserveScroll: true,
    onSuccess: () => { rejectModalOpen.value = false; },
  });
}

function suspendVendor(vendor) {
  if (confirm(`Suspend ${vendor.store_name}? They will not be able to sell.`)) {
    router.post(route('admin.vendors.suspend', vendor.id), {}, { preserveScroll: true });
  }
}

const adminNav = [
  { label: 'Dashboard',  href: route('admin.dashboard'),        icon: 'LayoutDashboardIcon' },
  { section: 'Marketplace' },
  { label: 'Vendors',    href: route('admin.vendors.index'),    icon: 'StoreIcon' },
  { label: 'Products',   href: route('admin.products.index'),   icon: 'PackageIcon' },
  { label: 'Orders',     href: route('admin.orders.index'),     icon: 'ShoppingBagIcon' },
  { label: 'Categories', href: route('admin.categories.index'), icon: 'TagIcon' },
  { label: 'Reviews',    href: route('admin.reviews.index'),    icon: 'StarIcon' },
  { section: 'Users' },
  { label: 'Buyers',     href: route('admin.buyers.index'),     icon: 'UsersIcon' },
  { section: 'Finance' },
  { label: 'Payouts',    href: route('admin.payouts.index'),    icon: 'BanknoteIcon' },
  { label: 'Promo Codes',href: route('admin.promos.index'),     icon: 'TicketIcon' },
  { section: 'Settings' },
  { label: 'Settings',   href: route('admin.settings.index'),   icon: 'SettingsIcon' },
];
</script>

KODA_FILE_D1F78F7A

# --- resources/js/Pages/Admin/Vendors/Show.vue ---
mkdir -p "resources/js/Pages/Admin/Vendors"
cat > "resources/js/Pages/Admin/Vendors/Show.vue" << 'KODA_FILE_41C5D1FA'
<template>
  <DashboardLayout
    :nav-items="adminNav"
    :page-title="vendor.store_name"
    :breadcrumbs="[{ label: 'Vendors', href: route('admin.vendors.index') }, { label: vendor.store_name }]"
  >
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
      <!-- Main info -->
      <div class="lg:col-span-2 space-y-6">
        <!-- Store card -->
        <div class="koda-card">
          <!-- Banner -->
          <div class="relative h-32 -mx-6 -mt-6 mb-6 rounded-t-card overflow-hidden bg-bg-tertiary">
            <img v-if="vendor.banner" :src="vendor.banner" class="w-full h-full object-cover" />
            <div v-else class="w-full h-full bg-gradient-to-br from-accent-subtle to-bg-tertiary" />
            <!-- Logo -->
            <div class="absolute bottom-0 left-5 translate-y-1/2">
              <div class="w-14 h-14 rounded-xl overflow-hidden bg-bg-secondary border-2 border-bg-secondary">
                <img v-if="vendor.logo" :src="vendor.logo" class="w-full h-full object-cover" />
                <div v-else class="w-full h-full bg-accent-subtle flex items-center justify-center">
                  <span class="text-accent text-lg font-bold">{{ vendor.store_name?.[0] }}</span>
                </div>
              </div>
            </div>
          </div>

          <div class="mt-8">
            <div class="flex items-center gap-2 mb-1">
              <h2 class="font-heading text-xl font-bold">{{ vendor.store_name }}</h2>
              <CheckCircleIcon v-if="vendor.is_verified" class="w-5 h-5 text-accent" />
              <span :class="statusBadge(vendor.status)" class="ml-2">{{ vendor.status }}</span>
            </div>
            <p class="text-text-secondary text-sm leading-relaxed">{{ vendor.description ?? 'No description provided.' }}</p>
          </div>

          <div class="grid grid-cols-2 sm:grid-cols-4 gap-4 mt-6 pt-6 border-t border-border">
            <div v-for="m in vendorMeta" :key="m.label">
              <p class="text-xs text-text-muted">{{ m.label }}</p>
              <p class="text-sm font-semibold text-text-primary mt-0.5">{{ m.value }}</p>
            </div>
          </div>
        </div>

        <!-- Recent products -->
        <div class="koda-card">
          <h3 class="font-heading text-sm font-bold mb-4">Recent Products ({{ vendor.products?.length ?? 0 }})</h3>
          <div v-if="vendor.products?.length" class="space-y-3">
            <div v-for="product in vendor.products.slice(0, 5)" :key="product.id" class="flex items-center gap-3">
              <div class="w-10 h-10 rounded-lg overflow-hidden bg-bg-tertiary border border-border shrink-0">
                <img v-if="product.thumbnail" :src="product.thumbnail" class="w-full h-full object-cover" />
              </div>
              <div class="flex-1 min-w-0">
                <p class="text-sm font-medium text-text-primary truncate">{{ product.name }}</p>
                <p class="text-xs text-text-muted">{{ product.status }} · Stock: {{ product.stock }}</p>
              </div>
              <span class="text-sm font-semibold text-accent shrink-0">{{ formatPrice(product.price) }}</span>
            </div>
          </div>
          <p v-else class="text-sm text-text-muted">No products listed yet.</p>
        </div>
      </div>

      <!-- Actions panel -->
      <div class="space-y-4">
        <!-- Owner info -->
        <div class="koda-card">
          <h3 class="font-heading text-sm font-bold mb-3">Account Owner</h3>
          <div class="flex items-center gap-3">
            <div class="w-8 h-8 rounded-full bg-accent-muted border border-accent/20 flex items-center justify-center">
              <span class="text-accent text-xs font-bold">{{ vendor.user?.name?.[0] }}</span>
            </div>
            <div>
              <p class="text-sm font-medium text-text-primary">{{ vendor.user?.name }}</p>
              <p class="text-xs text-text-muted">{{ vendor.user?.email }}</p>
            </div>
          </div>
          <div class="mt-3 space-y-1.5 text-xs text-text-muted border-t border-border pt-3">
            <p><span class="text-text-secondary">Phone:</span> {{ vendor.phone ?? '—' }}</p>
            <p><span class="text-text-secondary">Location:</span> {{ [vendor.city, vendor.country].filter(Boolean).join(', ') || '—' }}</p>
            <p><span class="text-text-secondary">Applied:</span> {{ vendor.created_at_human }}</p>
          </div>
        </div>

        <!-- Action buttons -->
        <div class="koda-card space-y-3">
          <h3 class="font-heading text-sm font-bold">Actions</h3>

          <button
            v-if="vendor.status === 'pending' || vendor.status === 'rejected'"
            @click="approve"
            class="btn-primary w-full"
          >
            <CheckCircleIcon class="w-4 h-4" />
            Approve Vendor
          </button>

          <div v-if="vendor.status === 'pending'">
            <label class="koda-label">Rejection Reason</label>
            <textarea v-model="rejectReason" rows="2" class="koda-textarea text-sm" placeholder="Reason for rejection..." />
            <button @click="reject" :disabled="!rejectReason.trim()" class="btn-danger w-full mt-2">
              <XIcon class="w-4 h-4" />
              Reject Application
            </button>
          </div>

          <button v-if="vendor.status === 'active'" @click="suspend" class="btn-secondary w-full border-status-warning/30 text-status-warning hover:bg-yellow-950/20">
            <BanIcon class="w-4 h-4" />
            Suspend Vendor
          </button>

          <button v-if="vendor.status === 'active' || vendor.status === 'suspended'" @click="toggleVerified" :class="['w-full', vendor.is_verified ? 'btn-secondary' : 'btn-outline']">
            <ShieldCheckIcon class="w-4 h-4" />
            {{ vendor.is_verified ? 'Remove Verified Badge' : 'Grant Verified Badge' }}
          </button>

          <div class="pt-2 border-t border-border">
            <button @click="deleteVendor" class="btn-ghost w-full text-status-error hover:bg-red-950/30 justify-center text-sm">
              <Trash2Icon class="w-4 h-4" />
              Delete Vendor
            </button>
          </div>
        </div>

        <!-- Rejection reason display -->
        <div v-if="vendor.rejection_reason" class="koda-card border-status-error/30 bg-red-950/10">
          <p class="text-xs text-status-error font-semibold mb-1">Rejection Reason</p>
          <p class="text-xs text-text-secondary">{{ vendor.rejection_reason }}</p>
        </div>
      </div>
    </div>
  </DashboardLayout>
</template>

<script setup>
import { ref, computed } from 'vue';
import { router } from '@inertiajs/vue3';
import { CheckCircleIcon, XIcon, BanIcon, ShieldCheckIcon, Trash2Icon } from 'lucide-vue-next';
import DashboardLayout from '@/Layouts/DashboardLayout.vue';

const props = defineProps({ vendor: { type: Object, required: true } });

const rejectReason = ref('');

const vendorMeta = computed(() => [
  { label: 'Products',   value: props.vendor.products?.length ?? 0 },
  { label: 'Commission', value: props.vendor.commission_rate + '%' },
  { label: 'Balance',    value: formatPrice(props.vendor.balance ?? 0) },
  { label: 'Member since', value: props.vendor.member_since ?? '—' },
]);

function formatPrice(p) {
  return new Intl.NumberFormat('en-KE', { style: 'currency', currency: 'KES', maximumFractionDigits: 0 }).format(p);
}

function statusBadge(s) {
  return { pending: 'badge badge-warning', active: 'badge badge-success', rejected: 'badge badge-error', suspended: 'badge badge-neutral' }[s] ?? 'badge badge-neutral';
}

function approve()  { router.post(route('admin.vendors.approve', props.vendor.id)); }
function suspend()  { if (confirm('Suspend this vendor?')) router.post(route('admin.vendors.suspend', props.vendor.id)); }
function reject()   { router.post(route('admin.vendors.reject', props.vendor.id), { reason: rejectReason.value }); }
function deleteVendor() {
  if (confirm(`Delete "${props.vendor.store_name}" and all their products? This cannot be undone.`)) {
    router.delete(route('admin.vendors.destroy', props.vendor.id));
  }
}
function toggleVerified() {
  router.patch(route('admin.vendors.verify', props.vendor.id), { is_verified: !props.vendor.is_verified }, { preserveScroll: true });
}

const adminNav = [
  { label: 'Dashboard',   href: route('admin.dashboard'),        icon: 'LayoutDashboardIcon' },
  { section: 'Marketplace' },
  { label: 'Vendors',     href: route('admin.vendors.index'),    icon: 'StoreIcon' },
  { label: 'Products',    href: route('admin.products.index'),   icon: 'PackageIcon' },
  { label: 'Orders',      href: route('admin.orders.index'),     icon: 'ShoppingBagIcon' },
  { label: 'Categories',  href: route('admin.categories.index'), icon: 'TagIcon' },
  { label: 'Reviews',     href: route('admin.reviews.index'),    icon: 'StarIcon' },
  { section: 'Users' },
  { label: 'Buyers',      href: route('admin.buyers.index'),     icon: 'UsersIcon' },
  { section: 'Finance' },
  { label: 'Payouts',     href: route('admin.payouts.index'),    icon: 'BanknoteIcon' },
  { label: 'Promo Codes', href: route('admin.promos.index'),     icon: 'TicketIcon' },
  { section: 'Settings' },
  { label: 'Settings',    href: route('admin.settings.index'),   icon: 'SettingsIcon' },
];
</script>

KODA_FILE_41C5D1FA

# --- resources/js/Pages/Auth/ForgotPassword.vue ---
mkdir -p "resources/js/Pages/Auth"
cat > "resources/js/Pages/Auth/ForgotPassword.vue" << 'KODA_FILE_0C029F5E'
<template>
  <div class="min-h-screen bg-bg-primary flex items-center justify-center p-4">
    <div class="absolute inset-0 bg-hero-gradient pointer-events-none" />
    <div class="relative w-full max-w-md">
      <div class="text-center mb-8">
        <Link :href="route('home')"><KodaLogo class="h-10 w-auto mx-auto mb-4" /></Link>
        <h1 class="font-heading text-2xl font-bold">Forgot your password?</h1>
        <p class="text-text-muted text-sm mt-1">No worries — we'll email you reset instructions.</p>
      </div>

      <div class="koda-card">
        <div v-if="form.recentlySuccessful || status" class="bg-green-950 border border-green-900 rounded-btn p-4 mb-5 flex items-center gap-3">
          <CheckCircleIcon class="w-4 h-4 text-status-success shrink-0" />
          <p class="text-sm text-status-success">{{ status ?? 'Reset link sent! Check your email.' }}</p>
        </div>

        <form @submit.prevent="submit" class="space-y-4">
          <div>
            <label class="koda-label">Email Address</label>
            <input v-model="form.email" type="email" class="koda-input" :class="{ error: form.errors.email }" placeholder="you@company.com" autofocus />
            <p v-if="form.errors.email" class="koda-error">{{ form.errors.email }}</p>
          </div>
          <button type="submit" :disabled="form.processing" class="btn-primary w-full py-3">
            <LoaderIcon v-if="form.processing" class="w-4 h-4 animate-spin" />
            <MailIcon v-else class="w-4 h-4" />
            Send Reset Link
          </button>
        </form>

        <p class="text-center text-sm text-text-muted mt-5">
          Remembered it?
          <Link :href="route('login')" class="text-accent hover:text-accent-light font-medium">Back to login</Link>
        </p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { Link, useForm } from '@inertiajs/vue3';
import { MailIcon, LoaderIcon, CheckCircleIcon } from 'lucide-vue-next';
import KodaLogo from '@/Components/UI/KodaLogo.vue';

defineProps({ status: String });

const form = useForm({ email: '' });
function submit() { form.post(route('password.email')); }
</script>

KODA_FILE_0C029F5E

# --- resources/js/Pages/Auth/Login.vue ---
mkdir -p "resources/js/Pages/Auth"
cat > "resources/js/Pages/Auth/Login.vue" << 'KODA_FILE_26B76068'
<template>
  <div class="min-h-screen bg-bg-primary flex items-center justify-center p-4">
    <div class="absolute inset-0 bg-hero-gradient pointer-events-none" />
    <div class="relative w-full max-w-md">
      <!-- Logo -->
      <div class="text-center mb-8">
        <Link :href="route('home')">
          <KodaLogo class="h-10 w-auto mx-auto mb-4" />
        </Link>
        <h1 class="font-heading text-2xl font-bold">Welcome back</h1>
        <p class="text-text-muted text-sm mt-1">Sign in to your account</p>
      </div>

      <div class="koda-card">
        <!-- Social login (future) -->
        <div class="space-y-3 mb-6">
          <button type="button" class="btn-secondary w-full gap-3">
            <svg class="w-4 h-4" viewBox="0 0 24 24"><path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/><path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/><path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/><path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/></svg>
            Continue with Google
          </button>
        </div>

        <div class="relative mb-6">
          <div class="absolute inset-0 flex items-center">
            <div class="w-full border-t border-border" />
          </div>
          <div class="relative flex justify-center text-xs">
            <span class="bg-bg-secondary px-3 text-text-muted">or sign in with email</span>
          </div>
        </div>

        <form @submit.prevent="submit" class="space-y-4">
          <div>
            <label class="koda-label">Email</label>
            <input v-model="form.email" type="email" class="koda-input" :class="{ error: form.errors.email }" placeholder="you@company.com" autocomplete="email" />
            <p v-if="form.errors.email" class="koda-error">{{ form.errors.email }}</p>
          </div>
          <div>
            <div class="flex items-center justify-between mb-1.5">
              <label class="koda-label mb-0">Password</label>
              <Link :href="route('password.request')" class="text-xs text-accent hover:text-accent-light transition-colors">Forgot password?</Link>
            </div>
            <div class="relative">
              <input
                v-model="form.password"
                :type="showPass ? 'text' : 'password'"
                class="koda-input pr-10"
                :class="{ error: form.errors.password }"
                placeholder="••••••••"
                autocomplete="current-password"
              />
              <button type="button" @click="showPass = !showPass" class="absolute right-3 top-1/2 -translate-y-1/2 text-text-muted hover:text-text-secondary transition-colors">
                <EyeIcon v-if="!showPass" class="w-4 h-4" />
                <EyeOffIcon v-else class="w-4 h-4" />
              </button>
            </div>
            <p v-if="form.errors.password" class="koda-error">{{ form.errors.password }}</p>
          </div>
          <div class="flex items-center gap-2">
            <input type="checkbox" id="remember" v-model="form.remember" class="accent-accent w-4 h-4 rounded" />
            <label for="remember" class="text-sm text-text-secondary cursor-pointer">Remember me</label>
          </div>
          <button type="submit" :disabled="form.processing" class="btn-primary w-full py-3 mt-2">
            <LoaderIcon v-if="form.processing" class="w-4 h-4 animate-spin" />
            Sign In
          </button>
        </form>

        <p class="text-center text-sm text-text-muted mt-6">
          Don't have an account?
          <Link :href="route('register')" class="text-accent hover:text-accent-light font-medium transition-colors">Sign up</Link>
        </p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { Link, useForm } from '@inertiajs/vue3';
import { EyeIcon, EyeOffIcon, LoaderIcon } from 'lucide-vue-next';
import KodaLogo from '@/Components/UI/KodaLogo.vue';

const showPass = ref(false);

const form = useForm({
  email:    '',
  password: '',
  remember: false,
});

function submit() {
  form.post(route('login'), {
    onFinish: () => form.reset('password'),
  });
}
</script>

KODA_FILE_26B76068

# --- resources/js/Pages/Auth/Register.vue ---
mkdir -p "resources/js/Pages/Auth"
cat > "resources/js/Pages/Auth/Register.vue" << 'KODA_FILE_DF306ED2'
<template>
  <div class="min-h-screen bg-bg-primary flex items-center justify-center p-4">
    <div class="absolute inset-0 bg-hero-gradient pointer-events-none" />
    <div class="relative w-full max-w-lg">
      <div class="text-center mb-8">
        <Link :href="route('home')"><KodaLogo class="h-10 w-auto mx-auto mb-4" /></Link>
        <h1 class="font-heading text-2xl font-bold">Create your account</h1>
        <p class="text-text-muted text-sm mt-1">Join thousands of professionals on Koda</p>
      </div>

      <div class="koda-card">
        <!-- Account type -->
        <div class="mb-6">
          <p class="koda-label mb-3">I want to</p>
          <div class="grid grid-cols-2 gap-3">
            <label
              :class="[
                'flex flex-col items-center gap-2 p-4 rounded-btn border-2 cursor-pointer transition-all',
                form.role === 'buyer' ? 'border-accent bg-accent-subtle' : 'border-border hover:border-border-light',
              ]"
            >
              <input type="radio" value="buyer" v-model="form.role" class="sr-only" />
              <ShoppingBagIcon :class="['w-6 h-6', form.role === 'buyer' ? 'text-accent' : 'text-text-muted']" />
              <div class="text-center">
                <p :class="['text-sm font-semibold', form.role === 'buyer' ? 'text-accent' : 'text-text-secondary']">Buy Products</p>
                <p class="text-xs text-text-muted">Browse & purchase</p>
              </div>
            </label>
            <label
              :class="[
                'flex flex-col items-center gap-2 p-4 rounded-btn border-2 cursor-pointer transition-all',
                form.role === 'vendor' ? 'border-accent bg-accent-subtle' : 'border-border hover:border-border-light',
              ]"
            >
              <input type="radio" value="vendor" v-model="form.role" class="sr-only" />
              <StoreIcon :class="['w-6 h-6', form.role === 'vendor' ? 'text-accent' : 'text-text-muted']" />
              <div class="text-center">
                <p :class="['text-sm font-semibold', form.role === 'vendor' ? 'text-accent' : 'text-text-secondary']">Sell Products</p>
                <p class="text-xs text-text-muted">Set up your store</p>
              </div>
            </label>
          </div>
        </div>

        <form @submit.prevent="submit" class="space-y-4">
          <div class="grid grid-cols-2 gap-4">
            <div>
              <label class="koda-label">First Name</label>
              <input v-model="form.first_name" type="text" class="koda-input" :class="{ error: form.errors.first_name }" placeholder="John" autocomplete="given-name" />
              <p v-if="form.errors.first_name" class="koda-error">{{ form.errors.first_name }}</p>
            </div>
            <div>
              <label class="koda-label">Last Name</label>
              <input v-model="form.last_name" type="text" class="koda-input" placeholder="Doe" autocomplete="family-name" />
            </div>
          </div>
          <div>
            <label class="koda-label">Email Address</label>
            <input v-model="form.email" type="email" class="koda-input" :class="{ error: form.errors.email }" placeholder="john@company.com" autocomplete="email" />
            <p v-if="form.errors.email" class="koda-error">{{ form.errors.email }}</p>
          </div>
          <div v-if="form.role === 'vendor'">
            <label class="koda-label">Business / Store Name</label>
            <input v-model="form.store_name" type="text" class="koda-input" :class="{ error: form.errors.store_name }" placeholder="Acme Supplies Ltd" />
            <p v-if="form.errors.store_name" class="koda-error">{{ form.errors.store_name }}</p>
          </div>
          <div>
            <label class="koda-label">Password</label>
            <div class="relative">
              <input v-model="form.password" :type="showPass ? 'text' : 'password'" class="koda-input pr-10" :class="{ error: form.errors.password }" placeholder="At least 8 characters" autocomplete="new-password" />
              <button type="button" @click="showPass = !showPass" class="absolute right-3 top-1/2 -translate-y-1/2 text-text-muted hover:text-text-secondary">
                <EyeIcon v-if="!showPass" class="w-4 h-4" />
                <EyeOffIcon v-else class="w-4 h-4" />
              </button>
            </div>
            <p v-if="form.errors.password" class="koda-error">{{ form.errors.password }}</p>
          </div>
          <div>
            <label class="koda-label">Confirm Password</label>
            <input v-model="form.password_confirmation" type="password" class="koda-input" placeholder="Repeat password" autocomplete="new-password" />
          </div>
          <div class="flex items-start gap-2 pt-1">
            <input type="checkbox" id="terms" v-model="form.terms" class="accent-accent w-4 h-4 mt-0.5 rounded" />
            <label for="terms" class="text-sm text-text-muted cursor-pointer">
              I agree to the
              <Link href="/terms" class="text-accent hover:text-accent-light">Terms of Service</Link>
              and
              <Link href="/privacy" class="text-accent hover:text-accent-light">Privacy Policy</Link>
            </label>
          </div>
          <p v-if="form.errors.terms" class="koda-error">{{ form.errors.terms }}</p>

          <button type="submit" :disabled="form.processing || !form.terms" class="btn-primary w-full py-3 mt-2">
            <LoaderIcon v-if="form.processing" class="w-4 h-4 animate-spin" />
            Create Account
          </button>
        </form>

        <p class="text-center text-sm text-text-muted mt-6">
          Already have an account?
          <Link :href="route('login')" class="text-accent hover:text-accent-light font-medium">Sign in</Link>
        </p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { Link, useForm } from '@inertiajs/vue3';
import { EyeIcon, EyeOffIcon, LoaderIcon, ShoppingBagIcon, StoreIcon } from 'lucide-vue-next';
import KodaLogo from '@/Components/UI/KodaLogo.vue';

const showPass = ref(false);

const form = useForm({
  first_name:            '',
  last_name:             '',
  email:                 '',
  store_name:            '',
  password:              '',
  password_confirmation: '',
  role:                  'buyer',
  terms:                 false,
});

function submit() {
  form.post(route('register'), {
    onFinish: () => form.reset('password', 'password_confirmation'),
  });
}
</script>

KODA_FILE_DF306ED2

# --- resources/js/Pages/Auth/ResetPassword.vue ---
mkdir -p "resources/js/Pages/Auth"
cat > "resources/js/Pages/Auth/ResetPassword.vue" << 'KODA_FILE_186D61B9'
<template>
  <div class="min-h-screen bg-bg-primary flex items-center justify-center p-4">
    <div class="absolute inset-0 bg-hero-gradient pointer-events-none" />
    <div class="relative w-full max-w-md">
      <div class="text-center mb-8">
        <Link :href="route('home')"><KodaLogo class="h-10 w-auto mx-auto mb-4" /></Link>
        <h1 class="font-heading text-2xl font-bold">Set new password</h1>
        <p class="text-text-muted text-sm mt-1">Choose a strong password for your account.</p>
      </div>
      <div class="koda-card">
        <form @submit.prevent="submit" class="space-y-4">
          <div>
            <label class="koda-label">Email</label>
            <input v-model="form.email" type="email" class="koda-input" :class="{ error: form.errors.email }" />
            <p v-if="form.errors.email" class="koda-error">{{ form.errors.email }}</p>
          </div>
          <div>
            <label class="koda-label">New Password</label>
            <div class="relative">
              <input v-model="form.password" :type="showPass ? 'text' : 'password'" class="koda-input pr-10" :class="{ error: form.errors.password }" placeholder="At least 8 characters" />
              <button type="button" @click="showPass = !showPass" class="absolute right-3 top-1/2 -translate-y-1/2 text-text-muted">
                <EyeIcon v-if="!showPass" class="w-4 h-4" /><EyeOffIcon v-else class="w-4 h-4" />
              </button>
            </div>
            <p v-if="form.errors.password" class="koda-error">{{ form.errors.password }}</p>
          </div>
          <div>
            <label class="koda-label">Confirm Password</label>
            <input v-model="form.password_confirmation" type="password" class="koda-input" placeholder="Repeat password" />
          </div>
          <button type="submit" :disabled="form.processing" class="btn-primary w-full py-3">
            <LoaderIcon v-if="form.processing" class="w-4 h-4 animate-spin" />
            Reset Password
          </button>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { Link, useForm } from '@inertiajs/vue3';
import { EyeIcon, EyeOffIcon, LoaderIcon } from 'lucide-vue-next';
import KodaLogo from '@/Components/UI/KodaLogo.vue';

const props = defineProps({ token: String, email: String });
const showPass = ref(false);
const form = useForm({ token: props.token, email: props.email, password: '', password_confirmation: '' });
function submit() { form.post(route('password.store'), { onFinish: () => form.reset('password', 'password_confirmation') }); }
</script>

KODA_FILE_186D61B9

# --- resources/js/Pages/Auth/VerifyEmail.vue ---
mkdir -p "resources/js/Pages/Auth"
cat > "resources/js/Pages/Auth/VerifyEmail.vue" << 'KODA_FILE_CBAA0DD7'
<template>
  <div class="min-h-screen bg-bg-primary flex items-center justify-center p-4">
    <div class="relative w-full max-w-md text-center">
      <Link :href="route('home')"><KodaLogo class="h-10 w-auto mx-auto mb-8" /></Link>
      <div class="koda-card">
        <div class="w-14 h-14 rounded-full bg-accent-subtle border border-accent-muted flex items-center justify-center mx-auto mb-5">
          <MailIcon class="w-7 h-7 text-accent" />
        </div>
        <h1 class="font-heading text-xl font-bold mb-2">Verify your email</h1>
        <p class="text-text-secondary text-sm leading-relaxed mb-6">
          Thanks for signing up! Before getting started, please verify your email address by clicking the link we sent to
          <span class="text-accent">{{ $page.props.auth.user?.email }}</span>.
        </p>
        <div v-if="verificationSent" class="bg-green-950 border border-green-900 rounded-btn p-3 mb-4">
          <p class="text-sm text-status-success">A new verification link has been sent!</p>
        </div>
        <div class="flex flex-col gap-3">
          <button @click="resend" :disabled="sending" class="btn-primary w-full">
            <LoaderIcon v-if="sending" class="w-4 h-4 animate-spin" />
            Resend verification email
          </button>
          <button @click="logout" class="btn-ghost w-full text-text-muted">Log out</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { Link, router } from '@inertiajs/vue3';
import { MailIcon, LoaderIcon } from 'lucide-vue-next';
import KodaLogo from '@/Components/UI/KodaLogo.vue';

const sending = ref(false);
const verificationSent = ref(false);

function resend() {
  sending.value = true;
  router.post(route('verification.send'), {}, {
    onFinish: () => { sending.value = false; verificationSent.value = true; }
  });
}
function logout() { router.post(route('logout')); }
</script>

KODA_FILE_CBAA0DD7

# --- resources/js/Pages/Buyer/Orders/Index.vue ---
mkdir -p "resources/js/Pages/Buyer/Orders"
cat > "resources/js/Pages/Buyer/Orders/Index.vue" << 'KODA_FILE_39A5A81E'
<template>
  <AppLayout>
    <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
      <div class="mb-8">
        <h1 class="font-heading text-3xl font-bold">My Orders</h1>
        <p class="text-text-muted text-sm mt-1">Track and manage your purchases</p>
      </div>

      <!-- Filter tabs -->
      <div class="flex gap-1 mb-6 border-b border-border">
        <button
          v-for="tab in tabs"
          :key="tab.value"
          @click="activeTab = tab.value"
          :class="[
            'px-4 py-3 text-sm font-medium transition-colors border-b-2 -mb-px',
            activeTab === tab.value
              ? 'border-accent text-accent'
              : 'border-transparent text-text-muted hover:text-text-secondary',
          ]"
        >
          {{ tab.label }}
          <span v-if="tab.count" class="ml-1.5 text-xs bg-bg-tertiary px-1.5 py-0.5 rounded-full">{{ tab.count }}</span>
        </button>
      </div>

      <!-- Orders list -->
      <div v-if="filteredOrders.length" class="space-y-4">
        <div v-for="order in filteredOrders" :key="order.id" class="koda-card">
          <!-- Order header -->
          <div class="flex items-center justify-between gap-4 mb-4 pb-4 border-b border-border">
            <div class="flex items-center gap-4 flex-wrap">
              <div>
                <p class="text-xs text-text-muted">Order</p>
                <p class="font-mono text-sm font-semibold text-text-primary">#{{ order.order_number }}</p>
              </div>
              <div>
                <p class="text-xs text-text-muted">Date</p>
                <p class="text-sm text-text-secondary">{{ order.created_at_human }}</p>
              </div>
              <div>
                <p class="text-xs text-text-muted">Total</p>
                <p class="text-sm font-bold text-accent">{{ formatPrice(order.total) }}</p>
              </div>
            </div>
            <div class="flex items-center gap-2 shrink-0">
              <span :class="statusClass(order.status)">{{ order.status }}</span>
              <Link :href="route('orders.show', order.id)" class="btn-ghost text-xs gap-1">
                Details <ArrowRightIcon class="w-3.5 h-3.5" />
              </Link>
            </div>
          </div>

          <!-- Order items preview -->
          <div class="flex items-center gap-3 flex-wrap">
            <div
              v-for="item in order.items.slice(0, 4)"
              :key="item.id"
              class="flex items-center gap-2.5"
            >
              <div class="w-10 h-10 rounded-lg overflow-hidden bg-bg-tertiary border border-border shrink-0">
                <img v-if="item.product?.thumbnail" :src="item.product.thumbnail" class="w-full h-full object-cover" />
                <PackageIcon v-else class="w-4 h-4 text-border m-auto mt-3" />
              </div>
              <div>
                <p class="text-xs font-medium text-text-primary line-clamp-1 max-w-32">{{ item.product?.name }}</p>
                <p class="text-xs text-text-muted">Qty: {{ item.quantity }}</p>
              </div>
            </div>
            <span v-if="order.items.length > 4" class="text-xs text-text-muted">
              +{{ order.items.length - 4 }} more
            </span>
          </div>

          <!-- Track / Review actions -->
          <div class="flex items-center gap-2 mt-4 pt-4 border-t border-border">
            <Link :href="route('orders.show', order.id)" class="btn-secondary text-xs py-1.5">
              <TruckIcon class="w-3.5 h-3.5" />
              Track Order
            </Link>
            <button v-if="order.status === 'delivered'" class="btn-ghost text-xs py-1.5 gap-1.5 text-text-muted">
              <StarIcon class="w-3.5 h-3.5" />
              Write Review
            </button>
            <button v-if="['pending','processing'].includes(order.status)" class="btn-ghost text-xs py-1.5 gap-1.5 text-status-error hover:bg-red-950/30">
              <XIcon class="w-3.5 h-3.5" />
              Cancel
            </button>
          </div>
        </div>
      </div>

      <!-- Empty state -->
      <div v-else class="text-center py-20">
        <ShoppingBagIcon class="w-14 h-14 mx-auto text-border mb-4" />
        <h3 class="font-heading text-xl font-bold mb-2">No orders yet</h3>
        <p class="text-text-muted text-sm mb-6">Start shopping to see your orders here</p>
        <Link :href="route('products.index')" class="btn-primary px-8">Browse Products</Link>
      </div>

      <Pagination :links="orders.links" />
    </div>
  </AppLayout>
</template>

<script setup>
import { ref, computed } from 'vue';
import { Link } from '@inertiajs/vue3';
import { ArrowRightIcon, PackageIcon, TruckIcon, StarIcon, XIcon, ShoppingBagIcon } from 'lucide-vue-next';
import AppLayout from '@/Layouts/AppLayout.vue';
import Pagination from '@/Components/UI/Pagination.vue';

const props = defineProps({
  orders: { type: Object, default: () => ({ data: [], links: [] }) },
});

const activeTab = ref('all');

const tabs = computed(() => [
  { label: 'All',        value: 'all',        count: props.orders.data.length },
  { label: 'Pending',    value: 'pending',    count: props.orders.data.filter(o => o.status === 'pending').length || null },
  { label: 'Processing', value: 'processing', count: null },
  { label: 'Shipped',    value: 'shipped',    count: null },
  { label: 'Delivered',  value: 'delivered',  count: null },
]);

const filteredOrders = computed(() => {
  if (activeTab.value === 'all') return props.orders.data;
  return props.orders.data.filter(o => o.status === activeTab.value);
});

function formatPrice(p) {
  return new Intl.NumberFormat('en-KE', { style: 'currency', currency: 'KES' }).format(p);
}

function statusClass(s) {
  return {
    pending:    'badge badge-warning',
    processing: 'badge badge-info',
    shipped:    'badge badge-neutral',
    delivered:  'badge badge-success',
    cancelled:  'badge badge-error',
  }[s] ?? 'badge badge-neutral';
}
</script>

KODA_FILE_39A5A81E

# --- resources/js/Pages/Buyer/Orders/Show.vue ---
mkdir -p "resources/js/Pages/Buyer/Orders"
cat > "resources/js/Pages/Buyer/Orders/Show.vue" << 'KODA_FILE_67ED8313'
<template>
  <AppLayout>
    <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
      <!-- Breadcrumb -->
      <Breadcrumb :items="[{ label: 'My Orders', href: route('buyer.orders.index') }, { label: '#' + order.order_number }]" class="mb-6" />

      <!-- Header -->
      <div class="flex items-start justify-between gap-4 mb-8">
        <div>
          <h1 class="font-heading text-2xl font-bold">Order #{{ order.order_number }}</h1>
          <p class="text-text-muted text-sm mt-1">Placed {{ order.created_at_human }}</p>
        </div>
        <span :class="statusClass(order.status)" class="text-sm px-3 py-1.5">{{ order.status }}</span>
      </div>

      <!-- Tracking timeline -->
      <div class="koda-card mb-6">
        <h3 class="font-heading text-base font-bold mb-6">Order Progress</h3>
        <div class="relative">
          <!-- Progress bar -->
          <div class="absolute top-4 left-4 right-4 h-0.5 bg-border" />
          <div
            class="absolute top-4 left-4 h-0.5 bg-accent transition-all duration-500"
            :style="{ width: progressWidth }"
          />

          <div class="relative flex items-start justify-between">
            <div v-for="(step, i) in trackingSteps" :key="step.label" class="flex flex-col items-center gap-2 flex-1">
              <div :class="[
                'w-8 h-8 rounded-full border-2 flex items-center justify-center z-10 transition-all',
                isStepComplete(i)
                  ? 'bg-accent border-accent'
                  : isStepActive(i)
                    ? 'bg-bg-secondary border-accent'
                    : 'bg-bg-secondary border-border',
              ]">
                <CheckIcon v-if="isStepComplete(i)" class="w-4 h-4 text-white" />
                <div v-else-if="isStepActive(i)" class="w-2 h-2 rounded-full bg-accent" />
                <div v-else class="w-2 h-2 rounded-full bg-border" />
              </div>
              <div class="text-center">
                <p :class="['text-xs font-medium', isStepComplete(i) || isStepActive(i) ? 'text-text-primary' : 'text-text-muted']">
                  {{ step.label }}
                </p>
                <p v-if="step.time" class="text-xs text-text-muted mt-0.5">{{ step.time }}</p>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
        <!-- Shipping details -->
        <div class="koda-card">
          <h3 class="font-heading text-sm font-bold mb-4 flex items-center gap-2">
            <TruckIcon class="w-4 h-4 text-accent" /> Shipping Details
          </h3>
          <div class="space-y-2 text-sm text-text-secondary">
            <p class="font-semibold text-text-primary">{{ order.shipping_name }}</p>
            <p>{{ order.shipping_address }}</p>
            <p>{{ order.shipping_city }}, {{ order.shipping_country }}</p>
            <p v-if="order.shipping_phone">{{ order.shipping_phone }}</p>
            <p>{{ order.shipping_email }}</p>
          </div>
        </div>

        <!-- Payment details -->
        <div class="koda-card">
          <h3 class="font-heading text-sm font-bold mb-4 flex items-center gap-2">
            <CreditCardIcon class="w-4 h-4 text-accent" /> Payment
          </h3>
          <div class="space-y-2.5 text-sm">
            <div class="flex justify-between text-text-secondary">
              <span>Subtotal</span><span>{{ formatPrice(order.subtotal) }}</span>
            </div>
            <div v-if="order.discount > 0" class="flex justify-between text-status-success">
              <span>Discount</span><span>-{{ formatPrice(order.discount) }}</span>
            </div>
            <div class="flex justify-between text-text-secondary">
              <span>Shipping</span><span>{{ order.shipping > 0 ? formatPrice(order.shipping) : 'Free' }}</span>
            </div>
            <div class="border-t border-border pt-2 flex justify-between font-heading font-bold">
              <span>Total</span><span class="text-accent">{{ formatPrice(order.total) }}</span>
            </div>
            <div class="pt-1">
              <span :class="['badge', order.payment_status === 'paid' ? 'badge-success' : 'badge-warning']">
                {{ order.payment_status }}
              </span>
              <span class="text-xs text-text-muted ml-2 capitalize">{{ order.payment_method }}</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Order items -->
      <div class="koda-card">
        <h3 class="font-heading text-base font-bold mb-4">Items ({{ order.items?.length }})</h3>
        <div class="space-y-4">
          <div v-for="item in order.items" :key="item.id" class="flex items-center gap-4 pb-4 border-b border-border last:border-0 last:pb-0">
            <Link :href="route('products.show', item.product?.slug)" class="shrink-0">
              <div class="w-16 h-16 rounded-lg overflow-hidden bg-bg-tertiary border border-border">
                <img v-if="item.product?.thumbnail" :src="item.product.thumbnail" class="w-full h-full object-cover" />
              </div>
            </Link>
            <div class="flex-1 min-w-0">
              <Link :href="route('products.show', item.product?.slug)" class="font-medium text-sm text-text-primary hover:text-accent transition-colors line-clamp-1">
                {{ item.product?.name }}
              </Link>
              <p class="text-xs text-text-muted mt-0.5">{{ item.product?.vendor?.store_name }}</p>
              <div class="flex items-center gap-3 mt-1.5">
                <span class="text-xs text-text-muted">Qty: {{ item.quantity }}</span>
                <span class="text-xs text-text-muted">@ {{ formatPrice(item.unit_price) }}</span>
                <span :class="statusClass(item.status)" class="text-xs">{{ item.status }}</span>
              </div>
            </div>
            <div class="text-right shrink-0">
              <p class="font-semibold text-accent text-sm">{{ formatPrice(item.subtotal) }}</p>
            </div>
          </div>
        </div>
      </div>

      <!-- Actions -->
      <div class="flex items-center gap-3 mt-6">
        <Link :href="route('buyer.orders.index')" class="btn-ghost gap-2">
          <ArrowLeftIcon class="w-4 h-4" /> Back to Orders
        </Link>
        <button class="btn-secondary gap-2 text-sm">
          <DownloadIcon class="w-4 h-4" /> Download Invoice
        </button>
      </div>
    </div>
  </AppLayout>
</template>

<script setup>
import { computed } from 'vue';
import { Link } from '@inertiajs/vue3';
import { CheckIcon, TruckIcon, CreditCardIcon, ArrowLeftIcon, DownloadIcon } from 'lucide-vue-next';
import AppLayout from '@/Layouts/AppLayout.vue';
import Breadcrumb from '@/Components/UI/Breadcrumb.vue';

const props = defineProps({
  order: { type: Object, required: true },
});

const statusOrder = ['pending', 'processing', 'shipped', 'delivered'];
const currentStepIndex = computed(() => statusOrder.indexOf(props.order.status));

const trackingSteps = [
  { label: 'Order Placed', time: props.order.created_at_human },
  { label: 'Processing',   time: null },
  { label: 'Shipped',      time: null },
  { label: 'Delivered',    time: null },
];

const progressWidth = computed(() => {
  const pct = ((currentStepIndex.value) / (trackingSteps.length - 1)) * 100;
  return `${Math.max(0, pct)}%`;
});

function isStepComplete(i) { return i < currentStepIndex.value; }
function isStepActive(i)   { return i === currentStepIndex.value; }

function formatPrice(p) {
  return new Intl.NumberFormat('en-KE', { style: 'currency', currency: 'KES' }).format(p);
}

function statusClass(s) {
  return {
    pending:    'badge badge-warning',
    processing: 'badge badge-info',
    shipped:    'badge badge-neutral',
    delivered:  'badge badge-success',
    cancelled:  'badge badge-error',
    paid:       'badge badge-success',
    unpaid:     'badge badge-warning',
  }[s] ?? 'badge badge-neutral';
}
</script>

KODA_FILE_67ED8313

# --- resources/js/Pages/Buyer/Wishlist.vue ---
mkdir -p "resources/js/Pages/Buyer"
cat > "resources/js/Pages/Buyer/Wishlist.vue" << 'KODA_FILE_3C3086E1'
<template>
  <AppLayout>
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
      <div class="mb-8">
        <h1 class="font-heading text-3xl font-bold">Wishlist</h1>
        <p class="text-text-muted text-sm mt-1">{{ items.length }} saved item(s)</p>
      </div>

      <div v-if="items.length" class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4">
        <ProductCard
          v-for="item in items"
          :key="item.id"
          :product="{ ...item.product, in_wishlist: true }"
        />
      </div>

      <div v-else class="text-center py-24">
        <HeartIcon class="w-14 h-14 mx-auto text-border mb-4" />
        <h3 class="font-heading text-xl font-bold mb-2">Your wishlist is empty</h3>
        <p class="text-text-muted text-sm mb-6">Save items you love by clicking the heart icon</p>
        <Link :href="route('products.index')" class="btn-primary px-8">Browse Products</Link>
      </div>
    </div>
  </AppLayout>
</template>

<script setup>
import { Link } from '@inertiajs/vue3';
import { HeartIcon } from 'lucide-vue-next';
import AppLayout from '@/Layouts/AppLayout.vue';
import ProductCard from '@/Components/Shared/ProductCard.vue';

defineProps({ items: { type: Array, default: () => [] } });
</script>

KODA_FILE_3C3086E1

# --- resources/js/Pages/Errors/404.vue ---
mkdir -p "resources/js/Pages/Errors"
cat > "resources/js/Pages/Errors/404.vue" << 'KODA_FILE_601D28A2'
<template>
  <AppLayout>
    <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-24 text-center">
      <p class="font-mono text-6xl font-bold text-accent mb-4">404</p>
      <h1 class="font-heading text-3xl font-bold mb-4">Page not found</h1>
      <p class="text-text-muted mb-8">The page you're looking for doesn't exist or has been moved.</p>
      <div class="flex items-center justify-center gap-4">
        <Link :href="route('home')" class="btn-primary px-8">Go Home</Link>
        <Link :href="route('products.index')" class="btn-secondary px-8">Browse Products</Link>
      </div>
    </div>
  </AppLayout>
</template>

<script setup>
import { Link } from '@inertiajs/vue3';
import AppLayout from '@/Layouts/AppLayout.vue';
</script>

KODA_FILE_601D28A2

# --- resources/js/Pages/Notifications/Index.vue ---
mkdir -p "resources/js/Pages/Notifications"
cat > "resources/js/Pages/Notifications/Index.vue" << 'KODA_FILE_D4EE434D'
<template>
  <AppLayout>
    <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
      <div class="flex items-center justify-between mb-8">
        <div>
          <h1 class="font-heading text-3xl font-bold">Notifications</h1>
          <p class="text-text-muted text-sm mt-1">{{ unreadCount }} unread</p>
        </div>
        <button v-if="unreadCount > 0" @click="markAllRead" class="btn-secondary text-sm">
          <CheckCheckIcon class="w-4 h-4" />
          Mark all as read
        </button>
      </div>

      <div v-if="notifications.data.length" class="space-y-2">
        <div
          v-for="notif in notifications.data"
          :key="notif.id"
          :class="[
            'koda-card flex items-start gap-4 transition-all cursor-pointer',
            !notif.read_at ? 'border-accent/20 bg-accent-subtle/5' : '',
          ]"
          @click="openNotification(notif)"
        >
          <!-- Icon -->
          <div :class="['w-9 h-9 rounded-full flex items-center justify-center shrink-0', iconBg(notif.data.type)]">
            <component :is="notifIcon(notif.data.type)" class="w-4 h-4" :class="iconColor(notif.data.type)" />
          </div>

          <!-- Content -->
          <div class="flex-1 min-w-0">
            <p :class="['text-sm', !notif.read_at ? 'font-semibold text-text-primary' : 'text-text-secondary']">
              {{ notif.data.message }}
            </p>
            <p class="text-xs text-text-muted mt-0.5">{{ formatRelative(notif.created_at) }}</p>
          </div>

          <!-- Unread dot -->
          <div v-if="!notif.read_at" class="w-2 h-2 rounded-full bg-accent mt-1.5 shrink-0" />
        </div>
      </div>

      <!-- Empty -->
      <div v-else class="text-center py-20 text-text-muted">
        <BellIcon class="w-14 h-14 mx-auto mb-4 text-border" />
        <h3 class="font-heading text-lg font-bold">All caught up!</h3>
        <p class="text-sm mt-1">No notifications yet</p>
      </div>

      <Pagination :links="notifications.links" />
    </div>
  </AppLayout>
</template>

<script setup>
import { computed } from 'vue';
import { router } from '@inertiajs/vue3';
import {
  BellIcon, ShoppingBagIcon, CheckCheckIcon,
  StoreIcon, StarIcon, BanknoteIcon, PackageIcon,
} from 'lucide-vue-next';
import AppLayout from '@/Layouts/AppLayout.vue';
import Pagination from '@/Components/UI/Pagination.vue';
import { useFormat } from '@/composables/useFormat';

const props = defineProps({
  notifications: { type: Object, default: () => ({ data: [], links: [] }) },
});

const { formatRelative } = useFormat();

const unreadCount = computed(() => props.notifications.data.filter(n => !n.read_at).length);

function markAllRead() {
  router.post(route('notifications.read'), {}, { preserveScroll: true });
}

function openNotification(notif) {
  if (!notif.read_at) {
    router.post(route('notifications.read'), { id: notif.id }, { preserveScroll: true });
  }
  if (notif.data.url) {
    router.visit(notif.data.url);
  }
}

function notifIcon(type) {
  return {
    new_order:       ShoppingBagIcon,
    vendor_approved: StoreIcon,
    order_confirmed: PackageIcon,
    new_review:      StarIcon,
    payout:          BanknoteIcon,
  }[type] ?? BellIcon;
}

function iconBg(type) {
  return {
    new_order:       'bg-blue-950',
    vendor_approved: 'bg-green-950',
    order_confirmed: 'bg-accent-subtle',
    new_review:      'bg-yellow-950',
    payout:          'bg-green-950',
  }[type] ?? 'bg-bg-tertiary';
}

function iconColor(type) {
  return {
    new_order:       'text-blue-400',
    vendor_approved: 'text-green-400',
    order_confirmed: 'text-accent',
    new_review:      'text-yellow-400',
    payout:          'text-green-400',
  }[type] ?? 'text-text-muted';
}
</script>

KODA_FILE_D4EE434D

# --- resources/js/Pages/Profile/Edit.vue ---
mkdir -p "resources/js/Pages/Profile"
cat > "resources/js/Pages/Profile/Edit.vue" << 'KODA_FILE_0FF28B23'
<template>
  <AppLayout>
    <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
      <div class="mb-8">
        <h1 class="font-heading text-3xl font-bold">Account Settings</h1>
        <p class="text-text-muted text-sm mt-1">Manage your profile and security settings</p>
      </div>

      <!-- Avatar + name -->
      <div class="koda-card mb-6">
        <div class="flex items-center gap-5 mb-6">
          <div class="w-16 h-16 rounded-full bg-accent-muted border-2 border-accent/30 flex items-center justify-center shrink-0">
            <span class="text-accent text-xl font-bold">{{ initials }}</span>
          </div>
          <div>
            <p class="font-heading text-lg font-bold">{{ $page.props.auth.user?.name }}</p>
            <p class="text-text-muted text-sm">{{ $page.props.auth.user?.email }}</p>
            <div class="flex gap-1.5 mt-1.5">
              <span v-for="role in $page.props.auth.user?.roles" :key="role" class="badge badge-accent text-xs capitalize">{{ role }}</span>
            </div>
          </div>
        </div>

        <form @submit.prevent="updateProfile" class="space-y-4">
          <h3 class="font-heading text-sm font-bold text-text-primary border-b border-border pb-3">Personal Information</h3>
          <div class="grid grid-cols-2 gap-4">
            <div>
              <label class="koda-label">Full Name</label>
              <input v-model="profileForm.name" type="text" class="koda-input" :class="{ error: profileErrors.name }" />
              <p v-if="profileErrors.name" class="koda-error">{{ profileErrors.name }}</p>
            </div>
            <div>
              <label class="koda-label">Email</label>
              <input v-model="profileForm.email" type="email" class="koda-input" :class="{ error: profileErrors.email }" />
              <p v-if="profileErrors.email" class="koda-error">{{ profileErrors.email }}</p>
            </div>
          </div>
          <div class="flex justify-end">
            <button type="submit" :disabled="profileSaving" class="btn-primary px-6">
              <LoaderIcon v-if="profileSaving" class="w-4 h-4 animate-spin" />
              Save Changes
            </button>
          </div>
        </form>
      </div>

      <!-- Change password -->
      <div class="koda-card mb-6">
        <form @submit.prevent="updatePassword" class="space-y-4">
          <h3 class="font-heading text-sm font-bold text-text-primary border-b border-border pb-3">Change Password</h3>
          <div>
            <label class="koda-label">Current Password</label>
            <input v-model="passwordForm.current_password" type="password" class="koda-input" :class="{ error: passwordErrors.current_password }" />
            <p v-if="passwordErrors.current_password" class="koda-error">{{ passwordErrors.current_password }}</p>
          </div>
          <div class="grid grid-cols-2 gap-4">
            <div>
              <label class="koda-label">New Password</label>
              <input v-model="passwordForm.password" type="password" class="koda-input" :class="{ error: passwordErrors.password }" placeholder="At least 8 characters" />
              <p v-if="passwordErrors.password" class="koda-error">{{ passwordErrors.password }}</p>
            </div>
            <div>
              <label class="koda-label">Confirm New Password</label>
              <input v-model="passwordForm.password_confirmation" type="password" class="koda-input" />
            </div>
          </div>
          <div class="flex justify-end">
            <button type="submit" :disabled="passwordSaving" class="btn-primary px-6">
              <LoaderIcon v-if="passwordSaving" class="w-4 h-4 animate-spin" />
              Update Password
            </button>
          </div>
        </form>
      </div>

      <!-- Danger zone -->
      <div class="koda-card border-status-error/30">
        <h3 class="font-heading text-sm font-bold text-status-error mb-4">Danger Zone</h3>
        <div class="flex items-center justify-between gap-4">
          <div>
            <p class="text-sm font-medium text-text-primary">Delete Account</p>
            <p class="text-xs text-text-muted mt-0.5">Permanently delete your account and all data. This cannot be undone.</p>
          </div>
          <button @click="confirmDelete = true" class="btn-danger shrink-0">Delete Account</button>
        </div>
      </div>

      <!-- Delete confirm modal -->
      <Modal v-model="confirmDelete" title="Delete Account" max-width="sm">
        <div class="space-y-4">
          <div class="flex items-start gap-3 p-3 bg-red-950/30 border border-red-900/50 rounded-btn">
            <AlertTriangleIcon class="w-5 h-5 text-status-error shrink-0 mt-0.5" />
            <p class="text-sm text-text-secondary">This will permanently delete all your data, orders, and account. <strong class="text-text-primary">This cannot be undone.</strong></p>
          </div>
          <div>
            <label class="koda-label">Enter your password to confirm</label>
            <input v-model="deletePassword" type="password" class="koda-input" placeholder="Your password" />
          </div>
        </div>
        <template #footer>
          <button @click="confirmDelete = false" class="btn-ghost">Cancel</button>
          <button @click="deleteAccount" :disabled="!deletePassword" class="btn-danger">Delete My Account</button>
        </template>
      </Modal>
    </div>
  </AppLayout>
</template>

<script setup>
import { ref, computed } from 'vue';
import { router, usePage } from '@inertiajs/vue3';
import { LoaderIcon, AlertTriangleIcon } from 'lucide-vue-next';
import AppLayout from '@/Layouts/AppLayout.vue';
import Modal from '@/Components/UI/Modal.vue';

const page = usePage();
const user = page.props.auth.user;

const initials = computed(() => (user?.name ?? '').split(' ').map(n => n[0]).slice(0, 2).join('').toUpperCase());

const profileForm    = ref({ name: user?.name ?? '', email: user?.email ?? '' });
const profileErrors  = ref({});
const profileSaving  = ref(false);

const passwordForm   = ref({ current_password: '', password: '', password_confirmation: '' });
const passwordErrors = ref({});
const passwordSaving = ref(false);

const confirmDelete  = ref(false);
const deletePassword = ref('');

function updateProfile() {
  profileSaving.value = true;
  router.patch(route('profile.update'), profileForm.value, {
    preserveScroll: true,
    onError:  e => { profileErrors.value = e; },
    onFinish: () => { profileSaving.value = false; },
  });
}

function updatePassword() {
  passwordSaving.value = true;
  router.put(route('password.update'), passwordForm.value, {
    preserveScroll: true,
    onSuccess: () => { passwordForm.value = { current_password: '', password: '', password_confirmation: '' }; },
    onError:   e => { passwordErrors.value = e; },
    onFinish:  () => { passwordSaving.value = false; },
  });
}

function deleteAccount() {
  router.delete(route('profile.destroy'), { data: { password: deletePassword.value } });
}
</script>

KODA_FILE_0FF28B23

# --- resources/js/Pages/Public/About.vue ---
mkdir -p "resources/js/Pages/Public"
cat > "resources/js/Pages/Public/About.vue" << 'KODA_FILE_39E25B1E'
<template>
  <AppLayout>
    <!-- Hero -->
    <section class="relative overflow-hidden bg-bg-primary">
      <div class="absolute inset-0 bg-hero-gradient pointer-events-none" />
      <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 pt-20 pb-16 text-center relative">
        <div class="inline-flex items-center gap-2 bg-accent-subtle border border-accent-muted px-4 py-1.5 rounded-full mb-6">
          <SparklesIcon class="w-3.5 h-3.5 text-accent" />
          <span class="text-xs font-medium text-accent">Our Story</span>
        </div>
        <h1 class="font-heading text-5xl font-bold tracking-tight mb-6">
          Built for African<br /><span class="text-gradient">Business</span>
        </h1>
        <p class="text-text-secondary text-lg leading-relaxed max-w-2xl mx-auto">
          Koda is a verified B2B marketplace connecting quality vendors with serious business buyers across Africa.
          We believe every business deserves access to reliable suppliers and seamless procurement.
        </p>
      </div>
    </section>

    <!-- Mission -->
    <section class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
      <div class="grid grid-cols-1 md:grid-cols-2 gap-12 items-center">
        <div>
          <h2 class="font-heading text-3xl font-bold mb-5">Our Mission</h2>
          <p class="text-text-secondary leading-relaxed mb-4">
            We started Koda to solve a real problem: finding trusted vendors for business supplies is hard, slow, and unreliable. Phone calls, WhatsApp groups, and word-of-mouth aren't good enough for modern businesses.
          </p>
          <p class="text-text-secondary leading-relaxed">
            Koda brings structure, trust, and transparency to B2B commerce. Every vendor is verified. Every product is reviewed. Every transaction is tracked.
          </p>
        </div>
        <div class="grid grid-cols-2 gap-4">
          <div v-for="stat in stats" :key="stat.label" class="koda-card text-center py-6">
            <p class="font-heading text-3xl font-bold text-accent">{{ stat.value }}</p>
            <p class="text-text-muted text-sm mt-1">{{ stat.label }}</p>
          </div>
        </div>
      </div>
    </section>

    <!-- Values -->
    <section class="bg-bg-secondary border-y border-border py-16">
      <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8">
        <h2 class="font-heading text-3xl font-bold text-center mb-12">What We Stand For</h2>
        <div class="grid grid-cols-1 sm:grid-cols-3 gap-6">
          <div v-for="value in values" :key="value.title" class="koda-card text-center">
            <div class="w-12 h-12 rounded-xl bg-accent-subtle flex items-center justify-center mx-auto mb-4">
              <component :is="value.icon" class="w-6 h-6 text-accent" />
            </div>
            <h3 class="font-heading text-base font-bold mb-2">{{ value.title }}</h3>
            <p class="text-text-muted text-sm">{{ value.desc }}</p>
          </div>
        </div>
      </div>
    </section>

    <!-- CTA -->
    <section class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-20 text-center">
      <h2 class="font-heading text-3xl font-bold mb-4">Ready to join Koda?</h2>
      <p class="text-text-secondary mb-8">Whether you're buying or selling, we're built for you.</p>
      <div class="flex flex-col sm:flex-row items-center justify-center gap-4">
        <Link :href="route('products.index')" class="btn-primary px-8 py-3 text-base">Start Buying</Link>
        <Link :href="route('vendor.apply')" class="btn-secondary px-8 py-3 text-base">Become a Vendor</Link>
      </div>
    </section>
  </AppLayout>
</template>

<script setup>
import { Link } from '@inertiajs/vue3';
import { SparklesIcon, ShieldCheckIcon, TrendingUpIcon, UsersIcon } from 'lucide-vue-next';
import AppLayout from '@/Layouts/AppLayout.vue';

const stats = [
  { value: '500+',  label: 'Verified Vendors'  },
  { value: '12K+',  label: 'Products Listed'   },
  { value: '8K+',   label: 'Business Buyers'   },
  { value: '98%',   label: 'Satisfaction Rate' },
];

const values = [
  { icon: ShieldCheckIcon, title: 'Trust First',    desc: 'Every vendor is manually verified before they can sell on the platform.' },
  { icon: TrendingUpIcon,  title: 'Growth Focused', desc: 'We build tools that help vendors grow their business and reach more buyers.' },
  { icon: UsersIcon,       title: 'Community',      desc: 'We foster long-term relationships between buyers and vendors, not just transactions.' },
];
</script>

KODA_FILE_39E25B1E

# --- resources/js/Pages/Public/Cart.vue ---
mkdir -p "resources/js/Pages/Public"
cat > "resources/js/Pages/Public/Cart.vue" << 'KODA_FILE_0F0ACAC6'
<template>
  <AppLayout>
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
      <h1 class="font-heading text-3xl font-bold mb-8">Shopping Cart</h1>

      <div v-if="cartItems.length" class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <!-- Items -->
        <div class="lg:col-span-2 space-y-4">
          <div v-for="item in cartItems" :key="item.id" class="koda-card flex gap-4">
            <Link :href="route('products.show', item.product.slug)" class="shrink-0">
              <div class="w-20 h-20 rounded-lg overflow-hidden bg-bg-tertiary border border-border">
                <img v-if="item.product.thumbnail" :src="item.product.thumbnail" :alt="item.product.name" class="w-full h-full object-cover" />
                <PackageIcon v-else class="w-8 h-8 text-border m-auto mt-6" />
              </div>
            </Link>

            <div class="flex-1 min-w-0">
              <div class="flex items-start justify-between gap-3">
                <div>
                  <Link :href="route('products.show', item.product.slug)" class="font-heading text-sm font-semibold text-text-primary hover:text-accent transition-colors line-clamp-1">
                    {{ item.product.name }}
                  </Link>
                  <p class="text-xs text-text-muted mt-0.5">{{ item.product.vendor?.store_name }}</p>
                </div>
                <button @click="removeItem(item.id)" class="btn-ghost p-1.5 text-text-muted hover:text-status-error transition-colors shrink-0">
                  <Trash2Icon class="w-4 h-4" />
                </button>
              </div>

              <div class="flex items-center justify-between mt-3">
                <div class="flex items-center gap-1 bg-bg-tertiary border border-border rounded-btn">
                  <button @click="updateQty(item, item.quantity - 1)" class="px-2.5 py-1.5 text-text-secondary hover:text-text-primary transition-colors">
                    <MinusIcon class="w-3.5 h-3.5" />
                  </button>
                  <span class="w-8 text-center text-sm font-medium">{{ item.quantity }}</span>
                  <button @click="updateQty(item, item.quantity + 1)" class="px-2.5 py-1.5 text-text-secondary hover:text-text-primary transition-colors">
                    <PlusIcon class="w-3.5 h-3.5" />
                  </button>
                </div>
                <span class="font-heading font-bold text-accent">{{ formatPrice(item.subtotal) }}</span>
              </div>
            </div>
          </div>

          <div class="flex items-center justify-between pt-2">
            <Link :href="route('products.index')" class="btn-ghost gap-2 text-sm text-text-muted">
              <ArrowLeftIcon class="w-4 h-4" />
              Continue Shopping
            </Link>
            <button @click="clearCart" class="btn-ghost gap-2 text-sm text-status-error hover:bg-red-950/30">
              <Trash2Icon class="w-4 h-4" />
              Clear cart
            </button>
          </div>
        </div>

        <!-- Summary -->
        <div class="lg:col-span-1">
          <div class="koda-card sticky top-24 space-y-5">
            <h2 class="font-heading text-lg font-bold">Order Summary</h2>

            <!-- Promo code -->
            <div>
              <label class="koda-label">Promo Code</label>
              <div class="flex gap-2">
                <input v-model="promoCode" type="text" placeholder="Enter code" class="koda-input text-sm flex-1" />
                <button @click="applyPromo" class="btn-secondary text-sm px-3 shrink-0">Apply</button>
              </div>
              <p v-if="promoMessage" :class="['text-xs mt-1', promoValid ? 'text-status-success' : 'text-status-error']">{{ promoMessage }}</p>
            </div>

            <div class="koda-divider" />

            <!-- Totals -->
            <div class="space-y-2.5 text-sm">
              <div class="flex justify-between text-text-secondary">
                <span>Subtotal ({{ cartItems.length }} items)</span>
                <span>{{ formatPrice(subtotal) }}</span>
              </div>
              <div v-if="discount > 0" class="flex justify-between text-status-success">
                <span>Discount</span>
                <span>-{{ formatPrice(discount) }}</span>
              </div>
              <div class="flex justify-between text-text-secondary">
                <span>Shipping</span>
                <span class="text-text-muted">Calculated at checkout</span>
              </div>
            </div>

            <div class="koda-divider" />

            <div class="flex justify-between font-heading text-lg font-bold">
              <span>Total</span>
              <span class="text-accent">{{ formatPrice(subtotal - discount) }}</span>
            </div>

            <Link :href="route('checkout.index')" class="btn-primary w-full py-3 text-base">
              Proceed to Checkout
              <ArrowRightIcon class="w-4 h-4" />
            </Link>

            <div class="flex items-center justify-center gap-2 text-xs text-text-muted">
              <ShieldCheckIcon class="w-3.5 h-3.5" />
              Secure checkout — SSL encrypted
            </div>
          </div>
        </div>
      </div>

      <!-- Empty cart -->
      <div v-else class="text-center py-24">
        <ShoppingCartIcon class="w-16 h-16 mx-auto text-border mb-4" />
        <h2 class="font-heading text-2xl font-bold mb-2">Your cart is empty</h2>
        <p class="text-text-muted mb-8">Add some products to get started</p>
        <Link :href="route('products.index')" class="btn-primary px-8">Browse Products</Link>
      </div>
    </div>
  </AppLayout>
</template>

<script setup>
import { ref, computed } from 'vue';
import { Link, router } from '@inertiajs/vue3';
import {
  Trash2Icon, MinusIcon, PlusIcon, ArrowLeftIcon, ArrowRightIcon,
  ShieldCheckIcon, ShoppingCartIcon, PackageIcon,
} from 'lucide-vue-next';
import AppLayout from '@/Layouts/AppLayout.vue';

const props = defineProps({
  cartItems: { type: Array, default: () => [] },
});

const promoCode = ref('');
const promoMessage = ref('');
const promoValid = ref(false);
const discount = ref(0);

const subtotal = computed(() => props.cartItems.reduce((s, i) => s + i.subtotal, 0));

function formatPrice(p) {
  return new Intl.NumberFormat('en-KE', { style: 'currency', currency: 'KES' }).format(p);
}
function updateQty(item, qty) {
  if (qty < 1) return;
  router.patch(route('cart.update', item.id), { quantity: qty }, { preserveScroll: true });
}
function removeItem(id) {
  router.delete(route('cart.remove', id), { preserveScroll: true });
}
function clearCart() {
  router.delete(route('cart.clear'), { preserveScroll: true });
}
function applyPromo() {
  router.post(route('cart.promo'), { code: promoCode.value }, {
    preserveScroll: true,
    onSuccess: (page) => {
      promoValid.value = true;
      promoMessage.value = 'Promo applied!';
      discount.value = page.props.discount ?? 0;
    },
    onError: () => {
      promoValid.value = false;
      promoMessage.value = 'Invalid promo code';
    },
  });
}
</script>

KODA_FILE_0F0ACAC6

# --- resources/js/Pages/Public/Categories/Index.vue ---
mkdir -p "resources/js/Pages/Public/Categories"
cat > "resources/js/Pages/Public/Categories/Index.vue" << 'KODA_FILE_1894ED54'
<template>
  <AppLayout>
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
      <div class="mb-8">
        <h1 class="font-heading text-3xl font-bold">All Categories</h1>
        <p class="text-text-muted text-sm mt-1">Browse {{ categories.length }} product categories</p>
      </div>

      <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-4">
        <Link
          v-for="cat in categories"
          :key="cat.id"
          :href="route('categories.show', cat.slug)"
          class="koda-card flex flex-col items-center gap-3 py-6 hover:border-accent/40 hover:shadow-glow cursor-pointer group transition-all text-center"
        >
          <div class="w-12 h-12 rounded-xl bg-accent-subtle flex items-center justify-center group-hover:bg-accent-muted transition-colors">
            <span class="text-2xl">{{ cat.icon ?? '📦' }}</span>
          </div>
          <div>
            <p class="text-sm font-semibold text-text-primary group-hover:text-accent transition-colors">{{ cat.name }}</p>
            <p class="text-xs text-text-muted mt-0.5">{{ cat.products_count }} products</p>
          </div>
        </Link>
      </div>

      <div v-if="!categories.length" class="text-center py-20 text-text-muted">
        <TagIcon class="w-12 h-12 mx-auto mb-3 text-border" />
        <p>No categories yet</p>
      </div>
    </div>
  </AppLayout>
</template>

<script setup>
import { Link } from '@inertiajs/vue3';
import { TagIcon } from 'lucide-vue-next';
import AppLayout from '@/Layouts/AppLayout.vue';

defineProps({
  categories: { type: Array, default: () => [] },
});
</script>

KODA_FILE_1894ED54

# --- resources/js/Pages/Public/Categories/Show.vue ---
mkdir -p "resources/js/Pages/Public/Categories"
cat > "resources/js/Pages/Public/Categories/Show.vue" << 'KODA_FILE_6C0C38DB'
<template>
  <AppLayout>
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
      <!-- Header -->
      <div class="flex items-center gap-4 mb-8">
        <div class="w-14 h-14 rounded-xl bg-accent-subtle flex items-center justify-center shrink-0">
          <span class="text-3xl">{{ category.icon ?? '📦' }}</span>
        </div>
        <div>
          <h1 class="font-heading text-3xl font-bold">{{ category.name }}</h1>
          <p class="text-text-muted text-sm mt-0.5">{{ products.total }} products</p>
        </div>
      </div>

      <!-- Toolbar -->
      <div class="flex items-center justify-between gap-4 mb-6">
        <div class="relative max-w-sm">
          <SearchIcon class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-text-muted pointer-events-none" />
          <input v-model="search" @input="doSearch" type="text" placeholder="Search in category…" class="koda-input pl-9 text-sm" />
        </div>
        <select v-model="sort" @change="doSearch" class="koda-select text-sm w-44">
          <option value="">Relevance</option>
          <option value="price_asc">Price: Low to High</option>
          <option value="price_desc">Price: High to Low</option>
          <option value="rating">Top Rated</option>
          <option value="newest">Newest</option>
        </select>
      </div>

      <!-- Grid -->
      <div v-if="products.data.length" class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4">
        <ProductCard v-for="product in products.data" :key="product.id" :product="product" />
      </div>

      <div v-else class="text-center py-20 text-text-muted">
        <PackageIcon class="w-12 h-12 mx-auto mb-3 text-border" />
        <p class="font-heading text-lg">No products in this category yet</p>
        <Link :href="route('products.index')" class="btn-ghost text-accent mt-3">Browse all products</Link>
      </div>

      <Pagination :links="products.links" />
    </div>
  </AppLayout>
</template>

<script setup>
import { ref } from 'vue';
import { Link, router } from '@inertiajs/vue3';
import { SearchIcon, PackageIcon } from 'lucide-vue-next';
import { useDebounceFn } from '@vueuse/core';
import AppLayout from '@/Layouts/AppLayout.vue';
import ProductCard from '@/Components/Shared/ProductCard.vue';
import Pagination from '@/Components/UI/Pagination.vue';

const props = defineProps({
  category: { type: Object, required: true },
  products: { type: Object, required: true },
  filters:  { type: Object, default: () => ({}) },
});

const search = ref(props.filters.q ?? '');
const sort   = ref(props.filters.sort ?? '');

const doSearch = useDebounceFn(() => {
  router.get(route('categories.show', props.category.slug), { q: search.value, sort: sort.value }, { preserveState: true, replace: true });
}, 350);
</script>

KODA_FILE_6C0C38DB

# --- resources/js/Pages/Public/Checkout.vue ---
mkdir -p "resources/js/Pages/Public"
cat > "resources/js/Pages/Public/Checkout.vue" << 'KODA_FILE_3BB3CA4C'
<template>
  <AppLayout>
    <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
      <h1 class="font-heading text-3xl font-bold mb-2">Checkout</h1>
      <p class="text-text-muted text-sm mb-8">Complete your order</p>

      <!-- Steps -->
      <div class="flex items-center gap-2 mb-10">
        <div v-for="(step, i) in steps" :key="step" class="flex items-center gap-2">
          <div :class="[
            'w-7 h-7 rounded-full flex items-center justify-center text-xs font-bold transition-all',
            currentStep > i + 1 ? 'bg-status-success text-white' :
            currentStep === i + 1 ? 'bg-accent text-white' :
            'bg-bg-tertiary text-text-muted border border-border',
          ]">
            <CheckIcon v-if="currentStep > i + 1" class="w-3.5 h-3.5" />
            <span v-else>{{ i + 1 }}</span>
          </div>
          <span :class="['text-sm font-medium', currentStep === i + 1 ? 'text-text-primary' : 'text-text-muted']">{{ step }}</span>
          <ChevronRightIcon v-if="i < steps.length - 1" class="w-4 h-4 text-border" />
        </div>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <!-- Form -->
        <div class="lg:col-span-2">
          <!-- Step 1: Shipping -->
          <div v-if="currentStep === 1" class="koda-card space-y-5">
            <h2 class="font-heading text-lg font-bold">Shipping Details</h2>
            <div class="grid grid-cols-2 gap-4">
              <div>
                <label class="koda-label">First Name</label>
                <input v-model="form.first_name" type="text" class="koda-input" :class="{ error: errors.first_name }" placeholder="John" />
                <p v-if="errors.first_name" class="koda-error">{{ errors.first_name }}</p>
              </div>
              <div>
                <label class="koda-label">Last Name</label>
                <input v-model="form.last_name" type="text" class="koda-input" placeholder="Doe" />
              </div>
            </div>
            <div>
              <label class="koda-label">Email</label>
              <input v-model="form.email" type="email" class="koda-input" placeholder="john@company.com" />
            </div>
            <div>
              <label class="koda-label">Phone</label>
              <input v-model="form.phone" type="tel" class="koda-input" placeholder="+254 7XX XXX XXX" />
            </div>
            <div>
              <label class="koda-label">Address</label>
              <input v-model="form.address" type="text" class="koda-input" placeholder="123 Business Park" />
            </div>
            <div class="grid grid-cols-2 gap-4">
              <div>
                <label class="koda-label">City</label>
                <input v-model="form.city" type="text" class="koda-input" placeholder="Nairobi" />
              </div>
              <div>
                <label class="koda-label">Country</label>
                <select v-model="form.country" class="koda-select">
                  <option value="KE">Kenya</option>
                  <option value="UG">Uganda</option>
                  <option value="TZ">Tanzania</option>
                  <option value="RW">Rwanda</option>
                </select>
              </div>
            </div>
            <div>
              <label class="koda-label">Order Notes (optional)</label>
              <textarea v-model="form.notes" rows="2" class="koda-textarea" placeholder="Any special instructions..." />
            </div>
            <div class="flex justify-end pt-2">
              <button @click="currentStep = 2" class="btn-primary px-8">
                Continue to Payment <ArrowRightIcon class="w-4 h-4" />
              </button>
            </div>
          </div>

          <!-- Step 2: Payment -->
          <div v-if="currentStep === 2" class="koda-card space-y-5">
            <h2 class="font-heading text-lg font-bold">Payment Method</h2>

            <div class="space-y-3">
              <label
                v-for="method in paymentMethods"
                :key="method.id"
                :class="[
                  'flex items-center gap-4 p-4 rounded-btn border-2 cursor-pointer transition-all',
                  form.payment_method === method.id ? 'border-accent bg-accent-subtle' : 'border-border hover:border-border-light',
                ]"
              >
                <input type="radio" :value="method.id" v-model="form.payment_method" class="accent-accent" />
                <div class="flex items-center gap-3">
                  <span class="text-2xl">{{ method.icon }}</span>
                  <div>
                    <p class="text-sm font-semibold text-text-primary">{{ method.label }}</p>
                    <p class="text-xs text-text-muted">{{ method.description }}</p>
                  </div>
                </div>
              </label>
            </div>

            <!-- Stripe card fields placeholder -->
            <div v-if="form.payment_method === 'stripe'" class="koda-card bg-bg-tertiary space-y-4">
              <div>
                <label class="koda-label">Card Number</label>
                <div id="stripe-card-element" class="koda-input min-h-[42px]" />
              </div>
              <div class="grid grid-cols-2 gap-4">
                <div>
                  <label class="koda-label">Expiry</label>
                  <div id="stripe-expiry-element" class="koda-input min-h-[42px]" />
                </div>
                <div>
                  <label class="koda-label">CVC</label>
                  <div id="stripe-cvc-element" class="koda-input min-h-[42px]" />
                </div>
              </div>
            </div>

            <div class="flex items-center justify-between pt-2">
              <button @click="currentStep = 1" class="btn-ghost gap-2">
                <ArrowLeftIcon class="w-4 h-4" /> Back
              </button>
              <button @click="currentStep = 3" class="btn-primary px-8">
                Review Order <ArrowRightIcon class="w-4 h-4" />
              </button>
            </div>
          </div>

          <!-- Step 3: Review -->
          <div v-if="currentStep === 3" class="koda-card space-y-5">
            <h2 class="font-heading text-lg font-bold">Review Order</h2>
            <div class="space-y-3">
              <div v-for="item in cartItems" :key="item.id" class="flex items-center gap-3">
                <img v-if="item.product.thumbnail" :src="item.product.thumbnail" class="w-12 h-12 rounded-lg object-cover border border-border shrink-0" />
                <div class="flex-1 min-w-0">
                  <p class="text-sm font-medium text-text-primary truncate">{{ item.product.name }}</p>
                  <p class="text-xs text-text-muted">Qty: {{ item.quantity }}</p>
                </div>
                <span class="text-sm font-semibold text-accent shrink-0">{{ formatPrice(item.subtotal) }}</span>
              </div>
            </div>
            <div class="koda-divider" />
            <div class="text-sm space-y-1.5 text-text-secondary">
              <p><span class="text-text-muted">Name:</span> {{ form.first_name }} {{ form.last_name }}</p>
              <p><span class="text-text-muted">Address:</span> {{ form.address }}, {{ form.city }}</p>
              <p><span class="text-text-muted">Payment:</span> {{ paymentMethods.find(m => m.id === form.payment_method)?.label }}</p>
            </div>
            <div class="flex items-center justify-between pt-2">
              <button @click="currentStep = 2" class="btn-ghost gap-2">
                <ArrowLeftIcon class="w-4 h-4" /> Back
              </button>
              <button @click="placeOrder" :disabled="submitting" class="btn-primary px-8 py-3">
                <LoaderIcon v-if="submitting" class="w-4 h-4 animate-spin" />
                Place Order
              </button>
            </div>
          </div>
        </div>

        <!-- Order summary -->
        <div>
          <div class="koda-card sticky top-24 space-y-4">
            <h3 class="font-heading text-base font-bold">Order Summary</h3>
            <div class="space-y-2 text-sm text-text-secondary">
              <div class="flex justify-between"><span>{{ cartItems.length }} items</span><span>{{ formatPrice(subtotal) }}</span></div>
              <div class="flex justify-between"><span>Shipping</span><span class="text-text-muted">TBD</span></div>
            </div>
            <div class="koda-divider" />
            <div class="flex justify-between font-heading font-bold text-base">
              <span>Total</span><span class="text-accent">{{ formatPrice(subtotal) }}</span>
            </div>
            <div class="flex items-center gap-2 text-xs text-text-muted pt-1">
              <ShieldCheckIcon class="w-3.5 h-3.5 text-accent" />
              256-bit SSL secure checkout
            </div>
          </div>
        </div>
      </div>
    </div>
  </AppLayout>
</template>

<script setup>
import { ref, computed } from 'vue';
import { Link, router, useForm } from '@inertiajs/vue3';
import { ArrowRightIcon, ArrowLeftIcon, CheckIcon, ChevronRightIcon, ShieldCheckIcon, LoaderIcon } from 'lucide-vue-next';
import AppLayout from '@/Layouts/AppLayout.vue';

const props = defineProps({
  cartItems: { type: Array, default: () => [] },
  user:      { type: Object, default: null },
});

const currentStep = ref(1);
const submitting = ref(false);
const steps = ['Shipping', 'Payment', 'Review'];
const errors = ref({});

const form = ref({
  first_name:     props.user?.name?.split(' ')[0] ?? '',
  last_name:      props.user?.name?.split(' ').slice(1).join(' ') ?? '',
  email:          props.user?.email ?? '',
  phone:          '',
  address:        '',
  city:           '',
  country:        'KE',
  notes:          '',
  payment_method: 'stripe',
});

const paymentMethods = [
  { id: 'stripe',       icon: '💳', label: 'Credit / Debit Card',  description: 'Visa, Mastercard, AMEX' },
  { id: 'flutterwave',  icon: '📱', label: 'Flutterwave',          description: 'M-Pesa, cards & more' },
  { id: 'mpesa',        icon: '📲', label: 'M-Pesa',               description: 'Pay via mobile money' },
];

const subtotal = computed(() => props.cartItems.reduce((s, i) => s + i.subtotal, 0));

function formatPrice(p) {
  return new Intl.NumberFormat('en-KE', { style: 'currency', currency: 'KES' }).format(p);
}

function placeOrder() {
  submitting.value = true;
  router.post(route('checkout.store'), form.value, {
    onFinish: () => { submitting.value = false; },
    onError: (e) => { errors.value = e; currentStep.value = 1; },
  });
}
</script>

KODA_FILE_3BB3CA4C

# --- resources/js/Pages/Public/Contact.vue ---
mkdir -p "resources/js/Pages/Public"
cat > "resources/js/Pages/Public/Contact.vue" << 'KODA_FILE_771F514A'
<template>
  <AppLayout>
    <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
      <div class="text-center mb-12">
        <h1 class="font-heading text-4xl font-bold mb-3">Contact Us</h1>
        <p class="text-text-secondary">We're here to help. Send us a message and we'll respond within 24 hours.</p>
      </div>

      <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
        <!-- Form -->
        <div class="koda-card">
          <form @submit.prevent="submit" class="space-y-4">
            <div class="grid grid-cols-2 gap-4">
              <div>
                <label class="koda-label">Name</label>
                <input v-model="form.name" type="text" class="koda-input" placeholder="Your name" />
              </div>
              <div>
                <label class="koda-label">Email</label>
                <input v-model="form.email" type="email" class="koda-input" placeholder="you@example.com" />
              </div>
            </div>
            <div>
              <label class="koda-label">Subject</label>
              <select v-model="form.subject" class="koda-select">
                <option value="">Select a topic</option>
                <option value="order">Order Issue</option>
                <option value="vendor">Vendor Support</option>
                <option value="payment">Payment Issue</option>
                <option value="general">General Enquiry</option>
              </select>
            </div>
            <div>
              <label class="koda-label">Message</label>
              <textarea v-model="form.message" rows="5" class="koda-textarea" placeholder="How can we help you?" />
            </div>
            <button type="submit" :disabled="submitting" class="btn-primary w-full py-3">
              <SendIcon class="w-4 h-4" />
              Send Message
            </button>
            <p v-if="sent" class="text-center text-sm text-status-success">Message sent! We'll be in touch soon.</p>
          </form>
        </div>

        <!-- Contact details -->
        <div class="space-y-4">
          <div v-for="item in contactItems" :key="item.label" class="koda-card flex items-center gap-4">
            <div class="w-10 h-10 rounded-lg bg-accent-subtle flex items-center justify-center shrink-0">
              <component :is="item.icon" class="w-5 h-5 text-accent" />
            </div>
            <div>
              <p class="text-xs text-text-muted">{{ item.label }}</p>
              <p class="text-sm font-medium text-text-primary">{{ item.value }}</p>
            </div>
          </div>
          <div class="koda-card">
            <p class="text-xs text-text-muted mb-2">Business Hours</p>
            <p class="text-sm text-text-secondary">Monday – Friday: 8am – 6pm EAT</p>
            <p class="text-sm text-text-secondary">Saturday: 9am – 1pm EAT</p>
          </div>
        </div>
      </div>
    </div>
  </AppLayout>
</template>

<script setup>
import { ref } from 'vue';
import { SendIcon, MailIcon, PhoneIcon, MapPinIcon } from 'lucide-vue-next';
import AppLayout from '@/Layouts/AppLayout.vue';

const submitting = ref(false);
const sent = ref(false);
const form = ref({ name: '', email: '', subject: '', message: '' });

function submit() {
  submitting.value = true;
  setTimeout(() => { submitting.value = false; sent.value = true; }, 1000);
}

const contactItems = [
  { icon: MailIcon,   label: 'Email',    value: 'support@koda.com' },
  { icon: PhoneIcon,  label: 'Phone',    value: '+254 700 000 000' },
  { icon: MapPinIcon, label: 'Location', value: 'Nairobi, Kenya' },
];
</script>

KODA_FILE_771F514A

# --- resources/js/Pages/Public/Home.vue ---
mkdir -p "resources/js/Pages/Public"
cat > "resources/js/Pages/Public/Home.vue" << 'KODA_FILE_3F2E7B7D'
<template>
  <AppLayout>
    <!-- Hero -->
    <section class="relative overflow-hidden bg-bg-primary">
      <div class="absolute inset-0 bg-hero-gradient pointer-events-none" />
      <div class="absolute inset-0 bg-noise opacity-40 pointer-events-none" />
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pt-24 pb-20 relative">
        <div class="text-center max-w-3xl mx-auto">
          <div class="inline-flex items-center gap-2 bg-accent-subtle border border-accent-muted px-4 py-1.5 rounded-full mb-6">
            <SparklesIcon class="w-3.5 h-3.5 text-accent" />
            <span class="text-xs font-medium text-accent">B2B Marketplace for Professionals</span>
          </div>
          <h1 class="font-heading text-5xl sm:text-6xl font-bold tracking-tight mb-6 leading-tight">
            Source. Sell. <span class="text-gradient">Succeed.</span>
          </h1>
          <p class="text-text-secondary text-lg leading-relaxed mb-10 max-w-2xl mx-auto">
            Koda connects verified vendors with serious buyers. Discover quality products, compare suppliers, and manage your business purchases — all in one place.
          </p>
          <div class="flex flex-col sm:flex-row items-center justify-center gap-4">
            <Link :href="route('products.index')" class="btn-primary px-8 py-3 text-base">
              <SearchIcon class="w-4 h-4" />
              Browse Products
            </Link>
            <Link :href="route('vendor.apply')" class="btn-secondary px-8 py-3 text-base">
              <StoreIcon class="w-4 h-4" />
              Become a Vendor
            </Link>
          </div>
        </div>

        <!-- Stats bar -->
        <div class="mt-20 grid grid-cols-2 sm:grid-cols-4 gap-px bg-border rounded-xl overflow-hidden">
          <div v-for="stat in stats" :key="stat.label" class="bg-bg-secondary px-6 py-5 text-center">
            <p class="font-heading text-2xl font-bold text-accent">{{ stat.value }}</p>
            <p class="text-text-muted text-sm mt-1">{{ stat.label }}</p>
          </div>
        </div>
      </div>
    </section>

    <!-- Categories -->
    <section class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
      <div class="flex items-center justify-between mb-8">
        <div>
          <h2 class="section-title">Shop by Category</h2>
          <p class="section-subtitle text-sm">Browse {{ categories.length }}+ product categories</p>
        </div>
        <Link :href="route('categories.index')" class="btn-ghost text-accent hover:text-accent-light gap-1">
          All categories <ArrowRightIcon class="w-4 h-4" />
        </Link>
      </div>
      <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-3">
        <Link
          v-for="cat in categories.slice(0, 12)"
          :key="cat.id"
          :href="route('categories.show', cat.slug)"
          class="koda-card flex flex-col items-center gap-3 py-5 hover:border-accent/40 hover:shadow-glow cursor-pointer group transition-all"
        >
          <div class="w-10 h-10 rounded-lg bg-accent-subtle flex items-center justify-center group-hover:bg-accent-muted transition-colors">
            <span class="text-xl">{{ cat.icon ?? '📦' }}</span>
          </div>
          <span class="text-xs font-medium text-text-secondary group-hover:text-text-primary text-center line-clamp-1 transition-colors">{{ cat.name }}</span>
        </Link>
      </div>
    </section>

    <!-- Featured Products -->
    <section class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
      <div class="flex items-center justify-between mb-8">
        <div>
          <h2 class="section-title">Featured Products</h2>
          <p class="section-subtitle text-sm">Handpicked quality selections</p>
        </div>
        <Link :href="route('products.index')" class="btn-ghost text-accent hover:text-accent-light gap-1">
          View all <ArrowRightIcon class="w-4 h-4" />
        </Link>
      </div>
      <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4">
        <ProductCard v-for="product in featuredProducts" :key="product.id" :product="product" />
      </div>
    </section>

    <!-- Featured Vendors -->
    <section class="bg-bg-secondary border-y border-border py-16">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex items-center justify-between mb-8">
          <div>
            <h2 class="section-title">Top Vendors</h2>
            <p class="section-subtitle text-sm">Verified businesses you can trust</p>
          </div>
          <Link :href="route('vendors.index')" class="btn-ghost text-accent hover:text-accent-light gap-1">
            All vendors <ArrowRightIcon class="w-4 h-4" />
          </Link>
        </div>
        <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
          <VendorCard v-for="vendor in topVendors" :key="vendor.id" :vendor="vendor" />
        </div>
      </div>
    </section>

    <!-- Trending Products -->
    <section class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
      <div class="flex items-center justify-between mb-8">
        <div>
          <h2 class="section-title">Trending Now</h2>
          <p class="section-subtitle text-sm">What buyers are purchasing most</p>
        </div>
        <Link :href="route('products.index', { sort: 'trending' })" class="btn-ghost text-accent hover:text-accent-light gap-1">
          See more <ArrowRightIcon class="w-4 h-4" />
        </Link>
      </div>
      <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4">
        <ProductCard v-for="product in trendingProducts" :key="product.id" :product="product" />
      </div>
    </section>

    <!-- CTA Banner -->
    <section class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pb-20">
      <div class="relative overflow-hidden bg-bg-secondary border border-border rounded-xl2 p-10 md:p-16">
        <div class="absolute inset-0 bg-gradient-radial from-accent/10 via-transparent to-transparent pointer-events-none" />
        <div class="relative text-center max-w-2xl mx-auto">
          <h2 class="font-heading text-3xl font-bold mb-4">Ready to grow your business?</h2>
          <p class="text-text-secondary mb-8">Join thousands of vendors already selling on Koda. Set up your storefront in minutes.</p>
          <div class="flex flex-col sm:flex-row items-center justify-center gap-4">
            <Link :href="route('vendor.apply')" class="btn-primary px-8 py-3 text-base">
              Start selling today
            </Link>
            <Link :href="route('about')" class="btn-ghost text-text-secondary">
              Learn more
            </Link>
          </div>
        </div>
      </div>
    </section>
  </AppLayout>
</template>

<script setup>
import { Link } from '@inertiajs/vue3';
import { SearchIcon, SparklesIcon, ArrowRightIcon, StoreIcon } from 'lucide-vue-next';
import AppLayout from '@/Layouts/AppLayout.vue';
import ProductCard from '@/Components/Shared/ProductCard.vue';
import VendorCard from '@/Components/Shared/VendorCard.vue';

defineProps({
  categories:       { type: Array, default: () => [] },
  featuredProducts: { type: Array, default: () => [] },
  trendingProducts: { type: Array, default: () => [] },
  topVendors:       { type: Array, default: () => [] },
});

const stats = [
  { value: '500+',  label: 'Verified Vendors'  },
  { value: '12K+',  label: 'Products Listed'   },
  { value: '8K+',   label: 'Business Buyers'   },
  { value: '98%',   label: 'Satisfaction Rate' },
];
</script>

KODA_FILE_3F2E7B7D

# --- resources/js/Pages/Public/OrderConfirmation.vue ---
mkdir -p "resources/js/Pages/Public"
cat > "resources/js/Pages/Public/OrderConfirmation.vue" << 'KODA_FILE_4F311D31'
<template>
  <AppLayout>
    <div class="max-w-2xl mx-auto px-4 sm:px-6 lg:px-8 py-16 text-center">
      <!-- Success animation -->
      <div class="w-20 h-20 rounded-full bg-green-950 border-2 border-status-success flex items-center justify-center mx-auto mb-6">
        <CheckIcon class="w-10 h-10 text-status-success" />
      </div>

      <h1 class="font-heading text-3xl font-bold mb-2">Order Confirmed!</h1>
      <p class="text-text-secondary mb-2">Thank you for your purchase, {{ order.shipping_name }}.</p>
      <p class="text-text-muted text-sm mb-8">
        A confirmation email has been sent to <span class="text-accent">{{ order.shipping_email }}</span>
      </p>

      <!-- Order card -->
      <div class="koda-card text-left mb-8">
        <div class="flex items-center justify-between mb-4 pb-4 border-b border-border">
          <div>
            <p class="text-xs text-text-muted">Order Number</p>
            <p class="font-mono font-bold text-text-primary text-lg">#{{ order.order_number }}</p>
          </div>
          <span class="badge badge-warning">{{ order.status }}</span>
        </div>

        <!-- Items -->
        <div class="space-y-3 mb-4">
          <div v-for="item in order.items" :key="item.id" class="flex items-center gap-3">
            <div class="w-10 h-10 rounded-lg bg-bg-tertiary border border-border overflow-hidden shrink-0">
              <img v-if="item.product?.thumbnail" :src="item.product.thumbnail" class="w-full h-full object-cover" />
            </div>
            <div class="flex-1 min-w-0">
              <p class="text-sm font-medium text-text-primary truncate">{{ item.product?.name }}</p>
              <p class="text-xs text-text-muted">Qty: {{ item.quantity }}</p>
            </div>
            <span class="text-sm font-semibold text-accent shrink-0">{{ formatPrice(item.subtotal) }}</span>
          </div>
        </div>

        <div class="border-t border-border pt-4 flex justify-between font-heading font-bold">
          <span>Total Paid</span>
          <span class="text-accent">{{ formatPrice(order.total) }}</span>
        </div>
      </div>

      <!-- Shipping info -->
      <div class="koda-card text-left mb-8">
        <h3 class="font-heading text-sm font-bold mb-3 flex items-center gap-2">
          <TruckIcon class="w-4 h-4 text-accent" /> Shipping To
        </h3>
        <p class="text-sm text-text-secondary">{{ order.shipping_name }}</p>
        <p class="text-sm text-text-muted">{{ order.shipping_address }}, {{ order.shipping_city }}</p>
      </div>

      <!-- CTA buttons -->
      <div class="flex flex-col sm:flex-row items-center justify-center gap-4">
        <Link :href="route('orders.show', order.id)" class="btn-primary px-8">
          <TruckIcon class="w-4 h-4" />
          Track Order
        </Link>
        <Link :href="route('products.index')" class="btn-secondary px-8">
          Continue Shopping
        </Link>
      </div>
    </div>
  </AppLayout>
</template>

<script setup>
import { Link } from '@inertiajs/vue3';
import { CheckIcon, TruckIcon } from 'lucide-vue-next';
import AppLayout from '@/Layouts/AppLayout.vue';

defineProps({ order: { type: Object, required: true } });

function formatPrice(p) {
  return new Intl.NumberFormat('en-KE', { style: 'currency', currency: 'KES' }).format(p);
}
</script>

KODA_FILE_4F311D31

# --- resources/js/Pages/Public/Privacy.vue ---
mkdir -p "resources/js/Pages/Public"
cat > "resources/js/Pages/Public/Privacy.vue" << 'KODA_FILE_119716E9'
<template>
  <AppLayout>
    <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
      <div class="mb-10">
        <p class="text-accent text-sm font-medium mb-2">Legal</p>
        <h1 class="font-heading text-4xl font-bold mb-3">Privacy Policy</h1>
        <p class="text-text-muted text-sm">Last updated: January 2025</p>
      </div>

      <div class="prose-koda space-y-8">
        <section v-for="section in sections" :key="section.title">
          <h2 class="font-heading text-xl font-bold text-text-primary mb-3">{{ section.title }}</h2>
          <p class="text-text-secondary leading-relaxed">{{ section.content }}</p>
        </section>
      </div>

      <div class="mt-12 p-6 koda-card bg-bg-tertiary">
        <p class="text-sm text-text-secondary">
          Questions about your privacy?
          <Link :href="route('contact')" class="text-accent hover:text-accent-light ml-1">Contact our team</Link>
        </p>
      </div>
    </div>
  </AppLayout>
</template>

<script setup>
import { Link } from '@inertiajs/vue3';
import AppLayout from '@/Layouts/AppLayout.vue';

const sections = [
  {
    title: '1. Information We Collect',
    content: 'We collect information you provide directly, such as your name, email address, and payment information when you register or make purchases. We also collect usage data about how you interact with our platform.',
  },
  {
    title: '2. How We Use Your Information',
    content: 'We use your information to process transactions, communicate with you about your orders, improve our services, and comply with legal obligations. We do not sell your personal information to third parties.',
  },
  {
    title: '3. Data Sharing',
    content: 'We share necessary order details with vendors to fulfil your purchases. We work with payment processors (Stripe, Flutterwave) who handle payment data under their own privacy policies. We may disclose information when required by law.',
  },
  {
    title: '4. Data Security',
    content: 'We implement industry-standard security measures including SSL encryption, secure data storage, and regular security audits. However, no transmission over the internet is 100% secure.',
  },
  {
    title: '5. Your Rights',
    content: 'You have the right to access, correct, or delete your personal data. You may also object to processing or request data portability. To exercise these rights, contact us at privacy@koda.com.',
  },
  {
    title: '6. Cookies',
    content: 'We use essential cookies for authentication and session management, and analytics cookies to understand how our platform is used. You can manage cookie preferences in your browser settings.',
  },
  {
    title: '7. Changes to This Policy',
    content: 'We may update this policy from time to time. We will notify you of significant changes by email or by posting a notice on our platform. Continued use after changes constitutes acceptance.',
  },
];
</script>

KODA_FILE_119716E9

# --- resources/js/Pages/Public/Products/Index.vue ---
mkdir -p "resources/js/Pages/Public/Products"
cat > "resources/js/Pages/Public/Products/Index.vue" << 'KODA_FILE_6AF9D48D'
<template>
  <AppLayout>
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
      <!-- Page header -->
      <div class="mb-8">
        <h1 class="font-heading text-3xl font-bold mb-1">All Products</h1>
        <p class="text-text-muted text-sm">{{ products.total }} products found</p>
      </div>

      <div class="flex gap-8">
        <!-- Sidebar filters -->
        <aside class="hidden lg:block w-56 shrink-0">
          <div class="koda-card sticky top-24 space-y-6">
            <div>
              <h4 class="font-heading text-sm font-semibold text-text-primary mb-3">Category</h4>
              <div class="space-y-2">
                <label
                  v-for="cat in categories"
                  :key="cat.id"
                  class="flex items-center gap-2.5 cursor-pointer group"
                >
                  <input
                    type="checkbox"
                    :value="cat.id"
                    v-model="filters.categories"
                    class="accent-accent w-4 h-4 rounded"
                  />
                  <span class="text-sm text-text-secondary group-hover:text-text-primary transition-colors">{{ cat.name }}</span>
                  <span class="ml-auto text-xs text-text-muted">({{ cat.products_count }})</span>
                </label>
              </div>
            </div>

            <div class="koda-divider" />

            <div>
              <h4 class="font-heading text-sm font-semibold text-text-primary mb-3">Price Range</h4>
              <div class="flex items-center gap-2">
                <input v-model="filters.minPrice" type="number" placeholder="Min" class="koda-input text-xs py-2 px-2.5" />
                <span class="text-text-muted text-sm">—</span>
                <input v-model="filters.maxPrice" type="number" placeholder="Max" class="koda-input text-xs py-2 px-2.5" />
              </div>
            </div>

            <div class="koda-divider" />

            <div>
              <h4 class="font-heading text-sm font-semibold text-text-primary mb-3">Rating</h4>
              <div class="space-y-2">
                <label v-for="r in [4,3,2,1]" :key="r" class="flex items-center gap-2.5 cursor-pointer">
                  <input type="radio" :value="r" v-model="filters.minRating" class="accent-accent" />
                  <StarRating :model-value="r" />
                  <span class="text-xs text-text-muted">& up</span>
                </label>
              </div>
            </div>

            <div class="koda-divider" />

            <button @click="clearFilters" class="btn-ghost w-full text-sm text-text-muted justify-center">
              <XIcon class="w-4 h-4" />
              Clear filters
            </button>
          </div>
        </aside>

        <!-- Product grid -->
        <div class="flex-1 min-w-0">
          <!-- Toolbar -->
          <div class="flex items-center justify-between gap-4 mb-6">
            <div class="relative flex-1 max-w-sm">
              <SearchIcon class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-text-muted pointer-events-none" />
              <input
                v-model="filters.q"
                type="text"
                placeholder="Search products..."
                class="koda-input pl-9 text-sm"
              />
            </div>
            <div class="flex items-center gap-2 shrink-0">
              <select v-model="filters.sort" class="koda-select text-sm w-44">
                <option value="">Relevance</option>
                <option value="price_asc">Price: Low to High</option>
                <option value="price_desc">Price: High to Low</option>
                <option value="rating">Top Rated</option>
                <option value="newest">Newest</option>
              </select>
              <div class="flex rounded-btn overflow-hidden border border-border">
                <button @click="viewMode = 'grid'" :class="['px-3 py-2 transition-colors', viewMode === 'grid' ? 'bg-accent text-white' : 'bg-bg-tertiary text-text-muted hover:text-text-primary']">
                  <GridIcon class="w-4 h-4" />
                </button>
                <button @click="viewMode = 'list'" :class="['px-3 py-2 transition-colors', viewMode === 'list' ? 'bg-accent text-white' : 'bg-bg-tertiary text-text-muted hover:text-text-primary']">
                  <ListIcon class="w-4 h-4" />
                </button>
              </div>
            </div>
          </div>

          <!-- Grid -->
          <div
            v-if="products.data?.length"
            :class="[
              'grid gap-4',
              viewMode === 'grid'
                ? 'grid-cols-2 sm:grid-cols-3 md:grid-cols-4'
                : 'grid-cols-1',
            ]"
          >
            <ProductCard
              v-for="product in products.data"
              :key="product.id"
              :product="product"
              :list-mode="viewMode === 'list'"
            />
          </div>
          <div v-else class="text-center py-20 text-text-muted">
            <PackageIcon class="w-12 h-12 mx-auto mb-3 text-border" />
            <p class="font-heading text-lg">No products found</p>
            <p class="text-sm mt-1">Try adjusting your filters</p>
          </div>

          <Pagination :links="products.links" />
        </div>
      </div>
    </div>
  </AppLayout>
</template>

<script setup>
import { ref, watch } from 'vue';
import { Link, router } from '@inertiajs/vue3';
import { SearchIcon, XIcon, GridIcon, ListIcon, PackageIcon } from 'lucide-vue-next';
import AppLayout from '@/Layouts/AppLayout.vue';
import ProductCard from '@/Components/Shared/ProductCard.vue';
import StarRating from '@/Components/UI/StarRating.vue';
import Pagination from '@/Components/UI/Pagination.vue';
import { useDebounceFn } from '@vueuse/core';

const props = defineProps({
  products:   { type: Object, required: true },
  categories: { type: Array, default: () => [] },
  filters:    { type: Object, default: () => ({}) },
});

const viewMode = ref('grid');

const filters = ref({
  q:          props.filters.q ?? '',
  sort:       props.filters.sort ?? '',
  categories: props.filters.categories ?? [],
  minPrice:   props.filters.minPrice ?? '',
  maxPrice:   props.filters.maxPrice ?? '',
  minRating:  props.filters.minRating ?? null,
});

const applyFilters = useDebounceFn(() => {
  router.get(route('products.index'), { ...filters.value }, { preserveState: true, replace: true });
}, 400);

watch(filters, applyFilters, { deep: true });

function clearFilters() {
  filters.value = { q: '', sort: '', categories: [], minPrice: '', maxPrice: '', minRating: null };
}
</script>

KODA_FILE_6AF9D48D

# --- resources/js/Pages/Public/Products/Show.vue ---
mkdir -p "resources/js/Pages/Public/Products"
cat > "resources/js/Pages/Public/Products/Show.vue" << 'KODA_FILE_21FA0464'
<template>
  <AppLayout>
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
      <!-- Breadcrumb -->
      <Breadcrumb :items="[
        { label: 'Products', href: route('products.index') },
        { label: product.category?.name, href: route('categories.show', product.category?.slug) },
        { label: product.name },
      ]" class="mb-6" />

      <div class="grid grid-cols-1 lg:grid-cols-2 gap-12">
        <!-- Images -->
        <div class="space-y-3">
          <div class="aspect-square rounded-xl overflow-hidden bg-bg-tertiary border border-border">
            <img
              :src="activeImage"
              :alt="product.name"
              class="w-full h-full object-cover"
            />
          </div>
          <div class="flex gap-2 flex-wrap">
            <button
              v-for="img in allImages"
              :key="img"
              @click="activeImage = img"
              :class="['w-16 h-16 rounded-lg overflow-hidden border-2 transition-all', activeImage === img ? 'border-accent' : 'border-border hover:border-border-light']"
            >
              <img :src="img" :alt="product.name" class="w-full h-full object-cover" />
            </button>
          </div>
        </div>

        <!-- Info -->
        <div class="space-y-6">
          <!-- Vendor -->
          <Link :href="route('vendors.show', product.vendor?.slug)" class="inline-flex items-center gap-2 group">
            <img v-if="product.vendor?.logo" :src="product.vendor.logo" class="w-6 h-6 rounded-full object-cover" />
            <span class="text-sm text-text-secondary group-hover:text-accent transition-colors">{{ product.vendor?.store_name }}</span>
            <CheckCircleIcon v-if="product.vendor?.is_verified" class="w-4 h-4 text-accent" />
          </Link>

          <div>
            <h1 class="font-heading text-3xl font-bold leading-tight">{{ product.name }}</h1>
            <div class="flex items-center gap-4 mt-3">
              <StarRating :model-value="product.avg_rating" :show-count="true" :count="product.reviews_count" />
              <span class="text-sm text-text-muted">SKU: {{ product.sku }}</span>
            </div>
          </div>

          <!-- Price -->
          <div class="flex items-baseline gap-3">
            <span class="font-heading text-4xl font-bold text-accent">{{ formatPrice(product.price) }}</span>
          </div>

          <!-- Stock -->
          <div class="flex items-center gap-2">
            <div :class="['w-2 h-2 rounded-full', product.stock > 0 ? 'bg-status-success' : 'bg-status-error']" />
            <span :class="['text-sm font-medium', product.stock > 0 ? 'text-status-success' : 'text-status-error']">
              {{ product.stock > 0 ? `${product.stock} in stock` : 'Out of stock' }}
            </span>
          </div>

          <!-- Description -->
          <p class="text-text-secondary leading-relaxed text-sm">{{ product.short_description }}</p>

          <!-- Quantity + Add to cart -->
          <div class="flex items-center gap-3 pt-2">
            <div class="flex items-center gap-1 bg-bg-tertiary border border-border rounded-btn">
              <button @click="qty > 1 && qty--" class="px-3 py-2.5 text-text-secondary hover:text-text-primary transition-colors">
                <MinusIcon class="w-4 h-4" />
              </button>
              <span class="w-10 text-center text-sm font-medium">{{ qty }}</span>
              <button @click="qty < product.stock && qty++" class="px-3 py-2.5 text-text-secondary hover:text-text-primary transition-colors">
                <PlusIcon class="w-4 h-4" />
              </button>
            </div>
            <button @click="addToCart" :disabled="product.stock === 0" class="btn-primary flex-1 py-3">
              <ShoppingCartIcon class="w-4 h-4" />
              Add to Cart
            </button>
            <button @click="toggleWishlist" :class="['btn-secondary w-12 h-12 p-0 shrink-0', inWishlist ? 'text-red-400 border-red-900' : '']">
              <HeartIcon :class="['w-4 h-4', inWishlist ? 'fill-current' : '']" />
            </button>
          </div>

          <!-- Meta -->
          <div class="border-t border-border pt-5 space-y-2.5">
            <div class="flex items-center gap-3 text-sm">
              <ShieldCheckIcon class="w-4 h-4 text-accent shrink-0" />
              <span class="text-text-secondary">Secure payment with Stripe or Flutterwave</span>
            </div>
            <div class="flex items-center gap-3 text-sm">
              <TruckIcon class="w-4 h-4 text-accent shrink-0" />
              <span class="text-text-secondary">Fast delivery available</span>
            </div>
            <div class="flex items-center gap-3 text-sm">
              <RefreshCwIcon class="w-4 h-4 text-accent shrink-0" />
              <span class="text-text-secondary">Easy returns within 7 days</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Description tabs -->
      <div class="mt-16 grid grid-cols-1 lg:grid-cols-3 gap-8">
        <div class="lg:col-span-2">
          <div class="flex border-b border-border mb-6">
            <button
              v-for="tab in tabs"
              :key="tab"
              @click="activeTab = tab"
              :class="[
                'px-5 py-3 text-sm font-medium transition-colors border-b-2 -mb-px',
                activeTab === tab
                  ? 'border-accent text-accent'
                  : 'border-transparent text-text-muted hover:text-text-secondary',
              ]"
            >{{ tab }}</button>
          </div>

          <div v-if="activeTab === 'Description'" class="prose prose-invert prose-sm max-w-none text-text-secondary leading-relaxed">
            <div v-html="product.description" />
          </div>

          <div v-if="activeTab === 'Reviews'">
            <div v-if="product.reviews?.length" class="space-y-4">
              <div v-for="review in product.reviews" :key="review.id" class="koda-card">
                <div class="flex items-start justify-between mb-2">
                  <div>
                    <p class="text-sm font-semibold text-text-primary">{{ review.user?.name }}</p>
                    <StarRating :model-value="review.rating" class="mt-0.5" />
                  </div>
                  <span class="text-xs text-text-muted">{{ review.created_at_human }}</span>
                </div>
                <p class="text-sm text-text-secondary mt-2">{{ review.comment }}</p>
              </div>
            </div>
            <div v-else class="text-center py-10 text-text-muted">
              <StarIcon class="w-8 h-8 mx-auto mb-2 text-border" />
              <p class="text-sm">No reviews yet</p>
            </div>
          </div>
        </div>

        <!-- Vendor sidebar -->
        <div>
          <div class="koda-card">
            <h3 class="font-heading text-sm font-semibold mb-4">Sold by</h3>
            <Link :href="route('vendors.show', product.vendor?.slug)" class="flex items-center gap-3 group mb-4">
              <div class="w-10 h-10 rounded-lg overflow-hidden bg-bg-tertiary border border-border shrink-0">
                <img v-if="product.vendor?.logo" :src="product.vendor.logo" class="w-full h-full object-cover" />
              </div>
              <div>
                <p class="text-sm font-semibold text-text-primary group-hover:text-accent transition-colors">{{ product.vendor?.store_name }}</p>
                <StarRating :model-value="product.vendor?.avg_rating" />
              </div>
            </Link>
            <div class="space-y-2 text-xs text-text-muted mb-4">
              <p>{{ product.vendor?.products_count }} products</p>
              <p>Member since {{ product.vendor?.member_since }}</p>
            </div>
            <Link :href="route('vendors.show', product.vendor?.slug)" class="btn-secondary w-full text-sm">
              View Store
            </Link>
          </div>
        </div>
      </div>

      <!-- Related products -->
      <div v-if="relatedProducts?.length" class="mt-20">
        <h2 class="section-title mb-6">Related Products</h2>
        <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4">
          <ProductCard v-for="p in relatedProducts" :key="p.id" :product="p" />
        </div>
      </div>
    </div>
  </AppLayout>
</template>

<script setup>
import { ref, computed } from 'vue';
import { Link, router } from '@inertiajs/vue3';
import {
  CheckCircleIcon, ShoppingCartIcon, HeartIcon, MinusIcon, PlusIcon,
  ShieldCheckIcon, TruckIcon, RefreshCwIcon, StarIcon,
} from 'lucide-vue-next';
import AppLayout from '@/Layouts/AppLayout.vue';
import Breadcrumb from '@/Components/UI/Breadcrumb.vue';
import StarRating from '@/Components/UI/StarRating.vue';
import ProductCard from '@/Components/Shared/ProductCard.vue';

const props = defineProps({
  product:         { type: Object, required: true },
  relatedProducts: { type: Array, default: () => [] },
});

const qty = ref(1);
const activeTab = ref('Description');
const inWishlist = ref(props.product.in_wishlist ?? false);
const tabs = ['Description', 'Reviews'];

const allImages = computed(() => {
  const imgs = [props.product.thumbnail];
  if (props.product.images?.length) imgs.push(...props.product.images.map(i => i.url));
  return imgs.filter(Boolean);
});
const activeImage = ref(allImages.value[0]);

function formatPrice(p) {
  return new Intl.NumberFormat('en-KE', { style: 'currency', currency: 'KES' }).format(p);
}
function addToCart() {
  router.post(route('cart.add'), { product_id: props.product.id, quantity: qty.value }, { preserveScroll: true });
}
function toggleWishlist() {
  inWishlist.value = !inWishlist.value;
  router.post(route('wishlist.toggle'), { product_id: props.product.id }, { preserveScroll: true });
}
</script>

KODA_FILE_21FA0464

# --- resources/js/Pages/Public/Terms.vue ---
mkdir -p "resources/js/Pages/Public"
cat > "resources/js/Pages/Public/Terms.vue" << 'KODA_FILE_65F7F7F7'
<template>
  <AppLayout>
    <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
      <div class="mb-10">
        <p class="text-accent text-sm font-medium mb-2">Legal</p>
        <h1 class="font-heading text-4xl font-bold mb-3">Terms of Service</h1>
        <p class="text-text-muted text-sm">Last updated: January 2025</p>
      </div>

      <div class="space-y-8">
        <section v-for="section in sections" :key="section.title">
          <h2 class="font-heading text-xl font-bold text-text-primary mb-3">{{ section.title }}</h2>
          <p class="text-text-secondary leading-relaxed">{{ section.content }}</p>
          <ul v-if="section.items" class="mt-3 space-y-1.5">
            <li v-for="item in section.items" :key="item" class="flex items-start gap-2 text-text-secondary text-sm">
              <span class="w-1.5 h-1.5 rounded-full bg-accent mt-2 shrink-0" />
              {{ item }}
            </li>
          </ul>
        </section>
      </div>

      <div class="mt-12 p-6 koda-card bg-bg-tertiary">
        <p class="text-sm text-text-secondary">
          Questions about our terms?
          <Link :href="route('contact')" class="text-accent hover:text-accent-light ml-1">Contact us</Link>
        </p>
      </div>
    </div>
  </AppLayout>
</template>

<script setup>
import { Link } from '@inertiajs/vue3';
import AppLayout from '@/Layouts/AppLayout.vue';

const sections = [
  {
    title: '1. Acceptance of Terms',
    content: 'By accessing or using Koda, you agree to be bound by these Terms. If you do not agree, please do not use our platform.',
  },
  {
    title: '2. Accounts',
    content: 'You must provide accurate information when creating an account. You are responsible for maintaining the security of your credentials and all activity under your account.',
  },
  {
    title: '3. Vendor Obligations',
    content: 'Vendors agree to the following when listing on Koda:',
    items: [
      'Provide accurate product descriptions and pricing',
      'Fulfil orders in a timely manner',
      'Maintain sufficient stock for listed products',
      'Comply with all applicable laws and regulations',
      'Not engage in deceptive or fraudulent practices',
    ],
  },
  {
    title: '4. Buyer Obligations',
    content: 'Buyers agree to use the platform in good faith, provide accurate shipping information, and make payment for orders placed. Fraudulent orders or chargebacks without valid reason may result in account suspension.',
  },
  {
    title: '5. Commission & Fees',
    content: 'Koda charges a platform commission on each completed sale. The current commission rate is displayed in vendor settings and may be updated with 30 days notice. Vendors receive net earnings after commission deduction.',
  },
  {
    title: '6. Prohibited Content',
    content: 'The following are not permitted on Koda:',
    items: [
      'Counterfeit or stolen goods',
      'Hazardous or illegal items',
      'Products that infringe intellectual property rights',
      'Misleading product listings',
    ],
  },
  {
    title: '7. Dispute Resolution',
    content: 'Disputes between buyers and vendors should first be resolved directly. Koda offers mediation support for unresolved disputes. Our decisions in mediated disputes are final.',
  },
  {
    title: '8. Limitation of Liability',
    content: 'Koda acts as a marketplace platform and is not party to transactions between buyers and vendors. We are not liable for the quality of goods, delivery failures, or vendor conduct beyond our stated mediation support.',
  },
  {
    title: '9. Termination',
    content: 'We reserve the right to suspend or terminate accounts that violate these terms, engage in fraudulent activity, or damage the platform or its users.',
  },
];
</script>

KODA_FILE_65F7F7F7

# --- resources/js/Pages/Public/Vendors/Apply.vue ---
mkdir -p "resources/js/Pages/Public/Vendors"
cat > "resources/js/Pages/Public/Vendors/Apply.vue" << 'KODA_FILE_6B625E68'
<template>
  <AppLayout>
    <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
      <!-- Hero -->
      <div class="text-center mb-12">
        <div class="inline-flex items-center gap-2 bg-accent-subtle border border-accent-muted px-4 py-1.5 rounded-full mb-6">
          <StoreIcon class="w-3.5 h-3.5 text-accent" />
          <span class="text-xs font-medium text-accent">Vendor Application</span>
        </div>
        <h1 class="font-heading text-4xl font-bold mb-4">Start Selling on Koda</h1>
        <p class="text-text-secondary text-lg leading-relaxed">
          Join our network of verified vendors and reach thousands of business buyers across Africa.
        </p>
      </div>

      <!-- Benefits -->
      <div class="grid grid-cols-1 sm:grid-cols-3 gap-4 mb-12">
        <div v-for="benefit in benefits" :key="benefit.title" class="koda-card text-center">
          <div class="w-10 h-10 rounded-lg bg-accent-subtle flex items-center justify-center mx-auto mb-3">
            <component :is="benefit.icon" class="w-5 h-5 text-accent" />
          </div>
          <p class="font-heading text-sm font-bold text-text-primary mb-1">{{ benefit.title }}</p>
          <p class="text-xs text-text-muted">{{ benefit.desc }}</p>
        </div>
      </div>

      <!-- Form -->
      <div class="koda-card">
        <h2 class="font-heading text-xl font-bold mb-6">Your Application</h2>

        <form @submit.prevent="submit" class="space-y-5">
          <div class="grid grid-cols-2 gap-4">
            <div>
              <label class="koda-label">Business / Store Name <span class="text-status-error">*</span></label>
              <input v-model="form.store_name" type="text" class="koda-input" :class="{ error: form.errors.store_name }" placeholder="Acme Supplies Ltd" />
              <p v-if="form.errors.store_name" class="koda-error">{{ form.errors.store_name }}</p>
            </div>
            <div>
              <label class="koda-label">Phone Number <span class="text-status-error">*</span></label>
              <input v-model="form.phone" type="tel" class="koda-input" placeholder="+254 7XX XXX XXX" />
            </div>
          </div>

          <div>
            <label class="koda-label">Business Description <span class="text-status-error">*</span></label>
            <textarea v-model="form.description" rows="4" class="koda-textarea" :class="{ error: form.errors.description }" placeholder="Tell us about your business, what you sell, and your target market..." />
            <p class="text-xs text-text-muted mt-1">{{ form.description.length }}/500 characters (minimum 20)</p>
            <p v-if="form.errors.description" class="koda-error">{{ form.errors.description }}</p>
          </div>

          <div class="grid grid-cols-2 gap-4">
            <div>
              <label class="koda-label">City <span class="text-status-error">*</span></label>
              <input v-model="form.city" type="text" class="koda-input" placeholder="Nairobi" />
            </div>
            <div>
              <label class="koda-label">Country</label>
              <select v-model="form.country" class="koda-select">
                <option value="KE">Kenya</option>
                <option value="UG">Uganda</option>
                <option value="TZ">Tanzania</option>
                <option value="RW">Rwanda</option>
              </select>
            </div>
          </div>

          <div>
            <label class="koda-label">Business Address <span class="text-status-error">*</span></label>
            <input v-model="form.address" type="text" class="koda-input" placeholder="123 Business Park, Industrial Area" />
          </div>

          <div v-if="!$page.props.auth.user" class="p-4 bg-bg-tertiary border border-border rounded-btn">
            <p class="text-sm text-text-secondary">
              <InfoIcon class="w-4 h-4 inline text-accent mr-1.5" />
              You'll need to create an account to complete your application.
              <Link :href="route('register')" class="text-accent hover:text-accent-light ml-1">Sign up here</Link>
            </p>
          </div>

          <div class="pt-2">
            <button type="submit" :disabled="form.processing" class="btn-primary w-full py-3 text-base">
              <LoaderIcon v-if="form.processing" class="w-4 h-4 animate-spin" />
              <StoreIcon v-else class="w-4 h-4" />
              Submit Application
            </button>
            <p class="text-center text-xs text-text-muted mt-3">
              We review all applications within 24–48 hours. You'll be notified by email.
            </p>
          </div>
        </form>
      </div>
    </div>
  </AppLayout>
</template>

<script setup>
import { useForm, Link } from '@inertiajs/vue3';
import { StoreIcon, LoaderIcon, InfoIcon, TrendingUpIcon, ShieldCheckIcon, UsersIcon } from 'lucide-vue-next';
import AppLayout from '@/Layouts/AppLayout.vue';

const form = useForm({
  store_name:  '',
  description: '',
  phone:       '',
  address:     '',
  city:        '',
  country:     'KE',
});

function submit() {
  form.post(route('vendor.apply.store'));
}

const benefits = [
  { icon: UsersIcon,       title: 'Reach Buyers',    desc: 'Access 8,000+ verified business buyers across Africa' },
  { icon: ShieldCheckIcon, title: 'Verified Badge',  desc: 'Build trust with our vendor verification programme' },
  { icon: TrendingUpIcon,  title: 'Grow Sales',      desc: 'Powerful analytics and tools to scale your business' },
];
</script>

KODA_FILE_6B625E68

# --- resources/js/Pages/Public/Vendors/Index.vue ---
mkdir -p "resources/js/Pages/Public/Vendors"
cat > "resources/js/Pages/Public/Vendors/Index.vue" << 'KODA_FILE_12F47D17'
<template>
  <AppLayout>
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
      <div class="flex items-center justify-between mb-8">
        <div>
          <h1 class="font-heading text-3xl font-bold">Our Vendors</h1>
          <p class="text-text-muted text-sm mt-1">{{ vendors.total }} verified businesses</p>
        </div>
        <Link :href="route('vendor.apply')" class="btn-primary hidden sm:flex">
          <StoreIcon class="w-4 h-4" />
          Become a Vendor
        </Link>
      </div>

      <!-- Search -->
      <div class="relative max-w-sm mb-8">
        <SearchIcon class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-text-muted" />
        <input v-model="search" @input="doSearch" type="text" placeholder="Search vendors..." class="koda-input pl-9" />
      </div>

      <!-- Grid -->
      <div v-if="vendors.data.length" class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
        <VendorCard v-for="vendor in vendors.data" :key="vendor.id" :vendor="vendor" />
      </div>

      <div v-else class="text-center py-20 text-text-muted">
        <StoreIcon class="w-14 h-14 mx-auto mb-4 text-border" />
        <p class="font-heading text-xl">No vendors found</p>
      </div>

      <Pagination :links="vendors.links" />
    </div>
  </AppLayout>
</template>

<script setup>
import { ref } from 'vue';
import { Link, router } from '@inertiajs/vue3';
import { SearchIcon, StoreIcon } from 'lucide-vue-next';
import { useDebounceFn } from '@vueuse/core';
import AppLayout from '@/Layouts/AppLayout.vue';
import VendorCard from '@/Components/Shared/VendorCard.vue';
import Pagination from '@/Components/UI/Pagination.vue';

const props = defineProps({
  vendors: { type: Object, required: true },
  filters: { type: Object, default: () => ({}) },
});

const search = ref(props.filters.q ?? '');

const doSearch = useDebounceFn(() => {
  router.get(route('vendors.index'), { q: search.value }, { preserveState: true, replace: true });
}, 400);
</script>

KODA_FILE_12F47D17

# --- resources/js/Pages/Public/Vendors/Show.vue ---
mkdir -p "resources/js/Pages/Public/Vendors"
cat > "resources/js/Pages/Public/Vendors/Show.vue" << 'KODA_FILE_D8A794C3'
<template>
  <AppLayout>
    <!-- Banner -->
    <div class="relative h-48 sm:h-64 bg-bg-tertiary overflow-hidden">
      <img v-if="vendor.banner" :src="vendor.banner" :alt="vendor.store_name" class="w-full h-full object-cover" />
      <div v-else class="w-full h-full bg-gradient-to-br from-accent-subtle to-bg-tertiary" />
      <div class="absolute inset-0 bg-gradient-to-t from-bg-primary/80 to-transparent" />
    </div>

    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <!-- Vendor info card -->
      <div class="relative -mt-16 mb-10">
        <div class="koda-card flex flex-col sm:flex-row items-start sm:items-center gap-5">
          <!-- Logo -->
          <div class="w-20 h-20 rounded-xl overflow-hidden bg-bg-tertiary border-2 border-bg-secondary shrink-0">
            <img v-if="vendor.logo" :src="vendor.logo" :alt="vendor.store_name" class="w-full h-full object-cover" />
            <div v-else class="w-full h-full bg-accent-subtle flex items-center justify-center">
              <span class="text-accent text-2xl font-bold">{{ vendor.store_name?.[0] }}</span>
            </div>
          </div>

          <div class="flex-1">
            <div class="flex flex-wrap items-start gap-3 justify-between">
              <div>
                <div class="flex items-center gap-2">
                  <h1 class="font-heading text-2xl font-bold">{{ vendor.store_name }}</h1>
                  <CheckCircleIcon v-if="vendor.is_verified" class="w-5 h-5 text-accent" title="Verified Vendor" />
                </div>
                <p class="text-text-muted text-sm mt-1">{{ vendor.description }}</p>
              </div>
              <div class="flex items-center gap-3 shrink-0 flex-wrap">
                <div class="text-center">
                  <p class="font-heading text-lg font-bold text-text-primary">{{ vendor.products?.length }}</p>
                  <p class="text-xs text-text-muted">Products</p>
                </div>
                <div class="text-center">
                  <StarRating :model-value="vendor.avg_rating" />
                  <p class="text-xs text-text-muted mt-0.5">{{ vendor.avg_rating }} rating</p>
                </div>
                <div class="text-center">
                  <p class="font-heading text-lg font-bold text-text-primary">{{ vendor.member_since }}</p>
                  <p class="text-xs text-text-muted">Member since</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Products -->
      <div class="mb-12">
        <div class="flex items-center justify-between mb-6">
          <h2 class="section-title">Products</h2>
          <div class="flex items-center gap-2">
            <select v-model="sort" class="koda-select text-sm w-40">
              <option value="">Latest</option>
              <option value="price_asc">Price ↑</option>
              <option value="price_desc">Price ↓</option>
            </select>
          </div>
        </div>

        <div v-if="sortedProducts.length" class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4">
          <ProductCard v-for="product in sortedProducts" :key="product.id" :product="product" />
        </div>

        <div v-else class="text-center py-16 text-text-muted">
          <PackageIcon class="w-12 h-12 mx-auto mb-3 text-border" />
          <p>No products listed yet</p>
        </div>
      </div>
    </div>
  </AppLayout>
</template>

<script setup>
import { ref, computed } from 'vue';
import { CheckCircleIcon, PackageIcon } from 'lucide-vue-next';
import AppLayout from '@/Layouts/AppLayout.vue';
import ProductCard from '@/Components/Shared/ProductCard.vue';
import StarRating from '@/Components/UI/StarRating.vue';

const props = defineProps({
  vendor:   { type: Object, required: true },
  products: { type: Array,  default: () => [] },
});

const sort = ref('');

const sortedProducts = computed(() => {
  const list = [...(props.vendor.products ?? props.products)];
  if (sort.value === 'price_asc')  return list.sort((a, b) => a.price - b.price);
  if (sort.value === 'price_desc') return list.sort((a, b) => b.price - a.price);
  return list;
});
</script>

KODA_FILE_D8A794C3

# --- resources/js/Pages/Vendor/Dashboard.vue ---
mkdir -p "resources/js/Pages/Vendor"
cat > "resources/js/Pages/Vendor/Dashboard.vue" << 'KODA_FILE_9CF1AF6F'
<template>
  <DashboardLayout
    :nav-items="vendorNav"
    page-title="Vendor Dashboard"
    :breadcrumbs="[{ label: 'Vendor' }, { label: 'Dashboard' }]"
  >
    <!-- Welcome banner -->
    <div class="relative overflow-hidden bg-bg-secondary border border-border rounded-card p-6 mb-8">
      <div class="absolute right-0 top-0 bottom-0 w-64 bg-gradient-radial from-accent/5 to-transparent pointer-events-none" />
      <div class="flex items-center justify-between gap-6">
        <div>
          <h2 class="font-heading text-xl font-bold text-text-primary">
            Welcome back, {{ $page.props.auth.user?.name?.split(' ')[0] }} 👋
          </h2>
          <p class="text-text-muted text-sm mt-1">Here's what's happening with your store today.</p>
        </div>
        <div class="flex items-center gap-3 shrink-0">
          <span :class="['badge', vendorProfile?.status === 'active' ? 'badge-success' : 'badge-warning']">
            {{ vendorProfile?.status ?? 'pending' }}
          </span>
          <Link :href="route('vendor.products.create')" class="btn-primary">
            <PlusIcon class="w-4 h-4" />
            Add Product
          </Link>
        </div>
      </div>
    </div>

    <!-- Stats -->
    <div class="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
      <StatsCard label="Total Revenue"   :value="formatPrice(stats.revenue)"  :change="stats.revenueChange"  :icon="DollarSignIcon" />
      <StatsCard label="Orders"          :value="stats.orders"                :change="stats.ordersChange"   :icon="ShoppingBagIcon" icon-bg="bg-blue-950" icon-color="text-blue-400" />
      <StatsCard label="Products"        :value="stats.products"              :icon="PackageIcon"             icon-bg="bg-purple-950" icon-color="text-purple-400" />
      <StatsCard label="Payout Balance"  :value="formatPrice(stats.balance)"  :icon="BanknoteIcon"            icon-bg="bg-green-950" icon-color="text-green-400" />
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-6">
      <!-- Chart -->
      <div class="lg:col-span-2 koda-card">
        <div class="flex items-center justify-between mb-6">
          <h3 class="font-heading text-base font-bold">Sales Overview</h3>
          <div class="flex gap-2">
            <button
              v-for="p in ['7D', '30D', '90D']"
              :key="p"
              @click="chartPeriod = p"
              :class="['px-3 py-1 rounded-btn text-xs font-medium transition-colors', chartPeriod === p ? 'bg-accent text-white' : 'bg-bg-tertiary text-text-muted hover:text-text-primary']"
            >{{ p }}</button>
          </div>
        </div>
        <div class="h-48">
          <Bar :data="barChartData" :options="chartOptions" />
        </div>
      </div>

      <!-- Quick actions -->
      <div class="koda-card space-y-3">
        <h3 class="font-heading text-base font-bold mb-2">Quick Actions</h3>
        <Link :href="route('vendor.products.create')" class="btn-secondary w-full justify-start gap-3 text-sm">
          <PlusIcon class="w-4 h-4 text-accent" />
          Add New Product
        </Link>
        <Link :href="route('vendor.orders.index', { status: 'pending' })" class="btn-secondary w-full justify-start gap-3 text-sm">
          <ClockIcon class="w-4 h-4 text-yellow-400" />
          Pending Orders
          <span v-if="pendingOrdersCount > 0" class="ml-auto badge badge-warning text-xs">{{ pendingOrdersCount }}</span>
        </Link>
        <Link :href="route('vendor.profile.edit')" class="btn-secondary w-full justify-start gap-3 text-sm">
          <StoreIcon class="w-4 h-4 text-blue-400" />
          Edit Storefront
        </Link>
        <Link :href="route('vendor.payouts.index')" class="btn-secondary w-full justify-start gap-3 text-sm">
          <BanknoteIcon class="w-4 h-4 text-green-400" />
          Request Payout
        </Link>
      </div>
    </div>

    <!-- Recent orders + Top products -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
      <div class="koda-card">
        <div class="flex items-center justify-between mb-4">
          <h3 class="font-heading text-base font-bold">Recent Orders</h3>
          <Link :href="route('vendor.orders.index')" class="text-accent text-xs hover:text-accent-light transition-colors">View all</Link>
        </div>
        <table class="koda-table">
          <thead><tr><th>Order</th><th>Items</th><th>Total</th><th>Status</th></tr></thead>
          <tbody>
            <tr v-for="order in recentOrders" :key="order.id">
              <td class="font-mono text-xs text-text-muted">#{{ order.order_number }}</td>
              <td class="text-xs">{{ order.items_count }}</td>
              <td class="text-accent text-xs font-semibold">{{ formatPrice(order.vendor_total) }}</td>
              <td><span :class="statusClass(order.status)" class="text-xs">{{ order.status }}</span></td>
            </tr>
          </tbody>
        </table>
      </div>

      <div class="koda-card">
        <div class="flex items-center justify-between mb-4">
          <h3 class="font-heading text-base font-bold">Top Products</h3>
          <Link :href="route('vendor.products.index')" class="text-accent text-xs hover:text-accent-light transition-colors">Manage</Link>
        </div>
        <div class="space-y-3">
          <div v-for="(product, i) in topProducts" :key="product.id" class="flex items-center gap-3">
            <span class="text-xs text-text-muted w-4 font-mono">{{ i + 1 }}</span>
            <div class="w-9 h-9 rounded-lg overflow-hidden bg-bg-tertiary border border-border shrink-0">
              <img v-if="product.thumbnail" :src="product.thumbnail" class="w-full h-full object-cover" />
            </div>
            <div class="flex-1 min-w-0">
              <p class="text-xs font-medium text-text-primary truncate">{{ product.name }}</p>
              <p class="text-xs text-text-muted">{{ product.orders_count }} sold</p>
            </div>
            <span class="text-xs font-semibold text-accent shrink-0">{{ formatPrice(product.revenue) }}</span>
          </div>
        </div>
      </div>
    </div>
  </DashboardLayout>
</template>

<script setup>
import { ref, computed } from 'vue';
import { Link } from '@inertiajs/vue3';
import { Bar } from 'vue-chartjs';
import { Chart as ChartJS, BarElement, CategoryScale, LinearScale, Tooltip } from 'chart.js';
import {
  DollarSignIcon, ShoppingBagIcon, PackageIcon, BanknoteIcon,
  PlusIcon, ClockIcon, StoreIcon,
} from 'lucide-vue-next';
import DashboardLayout from '@/Layouts/DashboardLayout.vue';
import StatsCard from '@/Components/Shared/StatsCard.vue';

ChartJS.register(BarElement, CategoryScale, LinearScale, Tooltip);

const props = defineProps({
  stats:              { type: Object, default: () => ({}) },
  vendorProfile:      { type: Object, default: null },
  recentOrders:       { type: Array,  default: () => [] },
  topProducts:        { type: Array,  default: () => [] },
  pendingOrdersCount: { type: Number, default: 0 },
  chartLabels:        { type: Array,  default: () => [] },
  chartSales:         { type: Array,  default: () => [] },
});

const chartPeriod = ref('30D');

const barChartData = computed(() => ({
  labels: props.chartLabels,
  datasets: [{
    label: 'Sales',
    data: props.chartSales,
    backgroundColor: 'rgba(249,115,22,0.6)',
    borderColor: '#f97316',
    borderWidth: 1,
    borderRadius: 4,
  }],
}));

const chartOptions = {
  responsive: true,
  maintainAspectRatio: false,
  plugins: { legend: { display: false } },
  scales: {
    x: { grid: { color: '#262626' }, ticks: { color: '#6b6b6b', font: { size: 10 } } },
    y: { grid: { color: '#262626' }, ticks: { color: '#6b6b6b', font: { size: 10 } } },
  },
};

function formatPrice(p) {
  return new Intl.NumberFormat('en-KE', { style: 'currency', currency: 'KES', maximumFractionDigits: 0 }).format(p ?? 0);
}

function statusClass(s) {
  return {
    pending:   'badge badge-warning',
    processing:'badge badge-info',
    shipped:   'badge badge-neutral',
    delivered: 'badge badge-success',
    cancelled: 'badge badge-error',
  }[s] ?? 'badge badge-neutral';
}

const vendorNav = [
  { label: 'Dashboard',  href: route('vendor.dashboard'),       icon: 'LayoutDashboardIcon' },
  { section: 'Store' },
  { label: 'Products',   href: route('vendor.products.index'),  icon: 'PackageIcon' },
  { label: 'Orders',     href: route('vendor.orders.index'),    icon: 'ShoppingBagIcon' },
  { label: 'Reviews',    href: route('vendor.reviews.index'),   icon: 'StarIcon' },
  { section: 'Finance' },
  { label: 'Earnings',   href: route('vendor.earnings.index'),  icon: 'TrendingUpIcon' },
  { label: 'Payouts',    href: route('vendor.payouts.index'),   icon: 'BanknoteIcon' },
  { section: 'Settings' },
  { label: 'Storefront', href: route('vendor.profile.edit'),    icon: 'StoreIcon' },
  { label: 'Settings',   href: route('vendor.settings.index'),  icon: 'SettingsIcon' },
];
</script>

KODA_FILE_9CF1AF6F

# --- resources/js/Pages/Vendor/Earnings.vue ---
mkdir -p "resources/js/Pages/Vendor"
cat > "resources/js/Pages/Vendor/Earnings.vue" << 'KODA_FILE_DAA2750D'
<template>
  <DashboardLayout :nav-items="vendorNav" page-title="Earnings" :breadcrumbs="[{ label: 'Vendor' }, { label: 'Earnings' }]">
    <!-- Stats -->
    <div class="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
      <div class="koda-card">
        <p class="text-xs text-text-muted">Total Earned</p>
        <p class="font-heading text-2xl font-bold text-accent mt-1">{{ formatPrice(earnings.total_gross) }}</p>
        <p class="text-xs text-text-muted mt-1">Gross revenue</p>
      </div>
      <div class="koda-card">
        <p class="text-xs text-text-muted">Platform Commission</p>
        <p class="font-heading text-2xl font-bold text-status-error mt-1">-{{ formatPrice(earnings.commission) }}</p>
        <p class="text-xs text-text-muted mt-1">{{ earnings.commission_rate }}% rate</p>
      </div>
      <div class="koda-card">
        <p class="text-xs text-text-muted">Net Earnings</p>
        <p class="font-heading text-2xl font-bold text-status-success mt-1">{{ formatPrice(earnings.net) }}</p>
        <p class="text-xs text-text-muted mt-1">After commission</p>
      </div>
      <div class="koda-card">
        <p class="text-xs text-text-muted">Available Balance</p>
        <p class="font-heading text-2xl font-bold text-text-primary mt-1">{{ formatPrice(earnings.balance) }}</p>
        <Link :href="route('vendor.payouts.index')" class="text-xs text-accent hover:text-accent-light mt-1 flex items-center gap-1 transition-colors">
          Request payout <ArrowRightIcon class="w-3 h-3" />
        </Link>
      </div>
    </div>

    <!-- Chart -->
    <div class="koda-card mb-6">
      <div class="flex items-center justify-between mb-6">
        <h3 class="font-heading text-base font-bold">Revenue Breakdown</h3>
        <div class="flex gap-2">
          <button v-for="p in ['7D','30D','90D']" :key="p"
            @click="period = p"
            :class="['px-3 py-1 rounded-btn text-xs font-medium transition-colors', period === p ? 'bg-accent text-white' : 'bg-bg-tertiary text-text-muted hover:text-text-primary']"
          >{{ p }}</button>
        </div>
      </div>
      <div class="h-52">
        <Line :data="chartData" :options="chartOptions" />
      </div>
    </div>

    <!-- Transactions table -->
    <div class="koda-card overflow-hidden p-0">
      <div class="px-5 py-4 border-b border-border">
        <h3 class="font-heading text-sm font-bold">Transaction History</h3>
      </div>
      <div class="overflow-x-auto">
        <table class="koda-table">
          <thead>
            <tr>
              <th>Order #</th>
              <th>Date</th>
              <th>Items</th>
              <th>Gross</th>
              <th>Commission</th>
              <th>Net</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="tx in transactions" :key="tx.order_id">
              <td class="font-mono text-sm text-accent">#{{ tx.order_number }}</td>
              <td class="text-xs text-text-muted">{{ tx.date }}</td>
              <td class="text-xs text-text-secondary">{{ tx.items }}</td>
              <td class="text-sm text-text-primary">{{ formatPrice(tx.gross) }}</td>
              <td class="text-sm text-status-error">-{{ formatPrice(tx.commission) }}</td>
              <td class="text-sm font-semibold text-status-success">{{ formatPrice(tx.net) }}</td>
              <td><span :class="tx.paid ? 'badge badge-success' : 'badge badge-warning'">{{ tx.paid ? 'Paid' : 'Pending' }}</span></td>
            </tr>
          </tbody>
        </table>
      </div>
      <div v-if="!transactions.length" class="text-center py-12 text-text-muted">
        <BanknoteIcon class="w-10 h-10 mx-auto mb-2 text-border" />
        <p class="text-sm">No transactions yet</p>
      </div>
    </div>
  </DashboardLayout>
</template>

<script setup>
import { ref, computed } from 'vue';
import { Link } from '@inertiajs/vue3';
import { Line } from 'vue-chartjs';
import { Chart as ChartJS, LineElement, PointElement, LinearScale, CategoryScale, Tooltip, Filler } from 'chart.js';
import { ArrowRightIcon, BanknoteIcon } from 'lucide-vue-next';
import DashboardLayout from '@/Layouts/DashboardLayout.vue';

ChartJS.register(LineElement, PointElement, LinearScale, CategoryScale, Tooltip, Filler);

const props = defineProps({
  earnings:     { type: Object, default: () => ({ total_gross: 0, commission: 0, net: 0, balance: 0, commission_rate: 10 }) },
  transactions: { type: Array,  default: () => [] },
  chartLabels:  { type: Array,  default: () => [] },
  chartGross:   { type: Array,  default: () => [] },
  chartNet:     { type: Array,  default: () => [] },
});

const period = ref('30D');

const chartData = computed(() => ({
  labels: props.chartLabels,
  datasets: [
    {
      label: 'Gross',
      data: props.chartGross,
      borderColor: '#f97316',
      backgroundColor: 'rgba(249,115,22,0.08)',
      fill: true,
      tension: 0.4,
      pointRadius: 2,
    },
    {
      label: 'Net',
      data: props.chartNet,
      borderColor: '#22c55e',
      backgroundColor: 'rgba(34,197,94,0.05)',
      fill: true,
      tension: 0.4,
      pointRadius: 2,
    },
  ],
}));

const chartOptions = {
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    legend: { display: true, labels: { color: '#a3a3a3', boxWidth: 10, font: { size: 11 } } },
    tooltip: { mode: 'index' },
  },
  scales: {
    x: { grid: { color: '#262626' }, ticks: { color: '#6b6b6b', font: { size: 10 } } },
    y: { grid: { color: '#262626' }, ticks: { color: '#6b6b6b', font: { size: 10 }, callback: v => 'KES ' + v.toLocaleString() } },
  },
};

function formatPrice(p) {
  return new Intl.NumberFormat('en-KE', { style: 'currency', currency: 'KES', maximumFractionDigits: 0 }).format(p ?? 0);
}

const vendorNav = [
  { label: 'Dashboard',  href: route('vendor.dashboard'),       icon: 'LayoutDashboardIcon' },
  { section: 'Store' },
  { label: 'Products',   href: route('vendor.products.index'),  icon: 'PackageIcon' },
  { label: 'Orders',     href: route('vendor.orders.index'),    icon: 'ShoppingBagIcon' },
  { label: 'Reviews',    href: route('vendor.reviews.index'),   icon: 'StarIcon' },
  { section: 'Finance' },
  { label: 'Earnings',   href: route('vendor.earnings.index'),  icon: 'TrendingUpIcon' },
  { label: 'Payouts',    href: route('vendor.payouts.index'),   icon: 'BanknoteIcon' },
  { section: 'Settings' },
  { label: 'Storefront', href: route('vendor.profile.edit'),    icon: 'StoreIcon' },
  { label: 'Settings',   href: route('vendor.settings.index'),  icon: 'SettingsIcon' },
];
</script>

KODA_FILE_DAA2750D

# --- resources/js/Pages/Vendor/Orders/Index.vue ---
mkdir -p "resources/js/Pages/Vendor/Orders"
cat > "resources/js/Pages/Vendor/Orders/Index.vue" << 'KODA_FILE_15D744B4'
<template>
  <DashboardLayout :nav-items="vendorNav" page-title="Orders" :breadcrumbs="[{ label: 'Vendor' }, { label: 'Orders' }]">
    <!-- Filters -->
    <div class="flex items-center gap-3 flex-wrap mb-6">
      <button
        v-for="tab in statusTabs"
        :key="tab.value"
        @click="filterStatus = tab.value"
        :class="[
          'px-4 py-2 rounded-btn text-sm font-medium transition-all',
          filterStatus === tab.value ? 'bg-accent text-white' : 'bg-bg-tertiary text-text-secondary hover:text-text-primary border border-border',
        ]"
      >
        {{ tab.label }}
        <span v-if="tab.count" class="ml-1.5 text-xs opacity-75">({{ tab.count }})</span>
      </button>
    </div>

    <!-- Table -->
    <div class="koda-card overflow-hidden p-0">
      <div class="overflow-x-auto">
        <table class="koda-table">
          <thead>
            <tr>
              <th>Order #</th>
              <th>Date</th>
              <th>Items</th>
              <th>Revenue</th>
              <th>Status</th>
              <th class="w-24">Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="order in filteredOrders" :key="order.id">
              <td class="font-mono text-sm text-accent">#{{ order.order_number }}</td>
              <td class="text-xs text-text-muted">{{ order.created_at_human }}</td>
              <td class="text-xs">{{ order.items_count }} item(s)</td>
              <td class="font-semibold text-text-primary text-sm">{{ formatPrice(order.vendor_total) }}</td>
              <td>
                <select
                  :value="order.status"
                  @change="updateStatus(order, $event.target.value)"
                  :class="['text-xs rounded-full px-2.5 py-1 border-0 cursor-pointer font-medium', statusSelectBg(order.status)]"
                >
                  <option value="pending">Pending</option>
                  <option value="processing">Processing</option>
                  <option value="shipped">Shipped</option>
                  <option value="delivered">Delivered</option>
                  <option value="cancelled">Cancelled</option>
                </select>
              </td>
              <td>
                <Link :href="route('vendor.orders.show', order.id)" class="btn-ghost p-1.5 text-text-muted hover:text-accent">
                  <EyeIcon class="w-4 h-4" />
                </Link>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <div v-if="!filteredOrders.length" class="text-center py-16 text-text-muted">
        <ShoppingBagIcon class="w-12 h-12 mx-auto mb-3 text-border" />
        <p class="font-heading text-base">No orders found</p>
        <p class="text-sm mt-1">Orders will appear here once buyers purchase your products</p>
      </div>
    </div>

    <Pagination :links="orders.links" />
  </DashboardLayout>
</template>

<script setup>
import { ref, computed } from 'vue';
import { Link, router } from '@inertiajs/vue3';
import { EyeIcon, ShoppingBagIcon } from 'lucide-vue-next';
import DashboardLayout from '@/Layouts/DashboardLayout.vue';
import Pagination from '@/Components/UI/Pagination.vue';

const props = defineProps({
  orders:  { type: Object, required: true },
  filters: { type: Object, default: () => ({}) },
});

const filterStatus = ref(props.filters.status ?? 'all');

const statusTabs = computed(() => [
  { label: 'All',        value: 'all' },
  { label: 'Pending',    value: 'pending',    count: props.orders.data.filter(o => o.status === 'pending').length || null },
  { label: 'Processing', value: 'processing', count: null },
  { label: 'Shipped',    value: 'shipped',    count: null },
  { label: 'Delivered',  value: 'delivered',  count: null },
]);

const filteredOrders = computed(() => {
  if (filterStatus.value === 'all') return props.orders.data;
  return props.orders.data.filter(o => o.status === filterStatus.value);
});

function formatPrice(p) {
  return new Intl.NumberFormat('en-KE', { style: 'currency', currency: 'KES' }).format(p);
}

function statusSelectBg(s) {
  return {
    pending:    'bg-yellow-950 text-yellow-400',
    processing: 'bg-blue-950 text-blue-400',
    shipped:    'bg-bg-tertiary text-text-secondary',
    delivered:  'bg-green-950 text-green-400',
    cancelled:  'bg-red-950 text-red-400',
  }[s] ?? 'bg-bg-tertiary text-text-muted';
}

function updateStatus(order, status) {
  router.patch(route('vendor.items.status', order.id), { status }, { preserveScroll: true });
}

const vendorNav = [
  { label: 'Dashboard',  href: route('vendor.dashboard'),       icon: 'LayoutDashboardIcon' },
  { section: 'Store' },
  { label: 'Products',   href: route('vendor.products.index'),  icon: 'PackageIcon' },
  { label: 'Orders',     href: route('vendor.orders.index'),    icon: 'ShoppingBagIcon' },
  { label: 'Reviews',    href: route('vendor.reviews.index'),   icon: 'StarIcon' },
  { section: 'Finance' },
  { label: 'Earnings',   href: route('vendor.earnings.index'),  icon: 'TrendingUpIcon' },
  { label: 'Payouts',    href: route('vendor.payouts.index'),   icon: 'BanknoteIcon' },
  { section: 'Settings' },
  { label: 'Storefront', href: route('vendor.profile.edit'),    icon: 'StoreIcon' },
];
</script>

KODA_FILE_15D744B4

# --- resources/js/Pages/Vendor/Orders/Show.vue ---
mkdir -p "resources/js/Pages/Vendor/Orders"
cat > "resources/js/Pages/Vendor/Orders/Show.vue" << 'KODA_FILE_D157A1C6'
<template>
  <DashboardLayout
    :nav-items="vendorNav"
    :page-title="'Order #' + order.order_number"
    :breadcrumbs="[{ label: 'Orders', href: route('vendor.orders.index') }, { label: '#' + order.order_number }]"
  >
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
      <!-- Order items -->
      <div class="lg:col-span-2 space-y-4">
        <div class="koda-card">
          <div class="flex items-center justify-between mb-4">
            <h3 class="font-heading text-base font-bold">Order Items</h3>
            <span :class="statusClass(order.status)" class="text-sm">{{ order.status }}</span>
          </div>
          <div class="space-y-4">
            <div v-for="item in order.items" :key="item.id" class="flex items-center gap-4 pb-4 border-b border-border last:border-0 last:pb-0">
              <div class="w-14 h-14 rounded-lg overflow-hidden bg-bg-tertiary border border-border shrink-0">
                <img v-if="item.product?.thumbnail" :src="item.product.thumbnail" class="w-full h-full object-cover" />
              </div>
              <div class="flex-1 min-w-0">
                <p class="text-sm font-semibold text-text-primary">{{ item.product?.name }}</p>
                <p class="text-xs text-text-muted mt-0.5">Qty: {{ item.quantity }} × {{ formatPrice(item.unit_price) }}</p>
              </div>
              <div class="text-right shrink-0">
                <p class="font-semibold text-accent text-sm">{{ formatPrice(item.subtotal) }}</p>
                <select
                  :value="item.status"
                  @change="updateItemStatus(item, $event.target.value)"
                  :class="['mt-1 text-xs rounded-full px-2 py-0.5 border-0 cursor-pointer font-medium', statusSelectBg(item.status)]"
                >
                  <option value="pending">Pending</option>
                  <option value="processing">Processing</option>
                  <option value="shipped">Shipped</option>
                  <option value="delivered">Delivered</option>
                  <option value="cancelled">Cancelled</option>
                </select>
              </div>
            </div>
          </div>
        </div>

        <!-- Totals -->
        <div class="koda-card">
          <div class="space-y-2 text-sm text-text-secondary">
            <div class="flex justify-between"><span>Your items subtotal</span><span>{{ formatPrice(vendorTotal) }}</span></div>
            <div class="flex justify-between text-status-error"><span>Platform commission ({{ commissionRate }}%)</span><span>-{{ formatPrice(commission) }}</span></div>
          </div>
          <div class="flex justify-between font-heading font-bold mt-3 pt-3 border-t border-border">
            <span>Your net earnings</span><span class="text-status-success">{{ formatPrice(netEarning) }}</span>
          </div>
        </div>
      </div>

      <!-- Buyer + shipping -->
      <div class="space-y-4">
        <div class="koda-card">
          <h3 class="font-heading text-sm font-bold mb-3">Buyer</h3>
          <p class="text-sm font-medium text-text-primary">{{ order.buyer?.name }}</p>
          <p class="text-xs text-text-muted">{{ order.buyer?.email }}</p>
        </div>

        <div class="koda-card">
          <h3 class="font-heading text-sm font-bold mb-3 flex items-center gap-2">
            <TruckIcon class="w-4 h-4 text-accent" /> Shipping
          </h3>
          <div class="space-y-1 text-sm text-text-secondary">
            <p class="font-medium text-text-primary">{{ order.shipping_name }}</p>
            <p>{{ order.shipping_address }}</p>
            <p>{{ order.shipping_city }}, {{ order.shipping_country }}</p>
            <p v-if="order.shipping_phone" class="text-text-muted">{{ order.shipping_phone }}</p>
          </div>
        </div>

        <div class="koda-card">
          <h3 class="font-heading text-sm font-bold mb-3">Payment</h3>
          <div class="flex items-center gap-2">
            <span :class="order.payment_status === 'paid' ? 'badge badge-success' : 'badge badge-warning'">{{ order.payment_status }}</span>
            <span class="text-xs text-text-muted capitalize">via {{ order.payment_method }}</span>
          </div>
        </div>

        <div v-if="order.notes" class="koda-card">
          <h3 class="font-heading text-sm font-bold mb-2">Order Notes</h3>
          <p class="text-sm text-text-secondary italic">{{ order.notes }}</p>
        </div>

        <Link :href="route('vendor.orders.index')" class="btn-ghost w-full justify-center gap-2 text-sm text-text-muted">
          <ArrowLeftIcon class="w-4 h-4" /> Back to Orders
        </Link>
      </div>
    </div>
  </DashboardLayout>
</template>

<script setup>
import { computed } from 'vue';
import { Link, router } from '@inertiajs/vue3';
import { TruckIcon, ArrowLeftIcon } from 'lucide-vue-next';
import DashboardLayout from '@/Layouts/DashboardLayout.vue';

const props = defineProps({ order: { type: Object, required: true } });

const commissionRate = 10;
const vendorTotal  = computed(() => props.order.items?.reduce((s, i) => s + i.subtotal, 0) ?? 0);
const commission   = computed(() => vendorTotal.value * commissionRate / 100);
const netEarning   = computed(() => vendorTotal.value - commission.value);

function formatPrice(p) {
  return new Intl.NumberFormat('en-KE', { style: 'currency', currency: 'KES' }).format(p ?? 0);
}

function statusClass(s) {
  return { pending: 'badge badge-warning', processing: 'badge badge-info', shipped: 'badge badge-neutral', delivered: 'badge badge-success', cancelled: 'badge badge-error' }[s] ?? 'badge badge-neutral';
}

function statusSelectBg(s) {
  return { pending: 'bg-yellow-950 text-yellow-400', processing: 'bg-blue-950 text-blue-400', shipped: 'bg-bg-tertiary text-text-secondary', delivered: 'bg-green-950 text-green-400', cancelled: 'bg-red-950 text-red-400' }[s] ?? 'bg-bg-tertiary text-text-muted';
}

function updateItemStatus(item, status) {
  router.patch(route('vendor.items.status', item.id), { status }, { preserveScroll: true });
}

const vendorNav = [
  { label: 'Dashboard',  href: route('vendor.dashboard'),       icon: 'LayoutDashboardIcon' },
  { section: 'Store' },
  { label: 'Products',   href: route('vendor.products.index'),  icon: 'PackageIcon' },
  { label: 'Orders',     href: route('vendor.orders.index'),    icon: 'ShoppingBagIcon' },
  { label: 'Reviews',    href: route('vendor.reviews.index'),   icon: 'StarIcon' },
  { section: 'Finance' },
  { label: 'Earnings',   href: route('vendor.earnings.index'),  icon: 'TrendingUpIcon' },
  { label: 'Payouts',    href: route('vendor.payouts.index'),   icon: 'BanknoteIcon' },
  { section: 'Settings' },
  { label: 'Storefront', href: route('vendor.profile.edit'),    icon: 'StoreIcon' },
  { label: 'Settings',   href: route('vendor.settings.index'),  icon: 'SettingsIcon' },
];
</script>

KODA_FILE_D157A1C6

# --- resources/js/Pages/Vendor/Payouts.vue ---
mkdir -p "resources/js/Pages/Vendor"
cat > "resources/js/Pages/Vendor/Payouts.vue" << 'KODA_FILE_BD480F86'
<template>
  <DashboardLayout :nav-items="vendorNav" page-title="Payouts" :breadcrumbs="[{ label: 'Vendor' }, { label: 'Payouts' }]">
    <!-- Balance card -->
    <div class="koda-card mb-8 relative overflow-hidden">
      <div class="absolute right-0 top-0 bottom-0 w-64 bg-gradient-radial from-accent/5 to-transparent pointer-events-none" />
      <div class="flex items-center justify-between gap-6">
        <div>
          <p class="text-text-muted text-sm">Available Balance</p>
          <p class="font-heading text-4xl font-bold text-accent mt-1">{{ formatPrice(balance) }}</p>
          <p class="text-xs text-text-muted mt-1">Minimum payout: KES 500</p>
        </div>
        <button
          v-if="balance >= 500"
          @click="requestModalOpen = true"
          class="btn-primary px-8 py-3 text-base shrink-0"
        >
          <BanknoteIcon class="w-4 h-4" />
          Request Payout
        </button>
        <div v-else class="text-right">
          <p class="text-sm text-text-muted">Need at least</p>
          <p class="font-heading text-lg font-bold text-text-secondary">KES 500</p>
          <p class="text-xs text-text-muted">to request payout</p>
        </div>
      </div>
    </div>

    <!-- Payout history -->
    <div class="koda-card overflow-hidden p-0">
      <div class="px-5 py-4 border-b border-border">
        <h3 class="font-heading text-sm font-bold">Payout History</h3>
      </div>
      <div class="overflow-x-auto">
        <table class="koda-table">
          <thead>
            <tr>
              <th>Reference</th>
              <th>Amount</th>
              <th>Method</th>
              <th>Status</th>
              <th>Requested</th>
              <th>Processed</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="payout in payouts" :key="payout.id">
              <td class="font-mono text-xs text-text-muted">{{ payout.reference }}</td>
              <td class="font-semibold text-text-primary text-sm">{{ formatPrice(payout.amount) }}</td>
              <td class="text-xs text-text-secondary capitalize">{{ payout.method }}</td>
              <td>
                <span :class="payoutStatusClass(payout.status)">{{ payout.status }}</span>
              </td>
              <td class="text-xs text-text-muted">{{ payout.created_at_human }}</td>
              <td class="text-xs text-text-muted">{{ payout.processed_at ?? '—' }}</td>
            </tr>
          </tbody>
        </table>
      </div>
      <div v-if="!payouts.length" class="text-center py-16 text-text-muted">
        <BanknoteIcon class="w-12 h-12 mx-auto mb-3 text-border" />
        <p class="text-sm">No payouts requested yet</p>
      </div>
    </div>

    <!-- Request payout modal -->
    <Modal v-model="requestModalOpen" title="Request Payout" max-width="sm">
      <div class="space-y-4">
        <div class="bg-bg-tertiary rounded-btn p-4 text-center">
          <p class="text-xs text-text-muted">Available</p>
          <p class="font-heading text-2xl font-bold text-accent">{{ formatPrice(balance) }}</p>
        </div>
        <div>
          <label class="koda-label">Amount (KES)</label>
          <input v-model="payoutForm.amount" type="number" min="500" :max="balance" class="koda-input" placeholder="500" />
          <p class="text-xs text-text-muted mt-1">Min: KES 500 · Max: {{ formatPrice(balance) }}</p>
        </div>
        <div>
          <label class="koda-label">Payout Method</label>
          <select v-model="payoutForm.method" class="koda-select">
            <option value="mpesa">M-Pesa</option>
            <option value="bank">Bank Transfer</option>
            <option value="airtel">Airtel Money</option>
          </select>
        </div>
        <div>
          <label class="koda-label">Account Number / Phone</label>
          <input v-model="payoutForm.account" type="text" class="koda-input" placeholder="e.g. 0712345678" />
        </div>
      </div>
      <template #footer>
        <button @click="requestModalOpen = false" class="btn-ghost">Cancel</button>
        <button @click="submitPayout" :disabled="submitting || payoutForm.amount < 500" class="btn-primary">
          <LoaderIcon v-if="submitting" class="w-4 h-4 animate-spin" />
          Confirm Request
        </button>
      </template>
    </Modal>
  </DashboardLayout>
</template>

<script setup>
import { ref } from 'vue';
import { router } from '@inertiajs/vue3';
import { BanknoteIcon, LoaderIcon } from 'lucide-vue-next';
import DashboardLayout from '@/Layouts/DashboardLayout.vue';
import Modal from '@/Components/UI/Modal.vue';

const props = defineProps({
  balance: { type: Number, default: 0 },
  payouts: { type: Array,  default: () => [] },
});

const requestModalOpen = ref(false);
const submitting       = ref(false);
const payoutForm       = ref({ amount: '', method: 'mpesa', account: '' });

function formatPrice(p) {
  return new Intl.NumberFormat('en-KE', { style: 'currency', currency: 'KES' }).format(p ?? 0);
}

function payoutStatusClass(s) {
  return { pending: 'badge badge-warning', approved: 'badge badge-info', paid: 'badge badge-success', rejected: 'badge badge-error' }[s] ?? 'badge badge-neutral';
}

function submitPayout() {
  submitting.value = true;
  router.post(route('vendor.payouts.store'), payoutForm.value, {
    onSuccess: () => { requestModalOpen.value = false; payoutForm.value = { amount: '', method: 'mpesa', account: '' }; },
    onFinish:  () => { submitting.value = false; },
  });
}

const vendorNav = [
  { label: 'Dashboard',  href: route('vendor.dashboard'),       icon: 'LayoutDashboardIcon' },
  { section: 'Store' },
  { label: 'Products',   href: route('vendor.products.index'),  icon: 'PackageIcon' },
  { label: 'Orders',     href: route('vendor.orders.index'),    icon: 'ShoppingBagIcon' },
  { label: 'Reviews',    href: route('vendor.reviews.index'),   icon: 'StarIcon' },
  { section: 'Finance' },
  { label: 'Earnings',   href: route('vendor.earnings.index'),  icon: 'TrendingUpIcon' },
  { label: 'Payouts',    href: route('vendor.payouts.index'),   icon: 'BanknoteIcon' },
  { section: 'Settings' },
  { label: 'Storefront', href: route('vendor.profile.edit'),    icon: 'StoreIcon' },
  { label: 'Settings',   href: route('vendor.settings.index'),  icon: 'SettingsIcon' },
];
</script>

KODA_FILE_BD480F86

# --- resources/js/Pages/Vendor/Products/Form.vue ---
mkdir -p "resources/js/Pages/Vendor/Products"
cat > "resources/js/Pages/Vendor/Products/Form.vue" << 'KODA_FILE_0AFBA35A'
<template>
  <DashboardLayout
    :nav-items="vendorNav"
    :page-title="isEdit ? 'Edit Product' : 'Add Product'"
    :breadcrumbs="[
      { label: 'Products', href: route('vendor.products.index') },
      { label: isEdit ? 'Edit' : 'New' },
    ]"
  >
    <form @submit.prevent="submit">
      <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <!-- Main -->
        <div class="lg:col-span-2 space-y-5">
          <!-- Basic info -->
          <div class="koda-card space-y-5">
            <h3 class="font-heading text-base font-bold">Product Info</h3>
            <div>
              <label class="koda-label">Product Name <span class="text-status-error">*</span></label>
              <input v-model="form.name" type="text" class="koda-input" :class="{ error: errors.name }" placeholder="e.g. Industrial Grade Safety Gloves" />
              <p v-if="errors.name" class="koda-error">{{ errors.name }}</p>
            </div>
            <div>
              <label class="koda-label">Short Description</label>
              <textarea v-model="form.short_description" rows="2" class="koda-textarea" placeholder="Brief product summary (shown on listing cards)" />
            </div>
            <div>
              <label class="koda-label">Full Description <span class="text-status-error">*</span></label>
              <textarea v-model="form.description" rows="6" class="koda-textarea" :class="{ error: errors.description }" placeholder="Detailed product description..." />
              <p v-if="errors.description" class="koda-error">{{ errors.description }}</p>
            </div>
          </div>

          <!-- Media -->
          <div class="koda-card space-y-4">
            <h3 class="font-heading text-base font-bold">Images</h3>
            <!-- Thumbnail -->
            <div>
              <label class="koda-label">Thumbnail <span class="text-status-error">*</span></label>
              <div
                @dragover.prevent
                @drop.prevent="handleDrop"
                @click="$refs.thumbInput.click()"
                class="border-2 border-dashed border-border hover:border-accent/50 rounded-lg p-8 text-center cursor-pointer transition-colors"
              >
                <div v-if="thumbnailPreview" class="relative inline-block">
                  <img :src="thumbnailPreview" class="max-h-40 rounded-lg mx-auto object-cover" />
                  <button @click.stop="thumbnailPreview = null; form.thumbnail = null" class="absolute -top-2 -right-2 w-6 h-6 bg-status-error rounded-full flex items-center justify-center">
                    <XIcon class="w-3 h-3 text-white" />
                  </button>
                </div>
                <div v-else>
                  <UploadCloudIcon class="w-8 h-8 text-text-muted mx-auto mb-2" />
                  <p class="text-sm text-text-muted">Drop image or click to upload</p>
                  <p class="text-xs text-text-muted mt-1">PNG, JPG, WEBP up to 5MB</p>
                </div>
              </div>
              <input ref="thumbInput" type="file" accept="image/*" class="hidden" @change="handleThumbnail" />
            </div>
          </div>

          <!-- Pricing & inventory -->
          <div class="koda-card space-y-5">
            <h3 class="font-heading text-base font-bold">Pricing & Inventory</h3>
            <div class="grid grid-cols-2 gap-4">
              <div>
                <label class="koda-label">Price (KES) <span class="text-status-error">*</span></label>
                <input v-model="form.price" type="number" min="0" step="0.01" class="koda-input" :class="{ error: errors.price }" placeholder="0.00" />
                <p v-if="errors.price" class="koda-error">{{ errors.price }}</p>
              </div>
              <div>
                <label class="koda-label">Compare at Price</label>
                <input v-model="form.compare_price" type="number" min="0" step="0.01" class="koda-input" placeholder="0.00" />
              </div>
            </div>
            <div class="grid grid-cols-2 gap-4">
              <div>
                <label class="koda-label">Stock Quantity <span class="text-status-error">*</span></label>
                <input v-model="form.stock" type="number" min="0" class="koda-input" placeholder="0" />
              </div>
              <div>
                <label class="koda-label">SKU</label>
                <input v-model="form.sku" type="text" class="koda-input font-mono" placeholder="AUTO-generated" />
              </div>
            </div>
          </div>
        </div>

        <!-- Sidebar -->
        <div class="space-y-5">
          <!-- Status -->
          <div class="koda-card space-y-4">
            <h3 class="font-heading text-base font-bold">Publish</h3>
            <div>
              <label class="koda-label">Status</label>
              <select v-model="form.status" class="koda-select text-sm">
                <option value="draft">Draft</option>
                <option value="active">Active</option>
                <option value="inactive">Inactive</option>
              </select>
            </div>
            <div class="flex flex-col gap-3 pt-2 border-t border-border">
              <button type="submit" :disabled="submitting" class="btn-primary w-full">
                <LoaderIcon v-if="submitting" class="w-4 h-4 animate-spin" />
                {{ isEdit ? 'Update Product' : 'Create Product' }}
              </button>
              <Link :href="route('vendor.products.index')" class="btn-ghost w-full text-text-muted justify-center">Cancel</Link>
            </div>
          </div>

          <!-- Category -->
          <div class="koda-card space-y-3">
            <h3 class="font-heading text-base font-bold">Category <span class="text-status-error">*</span></h3>
            <select v-model="form.category_id" class="koda-select text-sm" :class="{ error: errors.category_id }">
              <option value="">Select category</option>
              <option v-for="cat in categories" :key="cat.id" :value="cat.id">{{ cat.name }}</option>
            </select>
            <p v-if="errors.category_id" class="koda-error">{{ errors.category_id }}</p>
          </div>

          <!-- Featured -->
          <div class="koda-card">
            <label class="flex items-center gap-3 cursor-pointer">
              <div class="relative">
                <input type="checkbox" v-model="form.is_featured" class="sr-only peer" />
                <div class="w-10 h-5 bg-border rounded-full peer peer-checked:bg-accent transition-colors" />
                <div class="absolute top-0.5 left-0.5 w-4 h-4 bg-white rounded-full transition-transform peer-checked:translate-x-5" />
              </div>
              <span class="text-sm font-medium text-text-secondary">Featured product</span>
            </label>
          </div>
        </div>
      </div>
    </form>
  </DashboardLayout>
</template>

<script setup>
import { ref, computed } from 'vue';
import { Link, router } from '@inertiajs/vue3';
import { XIcon, UploadCloudIcon, LoaderIcon } from 'lucide-vue-next';
import DashboardLayout from '@/Layouts/DashboardLayout.vue';

const props = defineProps({
  product:    { type: Object, default: null },
  categories: { type: Array,  default: () => [] },
  errors:     { type: Object, default: () => ({}) },
});

const isEdit = computed(() => !!props.product);
const submitting = ref(false);
const thumbnailPreview = ref(props.product?.thumbnail ?? null);

const form = ref({
  name:              props.product?.name ?? '',
  short_description: props.product?.short_description ?? '',
  description:       props.product?.description ?? '',
  price:             props.product?.price ?? '',
  compare_price:     props.product?.compare_price ?? '',
  stock:             props.product?.stock ?? '',
  sku:               props.product?.sku ?? '',
  category_id:       props.product?.category_id ?? '',
  status:            props.product?.status ?? 'draft',
  is_featured:       props.product?.is_featured ?? false,
  thumbnail:         null,
});

function handleThumbnail(e) {
  const file = e.target.files[0];
  if (!file) return;
  form.value.thumbnail = file;
  const reader = new FileReader();
  reader.onload = (ev) => { thumbnailPreview.value = ev.target.result; };
  reader.readAsDataURL(file);
}

function handleDrop(e) {
  const file = e.dataTransfer.files[0];
  if (file && file.type.startsWith('image/')) {
    const fakeEvent = { target: { files: [file] } };
    handleThumbnail(fakeEvent);
  }
}

function submit() {
  submitting.value = true;
  const data = new FormData();
  Object.entries(form.value).forEach(([k, v]) => { if (v !== null) data.append(k, v); });

  const options = {
    forceFormData: true,
    onFinish: () => { submitting.value = false; },
    onError: () => { submitting.value = false; },
  };

  if (isEdit.value) {
    data.append('_method', 'PUT');
    router.post(route('vendor.products.update', props.product.id), data, options);
  } else {
    router.post(route('vendor.products.store'), data, options);
  }
}

const vendorNav = [
  { label: 'Dashboard',  href: route('vendor.dashboard'),       icon: 'LayoutDashboardIcon' },
  { section: 'Store' },
  { label: 'Products',   href: route('vendor.products.index'),  icon: 'PackageIcon' },
  { label: 'Orders',     href: route('vendor.orders.index'),    icon: 'ShoppingBagIcon' },
  { section: 'Finance' },
  { label: 'Earnings',   href: route('vendor.earnings.index'),  icon: 'TrendingUpIcon' },
  { label: 'Payouts',    href: route('vendor.payouts.index'),   icon: 'BanknoteIcon' },
  { section: 'Settings' },
  { label: 'Storefront', href: route('vendor.profile.edit'),    icon: 'StoreIcon' },
];
</script>

KODA_FILE_0AFBA35A

# --- resources/js/Pages/Vendor/Products/Index.vue ---
mkdir -p "resources/js/Pages/Vendor/Products"
cat > "resources/js/Pages/Vendor/Products/Index.vue" << 'KODA_FILE_FB2A17E8'
<template>
  <DashboardLayout :nav-items="vendorNav" page-title="My Products" :breadcrumbs="[{ label: 'Vendor' }, { label: 'Products' }]">
    <!-- Toolbar -->
    <div class="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 mb-6">
      <div class="flex items-center gap-3 flex-wrap">
        <div class="relative">
          <SearchIcon class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-text-muted pointer-events-none" />
          <input v-model="search" type="text" placeholder="Search products..." class="koda-input pl-9 text-sm w-56" />
        </div>
        <select v-model="statusFilter" class="koda-select text-sm w-36">
          <option value="">All statuses</option>
          <option value="active">Active</option>
          <option value="draft">Draft</option>
          <option value="inactive">Inactive</option>
        </select>
      </div>
      <Link :href="route('vendor.products.create')" class="btn-primary shrink-0">
        <PlusIcon class="w-4 h-4" />
        Add Product
      </Link>
    </div>

    <!-- Table -->
    <div class="koda-card overflow-hidden p-0">
      <div class="overflow-x-auto">
        <table class="koda-table">
          <thead>
            <tr>
              <th class="w-12"><input type="checkbox" v-model="selectAll" class="accent-accent" /></th>
              <th>Product</th>
              <th>Category</th>
              <th>Price</th>
              <th>Stock</th>
              <th>Status</th>
              <th>Sales</th>
              <th class="w-24">Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="product in filteredProducts" :key="product.id">
              <td><input type="checkbox" :value="product.id" v-model="selected" class="accent-accent" /></td>
              <td>
                <div class="flex items-center gap-3">
                  <div class="w-10 h-10 rounded-lg overflow-hidden bg-bg-tertiary border border-border shrink-0">
                    <img v-if="product.thumbnail" :src="product.thumbnail" class="w-full h-full object-cover" />
                    <PackageIcon v-else class="w-4 h-4 text-border m-auto mt-3" />
                  </div>
                  <div class="min-w-0">
                    <p class="text-sm font-medium text-text-primary truncate max-w-xs">{{ product.name }}</p>
                    <p class="text-xs text-text-muted font-mono">{{ product.sku }}</p>
                  </div>
                </div>
              </td>
              <td class="text-xs text-text-muted">{{ product.category?.name }}</td>
              <td class="font-semibold text-accent text-sm">{{ formatPrice(product.price) }}</td>
              <td>
                <span :class="['text-xs font-medium', product.stock <= 5 ? 'text-status-warning' : product.stock === 0 ? 'text-status-error' : 'text-text-secondary']">
                  {{ product.stock }}
                </span>
              </td>
              <td>
                <select
                  :value="product.status"
                  @change="updateStatus(product.id, $event.target.value)"
                  :class="['text-xs rounded-full px-2.5 py-1 border-0 cursor-pointer font-medium', statusSelectClass(product.status)]"
                >
                  <option value="active">Active</option>
                  <option value="draft">Draft</option>
                  <option value="inactive">Inactive</option>
                </select>
              </td>
              <td class="text-xs text-text-muted">{{ product.orders_count }}</td>
              <td>
                <div class="flex items-center gap-1">
                  <Link :href="route('vendor.products.edit', product.id)" class="btn-ghost p-1.5 text-text-muted hover:text-text-primary">
                    <EditIcon class="w-3.5 h-3.5" />
                  </Link>
                  <Link :href="route('products.show', product.slug)" target="_blank" class="btn-ghost p-1.5 text-text-muted hover:text-accent">
                    <EyeIcon class="w-3.5 h-3.5" />
                  </Link>
                  <button @click="deleteProduct(product)" class="btn-ghost p-1.5 text-text-muted hover:text-status-error">
                    <Trash2Icon class="w-3.5 h-3.5" />
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- Empty state -->
      <div v-if="!filteredProducts.length" class="text-center py-16 text-text-muted">
        <PackageIcon class="w-12 h-12 mx-auto mb-3 text-border" />
        <p class="font-heading text-base">No products yet</p>
        <p class="text-sm mt-1 mb-4">Add your first product to start selling</p>
        <Link :href="route('vendor.products.create')" class="btn-primary mx-auto">
          <PlusIcon class="w-4 h-4" /> Add Product
        </Link>
      </div>
    </div>

    <Pagination :links="products.links" />
  </DashboardLayout>
</template>

<script setup>
import { ref, computed } from 'vue';
import { Link, router } from '@inertiajs/vue3';
import { PlusIcon, SearchIcon, EditIcon, EyeIcon, Trash2Icon, PackageIcon } from 'lucide-vue-next';
import DashboardLayout from '@/Layouts/DashboardLayout.vue';
import Pagination from '@/Components/UI/Pagination.vue';

const props = defineProps({
  products: { type: Object, required: true },
});

const search = ref('');
const statusFilter = ref('');
const selected = ref([]);
const selectAll = computed({
  get: () => selected.value.length === props.products.data?.length,
  set: (v) => { selected.value = v ? props.products.data.map(p => p.id) : []; },
});

const filteredProducts = computed(() => {
  let list = props.products.data ?? [];
  if (search.value) list = list.filter(p => p.name.toLowerCase().includes(search.value.toLowerCase()));
  if (statusFilter.value) list = list.filter(p => p.status === statusFilter.value);
  return list;
});

function formatPrice(p) {
  return new Intl.NumberFormat('en-KE', { style: 'currency', currency: 'KES' }).format(p);
}

function statusSelectClass(status) {
  return { active: 'bg-green-950 text-green-400', draft: 'bg-yellow-950 text-yellow-400', inactive: 'bg-bg-tertiary text-text-muted' }[status];
}

function updateStatus(id, status) {
  router.patch(route('vendor.products.status', id), { status }, { preserveScroll: true });
}

function deleteProduct(product) {
  if (confirm(`Delete "${product.name}"? This cannot be undone.`)) {
    router.delete(route('vendor.products.destroy', product.id), { preserveScroll: true });
  }
}

const vendorNav = [
  { label: 'Dashboard',  href: route('vendor.dashboard'),       icon: 'LayoutDashboardIcon' },
  { section: 'Store' },
  { label: 'Products',   href: route('vendor.products.index'),  icon: 'PackageIcon' },
  { label: 'Orders',     href: route('vendor.orders.index'),    icon: 'ShoppingBagIcon' },
  { label: 'Reviews',    href: route('vendor.reviews.index'),   icon: 'StarIcon' },
  { section: 'Finance' },
  { label: 'Earnings',   href: route('vendor.earnings.index'),  icon: 'TrendingUpIcon' },
  { label: 'Payouts',    href: route('vendor.payouts.index'),   icon: 'BanknoteIcon' },
  { section: 'Settings' },
  { label: 'Storefront', href: route('vendor.profile.edit'),    icon: 'StoreIcon' },
];
</script>

KODA_FILE_FB2A17E8

# --- resources/js/Pages/Vendor/Profile.vue ---
mkdir -p "resources/js/Pages/Vendor"
cat > "resources/js/Pages/Vendor/Profile.vue" << 'KODA_FILE_3061766F'
<template>
  <DashboardLayout :nav-items="vendorNav" page-title="Storefront Settings" :breadcrumbs="[{ label: 'Vendor' }, { label: 'Storefront' }]">
    <form @submit.prevent="submit" class="max-w-2xl space-y-6">
      <!-- Store info -->
      <div class="koda-card space-y-5">
        <h3 class="font-heading text-base font-bold">Store Information</h3>

        <!-- Banner upload -->
        <div>
          <label class="koda-label">Store Banner</label>
          <div
            @click="$refs.bannerInput.click()"
            class="relative h-32 rounded-lg overflow-hidden bg-bg-tertiary border-2 border-dashed border-border hover:border-accent/50 cursor-pointer transition-colors"
          >
            <img v-if="bannerPreview" :src="bannerPreview" class="w-full h-full object-cover" />
            <div v-else class="flex flex-col items-center justify-center h-full gap-2">
              <UploadCloudIcon class="w-8 h-8 text-text-muted" />
              <p class="text-xs text-text-muted">Click to upload banner (1200×300px)</p>
            </div>
          </div>
          <input ref="bannerInput" type="file" accept="image/*" class="hidden" @change="handleBanner" />
        </div>

        <!-- Logo upload -->
        <div class="flex items-center gap-4">
          <div
            @click="$refs.logoInput.click()"
            class="w-16 h-16 rounded-xl overflow-hidden bg-bg-tertiary border-2 border-dashed border-border hover:border-accent/50 cursor-pointer transition-colors flex items-center justify-center shrink-0"
          >
            <img v-if="logoPreview" :src="logoPreview" class="w-full h-full object-cover" />
            <UploadCloudIcon v-else class="w-6 h-6 text-text-muted" />
          </div>
          <input ref="logoInput" type="file" accept="image/*" class="hidden" @change="handleLogo" />
          <div>
            <p class="text-sm font-medium text-text-primary">Store Logo</p>
            <p class="text-xs text-text-muted">Square, minimum 200×200px</p>
          </div>
        </div>

        <div>
          <label class="koda-label">Store Name <span class="text-status-error">*</span></label>
          <input v-model="form.store_name" type="text" class="koda-input" :class="{ error: errors.store_name }" />
          <p v-if="errors.store_name" class="koda-error">{{ errors.store_name }}</p>
        </div>

        <div>
          <label class="koda-label">Store Description</label>
          <textarea v-model="form.description" rows="4" class="koda-textarea" placeholder="Tell buyers about your business..." />
        </div>
      </div>

      <!-- Contact info -->
      <div class="koda-card space-y-4">
        <h3 class="font-heading text-base font-bold">Contact & Location</h3>
        <div class="grid grid-cols-2 gap-4">
          <div>
            <label class="koda-label">Phone</label>
            <input v-model="form.phone" type="tel" class="koda-input" placeholder="+254 7XX XXX XXX" />
          </div>
          <div>
            <label class="koda-label">City</label>
            <input v-model="form.city" type="text" class="koda-input" placeholder="Nairobi" />
          </div>
        </div>
        <div>
          <label class="koda-label">Address</label>
          <input v-model="form.address" type="text" class="koda-input" placeholder="Business address" />
        </div>
        <div>
          <label class="koda-label">Country</label>
          <select v-model="form.country" class="koda-select">
            <option value="KE">Kenya</option>
            <option value="UG">Uganda</option>
            <option value="TZ">Tanzania</option>
            <option value="RW">Rwanda</option>
          </select>
        </div>
      </div>

      <!-- Actions -->
      <div class="flex items-center gap-3">
        <button type="submit" :disabled="submitting" class="btn-primary px-8">
          <LoaderIcon v-if="submitting" class="w-4 h-4 animate-spin" />
          Save Changes
        </button>
        <Link :href="route('vendor.dashboard')" class="btn-ghost text-text-muted">Cancel</Link>
      </div>
    </form>
  </DashboardLayout>
</template>

<script setup>
import { ref } from 'vue';
import { Link, router } from '@inertiajs/vue3';
import { UploadCloudIcon, LoaderIcon } from 'lucide-vue-next';
import DashboardLayout from '@/Layouts/DashboardLayout.vue';

const props = defineProps({
  vendor: { type: Object, default: null },
  errors: { type: Object, default: () => ({}) },
});

const submitting = ref(false);
const bannerPreview = ref(props.vendor?.banner ?? null);
const logoPreview   = ref(props.vendor?.logo ?? null);

const form = ref({
  store_name:  props.vendor?.store_name ?? '',
  description: props.vendor?.description ?? '',
  phone:       props.vendor?.phone ?? '',
  address:     props.vendor?.address ?? '',
  city:        props.vendor?.city ?? '',
  country:     props.vendor?.country ?? 'KE',
  banner:      null,
  logo:        null,
});

function handleBanner(e) {
  const file = e.target.files[0];
  if (!file) return;
  form.value.banner = file;
  const reader = new FileReader();
  reader.onload = ev => { bannerPreview.value = ev.target.result; };
  reader.readAsDataURL(file);
}

function handleLogo(e) {
  const file = e.target.files[0];
  if (!file) return;
  form.value.logo = file;
  const reader = new FileReader();
  reader.onload = ev => { logoPreview.value = ev.target.result; };
  reader.readAsDataURL(file);
}

function submit() {
  submitting.value = true;
  const data = new FormData();
  Object.entries(form.value).forEach(([k, v]) => { if (v !== null) data.append(k, v); });
  data.append('_method', 'PATCH');
  router.post(route('vendor.profile.update'), data, {
    forceFormData: true,
    onFinish: () => { submitting.value = false; },
  });
}

const vendorNav = [
  { label: 'Dashboard',  href: route('vendor.dashboard'),       icon: 'LayoutDashboardIcon' },
  { section: 'Store' },
  { label: 'Products',   href: route('vendor.products.index'),  icon: 'PackageIcon' },
  { label: 'Orders',     href: route('vendor.orders.index'),    icon: 'ShoppingBagIcon' },
  { section: 'Finance' },
  { label: 'Earnings',   href: route('vendor.earnings.index'),  icon: 'TrendingUpIcon' },
  { label: 'Payouts',    href: route('vendor.payouts.index'),   icon: 'BanknoteIcon' },
  { section: 'Settings' },
  { label: 'Storefront', href: route('vendor.profile.edit'),    icon: 'StoreIcon' },
];
</script>

KODA_FILE_3061766F

# --- resources/js/Pages/Vendor/Reviews.vue ---
mkdir -p "resources/js/Pages/Vendor"
cat > "resources/js/Pages/Vendor/Reviews.vue" << 'KODA_FILE_C517870C'
<template>
  <DashboardLayout :nav-items="vendorNav" page-title="Reviews" :breadcrumbs="[{ label: 'Vendor' }, { label: 'Reviews' }]">
    <!-- Summary -->
    <div class="grid grid-cols-2 sm:grid-cols-4 gap-4 mb-8">
      <div class="koda-card text-center">
        <p class="font-heading text-3xl font-bold text-accent">{{ summary.avg_rating?.toFixed(1) ?? '—' }}</p>
        <StarRating :model-value="summary.avg_rating ?? 0" class="justify-center mt-1" />
        <p class="text-xs text-text-muted mt-1">Overall Rating</p>
      </div>
      <div class="koda-card text-center">
        <p class="font-heading text-3xl font-bold text-text-primary">{{ summary.total }}</p>
        <p class="text-xs text-text-muted mt-2">Total Reviews</p>
      </div>
      <div class="koda-card text-center">
        <p class="font-heading text-3xl font-bold text-status-success">{{ summary.five_star }}</p>
        <p class="text-xs text-text-muted mt-2">5-Star Reviews</p>
      </div>
      <div class="koda-card text-center">
        <p class="font-heading text-3xl font-bold text-status-warning">{{ summary.pending }}</p>
        <p class="text-xs text-text-muted mt-2">Awaiting Approval</p>
      </div>
    </div>

    <!-- Rating breakdown -->
    <div class="koda-card mb-6">
      <h3 class="font-heading text-sm font-bold mb-4">Rating Breakdown</h3>
      <div class="space-y-2">
        <div v-for="n in [5,4,3,2,1]" :key="n" class="flex items-center gap-3">
          <div class="flex items-center gap-1 w-16 shrink-0">
            <span class="text-xs text-text-muted">{{ n }}</span>
            <StarIcon class="w-3.5 h-3.5 text-yellow-400 fill-yellow-400" />
          </div>
          <div class="flex-1 h-2 bg-bg-tertiary rounded-full overflow-hidden">
            <div
              class="h-full bg-yellow-400 rounded-full transition-all"
              :style="{ width: ratingPct(n) + '%' }"
            />
          </div>
          <span class="text-xs text-text-muted w-8 text-right shrink-0">{{ ratingCount(n) }}</span>
        </div>
      </div>
    </div>

    <!-- Reviews list -->
    <div class="space-y-3">
      <div v-for="review in reviews" :key="review.id" class="koda-card">
        <div class="flex items-start justify-between gap-4 mb-2">
          <div>
            <div class="flex items-center gap-3 mb-1">
              <p class="text-sm font-semibold text-text-primary">{{ review.user?.name }}</p>
              <span class="text-xs text-text-muted">{{ review.created_at_human }}</span>
              <span :class="review.approved ? 'badge badge-success text-xs' : 'badge badge-warning text-xs'">
                {{ review.approved ? 'Published' : 'Pending' }}
              </span>
            </div>
            <StarRating :model-value="review.rating" />
          </div>
          <Link :href="route('products.show', review.product?.slug)" class="text-xs text-accent hover:text-accent-light transition-colors shrink-0 truncate max-w-32">
            {{ review.product?.name }}
          </Link>
        </div>
        <p class="text-sm text-text-secondary leading-relaxed mt-2">{{ review.comment }}</p>
      </div>

      <div v-if="!reviews.length" class="text-center py-16 text-text-muted">
        <StarIcon class="w-12 h-12 mx-auto mb-3 text-border" />
        <p class="font-heading text-base">No reviews yet</p>
        <p class="text-sm mt-1">Reviews from buyers will appear here</p>
      </div>
    </div>

    <Pagination :links="reviewsMeta?.links ?? []" />
  </DashboardLayout>
</template>

<script setup>
import { computed } from 'vue';
import { Link } from '@inertiajs/vue3';
import { StarIcon } from 'lucide-vue-next';
import DashboardLayout from '@/Layouts/DashboardLayout.vue';
import StarRating from '@/Components/UI/StarRating.vue';
import Pagination from '@/Components/UI/Pagination.vue';

const props = defineProps({
  reviews:     { type: Array,  default: () => [] },
  reviewsMeta: { type: Object, default: null },
  summary:     { type: Object, default: () => ({ avg_rating: 0, total: 0, five_star: 0, pending: 0, breakdown: {} }) },
});

function ratingCount(n) { return props.summary.breakdown?.[n] ?? 0; }
function ratingPct(n) {
  const total = props.summary.total;
  return total > 0 ? Math.round((ratingCount(n) / total) * 100) : 0;
}

const vendorNav = [
  { label: 'Dashboard',  href: route('vendor.dashboard'),       icon: 'LayoutDashboardIcon' },
  { section: 'Store' },
  { label: 'Products',   href: route('vendor.products.index'),  icon: 'PackageIcon' },
  { label: 'Orders',     href: route('vendor.orders.index'),    icon: 'ShoppingBagIcon' },
  { label: 'Reviews',    href: route('vendor.reviews.index'),   icon: 'StarIcon' },
  { section: 'Finance' },
  { label: 'Earnings',   href: route('vendor.earnings.index'),  icon: 'TrendingUpIcon' },
  { label: 'Payouts',    href: route('vendor.payouts.index'),   icon: 'BanknoteIcon' },
  { section: 'Settings' },
  { label: 'Storefront', href: route('vendor.profile.edit'),    icon: 'StoreIcon' },
  { label: 'Settings',   href: route('vendor.settings.index'),  icon: 'SettingsIcon' },
];
</script>

KODA_FILE_C517870C

# --- resources/js/Pages/Vendor/Settings.vue ---
mkdir -p "resources/js/Pages/Vendor"
cat > "resources/js/Pages/Vendor/Settings.vue" << 'KODA_FILE_DBD7D019'
<template>
  <DashboardLayout :nav-items="vendorNav" page-title="Settings" :breadcrumbs="[{ label: 'Vendor' }, { label: 'Settings' }]">
    <div class="max-w-xl space-y-6">
      <!-- Notification preferences -->
      <div class="koda-card space-y-5">
        <h3 class="font-heading text-base font-bold">Notifications</h3>
        <div class="space-y-4">
          <label v-for="pref in notificationPrefs" :key="pref.key" class="flex items-center justify-between gap-4 cursor-pointer">
            <div>
              <p class="text-sm font-medium text-text-primary">{{ pref.label }}</p>
              <p class="text-xs text-text-muted">{{ pref.desc }}</p>
            </div>
            <div class="relative shrink-0">
              <input type="checkbox" v-model="form[pref.key]" class="sr-only peer" />
              <div class="w-10 h-5 bg-border rounded-full peer peer-checked:bg-accent transition-colors" />
              <div class="absolute top-0.5 left-0.5 w-4 h-4 bg-white rounded-full transition-transform peer-checked:translate-x-5 pointer-events-none" />
            </div>
          </label>
        </div>
      </div>

      <!-- Store visibility -->
      <div class="koda-card space-y-4">
        <h3 class="font-heading text-base font-bold">Store Visibility</h3>
        <label class="flex items-center justify-between gap-4 cursor-pointer">
          <div>
            <p class="text-sm font-medium text-text-primary">Vacation mode</p>
            <p class="text-xs text-text-muted">Hides your store temporarily. Existing orders still process.</p>
          </div>
          <div class="relative shrink-0">
            <input type="checkbox" v-model="form.vacation_mode" class="sr-only peer" />
            <div class="w-10 h-5 bg-border rounded-full peer peer-checked:bg-status-warning transition-colors" />
            <div class="absolute top-0.5 left-0.5 w-4 h-4 bg-white rounded-full transition-transform peer-checked:translate-x-5 pointer-events-none" />
          </div>
        </label>
      </div>

      <!-- Commission info -->
      <div class="koda-card bg-accent-subtle border-accent-muted">
        <div class="flex items-start gap-3">
          <InfoIcon class="w-4 h-4 text-accent shrink-0 mt-0.5" />
          <div>
            <p class="text-sm font-semibold text-accent mb-1">Commission Rate</p>
            <p class="text-xs text-text-secondary">
              Your current platform commission is <strong class="text-accent">10%</strong> per sale.
              This is automatically deducted from your earnings before payout.
              Contact support to discuss custom rates for high-volume sellers.
            </p>
          </div>
        </div>
      </div>

      <button @click="save" :disabled="saving" class="btn-primary px-8">
        <LoaderIcon v-if="saving" class="w-4 h-4 animate-spin" />
        Save Settings
      </button>
    </div>
  </DashboardLayout>
</template>

<script setup>
import { ref } from 'vue';
import { router } from '@inertiajs/vue3';
import { InfoIcon, LoaderIcon } from 'lucide-vue-next';
import DashboardLayout from '@/Layouts/DashboardLayout.vue';

const saving = ref(false);

const form = ref({
  notify_new_order:   true,
  notify_low_stock:   true,
  notify_new_review:  true,
  notify_payout:      true,
  vacation_mode:      false,
});

const notificationPrefs = [
  { key: 'notify_new_order',  label: 'New Orders',   desc: 'Email me when a new order is placed' },
  { key: 'notify_low_stock',  label: 'Low Stock',    desc: 'Alert when product stock falls below 5' },
  { key: 'notify_new_review', label: 'New Reviews',  desc: 'Email when a buyer leaves a review' },
  { key: 'notify_payout',     label: 'Payout Status', desc: 'Updates on payout processing' },
];

function save() {
  saving.value = true;
  router.post(route('vendor.settings.store'), form.value, {
    preserveScroll: true,
    onFinish: () => { saving.value = false; },
  });
}

const vendorNav = [
  { label: 'Dashboard',  href: route('vendor.dashboard'),       icon: 'LayoutDashboardIcon' },
  { section: 'Store' },
  { label: 'Products',   href: route('vendor.products.index'),  icon: 'PackageIcon' },
  { label: 'Orders',     href: route('vendor.orders.index'),    icon: 'ShoppingBagIcon' },
  { label: 'Reviews',    href: route('vendor.reviews.index'),   icon: 'StarIcon' },
  { section: 'Finance' },
  { label: 'Earnings',   href: route('vendor.earnings.index'),  icon: 'TrendingUpIcon' },
  { label: 'Payouts',    href: route('vendor.payouts.index'),   icon: 'BanknoteIcon' },
  { section: 'Settings' },
  { label: 'Storefront', href: route('vendor.profile.edit'),    icon: 'StoreIcon' },
  { label: 'Settings',   href: route('vendor.settings.index'),  icon: 'SettingsIcon' },
];
</script>

KODA_FILE_DBD7D019

# --- resources/js/app.js ---
mkdir -p "resources/js"
cat > "resources/js/app.js" << 'KODA_FILE_242AA6E9'
import './bootstrap';
import '../css/app.css';

import { createApp, h } from 'vue';
import { createInertiaApp, router } from '@inertiajs/vue3';
import { resolvePageComponent } from 'laravel-vite-plugin/inertia-helpers';
import { ZiggyVue } from '../../vendor/tightenco/ziggy';
import { createPinia } from 'pinia';

const appName = import.meta.env.VITE_APP_NAME || 'Koda';

createInertiaApp({
    title: (title) => title ? `${title} — ${appName}` : `${appName} · Your Professional Business Marketplace`,
    resolve: (name) =>
        resolvePageComponent(
            `./Pages/${name}.vue`,
            import.meta.glob('./Pages/**/*.vue')
        ),
    setup({ el, App, props, plugin }) {
        const pinia = createPinia();

        return createApp({ render: () => h(App, props) })
            .use(plugin)
            .use(ZiggyVue)
            .use(pinia)
            .mount(el);
    },
    progress: {
        color: '#f97316',
        showSpinner: true,
    },
});

KODA_FILE_242AA6E9

# --- resources/js/bootstrap.js ---
mkdir -p "resources/js"
cat > "resources/js/bootstrap.js" << 'KODA_FILE_0BE8760E'
import axios from 'axios';
window.axios = axios;
window.axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';

KODA_FILE_0BE8760E

# --- resources/js/composables/useCart.js ---
mkdir -p "resources/js/composables"
cat > "resources/js/composables/useCart.js" << 'KODA_FILE_694EC06E'
import { computed } from 'vue';
import { usePage, router } from '@inertiajs/vue3';

export function useCart() {
    const page = usePage();

    const cartCount = computed(() => page.props.cartCount ?? 0);

    function addToCart(productId, quantity = 1, options = {}) {
        return new Promise((resolve, reject) => {
            router.post(route('cart.add'), { product_id: productId, quantity }, {
                preserveScroll: true,
                onSuccess: resolve,
                onError: reject,
                ...options,
            });
        });
    }

    function removeFromCart(itemId) {
        router.delete(route('cart.remove', itemId), { preserveScroll: true });
    }

    function updateQuantity(itemId, quantity) {
        router.patch(route('cart.update', itemId), { quantity }, { preserveScroll: true });
    }

    function clearCart() {
        router.delete(route('cart.clear'), { preserveScroll: true });
    }

    return { cartCount, addToCart, removeFromCart, updateQuantity, clearCart };
}

KODA_FILE_694EC06E

# --- resources/js/composables/useFormat.js ---
mkdir -p "resources/js/composables"
cat > "resources/js/composables/useFormat.js" << 'KODA_FILE_FE36AFA8'
/**
 * Koda shared formatting helpers.
 * Import in any Vue component:
 *   import { useFormat } from '@/composables/useFormat';
 *   const { formatPrice, formatDate } = useFormat();
 */
export function useFormat(currency = 'KES', locale = 'en-KE') {
    function formatPrice(amount, opts = {}) {
        return new Intl.NumberFormat(locale, {
            style: 'currency',
            currency,
            maximumFractionDigits: 0,
            ...opts,
        }).format(amount ?? 0);
    }

    function formatDate(date, opts = { day: 'numeric', month: 'short', year: 'numeric' }) {
        if (!date) return '—';
        return new Intl.DateTimeFormat(locale, opts).format(new Date(date));
    }

    function formatRelative(date) {
        if (!date) return '—';
        const rtf = new Intl.RelativeTimeFormat(locale, { numeric: 'auto' });
        const diff = (new Date(date) - Date.now()) / 1000;
        const units = [
            { unit: 'year',   secs: 31536000 },
            { unit: 'month',  secs: 2592000  },
            { unit: 'week',   secs: 604800   },
            { unit: 'day',    secs: 86400    },
            { unit: 'hour',   secs: 3600     },
            { unit: 'minute', secs: 60       },
            { unit: 'second', secs: 1        },
        ];
        for (const { unit, secs } of units) {
            if (Math.abs(diff) >= secs) {
                return rtf.format(Math.round(diff / secs), unit);
            }
        }
        return 'just now';
    }

    function truncate(str, len = 80) {
        if (!str) return '';
        return str.length > len ? str.slice(0, len).trimEnd() + '…' : str;
    }

    function initials(name = '') {
        return name.split(' ').map(n => n[0]).slice(0, 2).join('').toUpperCase();
    }

    return { formatPrice, formatDate, formatRelative, truncate, initials };
}

KODA_FILE_FE36AFA8

# --- resources/js/composables/useWishlist.js ---
mkdir -p "resources/js/composables"
cat > "resources/js/composables/useWishlist.js" << 'KODA_FILE_649B07D5'
import { router } from '@inertiajs/vue3';

export function useWishlist() {
    function toggle(productId) {
        router.post(route('wishlist.toggle'), { product_id: productId }, { preserveScroll: true });
    }

    return { toggle };
}

KODA_FILE_649B07D5

# --- resources/js/stores/authStore.js ---
mkdir -p "resources/js/stores"
cat > "resources/js/stores/authStore.js" << 'KODA_FILE_EC2E3130'
import { defineStore } from 'pinia';
import { computed } from 'vue';
import { usePage } from '@inertiajs/vue3';

export const useAuthStore = defineStore('auth', () => {
    const page = usePage();

    const user   = computed(() => page.props.auth?.user ?? null);
    const roles  = computed(() => user.value?.roles ?? []);
    const isAuth = computed(() => !!user.value);

    const isAdmin  = computed(() => roles.value.includes('admin'));
    const isVendor = computed(() => roles.value.includes('vendor'));
    const isBuyer  = computed(() => roles.value.includes('buyer'));

    const initials = computed(() => {
        const name = user.value?.name ?? '';
        return name.split(' ').map(n => n[0]).slice(0, 2).join('').toUpperCase();
    });

    return { user, roles, isAuth, isAdmin, isVendor, isBuyer, initials };
});

KODA_FILE_EC2E3130

# --- resources/js/stores/cartStore.js ---
mkdir -p "resources/js/stores"
cat > "resources/js/stores/cartStore.js" << 'KODA_FILE_1C0FFA98'
import { defineStore } from 'pinia';
import { ref, computed } from 'vue';
import { router, usePage } from '@inertiajs/vue3';

/**
 * Thin wrapper — real cart state lives server-side and is shared via
 * HandleInertiaRequests.  This store is used for optimistic UI updates.
 */
export const useCartStore = defineStore('cart', () => {
    const page = usePage();
    const optimisticCount = ref(null);

    const cartCount = computed(() =>
        optimisticCount.value ?? page.props.cartCount ?? 0
    );

    function addItem(productId, quantity = 1) {
        optimisticCount.value = cartCount.value + quantity;
        router.post(route('cart.add'), { product_id: productId, quantity }, {
            preserveScroll: true,
            onSuccess: () => { optimisticCount.value = null; },
            onError:   () => { optimisticCount.value = null; },
        });
    }

    function removeItem(itemId) {
        optimisticCount.value = Math.max(0, cartCount.value - 1);
        router.delete(route('cart.remove', itemId), {
            preserveScroll: true,
            onFinish: () => { optimisticCount.value = null; },
        });
    }

    return { cartCount, addItem, removeItem };
});

KODA_FILE_1C0FFA98

# --- resources/views/app.blade.php ---
mkdir -p "resources/views"
cat > "resources/views/app.blade.php" << 'KODA_FILE_2D68ADD4'
<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}" class="dark">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="csrf-token" content="{{ csrf_token() }}">

    <title inertia>{{ config('app.name', 'Koda') }}</title>

    <!-- SEO -->
    <meta name="description" content="Koda — Your Professional Business Marketplace. Source. Sell. Succeed.">
    <meta property="og:type" content="website">
    <meta property="og:site_name" content="Koda">

    <!-- Favicons -->
    <link rel="icon" type="image/svg+xml" href="/favicon.svg">

    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=Inter:wght@300;400;500;600&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">

    @routes
    @vite(['resources/css/app.css', 'resources/js/app.js'])
    @inertiaHead
</head>
<body class="antialiased bg-bg-primary text-text-primary">
    @inertia
</body>
</html>

KODA_FILE_2D68ADD4

# --- routes/auth.php ---
mkdir -p "routes"
cat > "routes/auth.php" << 'KODA_FILE_D2DEB2D1'
<?php

use App\Http\Controllers\Auth\RegisteredUserController;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

// ── Registration ────────────────────────────────────
Route::middleware('guest')->group(function () {
    Route::get('register',  [RegisteredUserController::class, 'create'])->name('register');
    Route::post('register', [RegisteredUserController::class, 'store']);

    Route::get('login', fn() => Inertia::render('Auth/Login'))->name('login');
    Route::post('login', [\App\Http\Controllers\Auth\AuthenticatedSessionController::class, 'store']);

    Route::get('forgot-password', fn() => Inertia::render('Auth/ForgotPassword'))->name('password.request');
    Route::post('forgot-password', [\App\Http\Controllers\Auth\PasswordResetLinkController::class, 'store'])->name('password.email');

    Route::get('reset-password/{token}', fn($token) => Inertia::render('Auth/ResetPassword', ['token' => $token]))->name('password.reset');
    Route::post('reset-password', [\App\Http\Controllers\Auth\NewPasswordController::class, 'store'])->name('password.store');
});

Route::middleware('auth')->group(function () {
    Route::get('verify-email', fn() => Inertia::render('Auth/VerifyEmail'))->name('verification.notice');
    Route::get('verify-email/{id}/{hash}', [\App\Http\Controllers\Auth\VerifyEmailController::class, '__invoke'])
        ->middleware(['signed','throttle:6,1'])->name('verification.verify');
    Route::post('email/verification-notification', [\App\Http\Controllers\Auth\EmailVerificationNotificationController::class, 'store'])
        ->middleware('throttle:6,1')->name('verification.send');

    Route::post('logout', [\App\Http\Controllers\Auth\AuthenticatedSessionController::class, 'destroy'])->name('logout');
});

KODA_FILE_D2DEB2D1

# --- routes/console.php ---
mkdir -p "routes"
cat > "routes/console.php" << 'KODA_FILE_576071BF'
<?php

use Illuminate\Foundation\Inspiring;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Schedule;

Artisan::command('inspire', function () {
    $this->comment(Inspiring::quote());
})->purpose('Display an inspiring quote');

KODA_FILE_576071BF

# --- routes/web.php ---
mkdir -p "routes"
cat > "routes/web.php" << 'KODA_FILE_CF904F4D'
<?php

use App\Http\Controllers\Admin;
use App\Http\Controllers\Buyer;
use App\Http\Controllers\CartController;
use App\Http\Controllers\CategoryController;
use App\Http\Controllers\CheckoutController;
use App\Http\Controllers\HomeController;
use App\Http\Controllers\NotificationController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\ProfileController;
use App\Http\Controllers\ReviewController;
use App\Http\Controllers\SearchController;
use App\Http\Controllers\Vendor;
use App\Http\Controllers\VendorController;
use App\Http\Controllers\WishlistController;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

// ── Public ───────────────────────────────────────────
Route::get('/',                      [HomeController::class, 'index'])->name('home');
Route::get('/products',              [ProductController::class, 'index'])->name('products.index');
Route::get('/products/{product}',    [ProductController::class, 'show'])->name('products.show');
Route::get('/vendors',               [VendorController::class, 'index'])->name('vendors.index');
Route::get('/vendors/{vendor}',      [VendorController::class, 'show'])->name('vendors.show');
Route::get('/vendor/apply',          [VendorController::class, 'applyForm'])->name('vendor.apply');
Route::post('/vendor/apply',         [VendorController::class, 'applyStore'])->name('vendor.apply.store');
Route::get('/categories',            [CategoryController::class, 'index'])->name('categories.index');
Route::get('/categories/{category}', [CategoryController::class, 'show'])->name('categories.show');
Route::get('/search/autocomplete',   [SearchController::class, 'autocomplete'])->name('search.autocomplete');
Route::get('/about',   fn() => Inertia::render('Public/About'))->name('about');
Route::get('/contact', fn() => Inertia::render('Public/Contact'))->name('contact');
Route::get('/privacy', fn() => Inertia::render('Public/Privacy'))->name('privacy');
Route::get('/terms',   fn() => Inertia::render('Public/Terms'))->name('terms');

// ── Cart ─────────────────────────────────────────────
Route::get('/cart',           [CartController::class, 'index'])->name('cart.index');
Route::post('/cart/add',      [CartController::class, 'add'])->name('cart.add');
Route::patch('/cart/{item}',  [CartController::class, 'update'])->name('cart.update');
Route::delete('/cart/{item}', [CartController::class, 'remove'])->name('cart.remove');
Route::delete('/cart',        [CartController::class, 'clear'])->name('cart.clear');
Route::post('/cart/promo',    [CartController::class, 'applyPromo'])->name('cart.promo');

// ── Auth ─────────────────────────────────────────────
require __DIR__.'/auth.php';

// ── Authenticated ────────────────────────────────────
Route::middleware(['auth', 'verified'])->group(function () {
    Route::get('/checkout',  [CheckoutController::class, 'index'])->name('checkout.index');
    Route::post('/checkout', [CheckoutController::class, 'store'])->name('checkout.store');

    Route::get('/orders',                     [Buyer\OrderController::class, 'index'])->name('buyer.orders.index');
    Route::get('/orders/{order}',             [Buyer\OrderController::class, 'show'])->name('orders.show');
    Route::get('/order-confirmation/{order}', [Buyer\OrderConfirmationController::class, 'show'])->name('orders.confirmation');

    Route::get('/wishlist',         [WishlistController::class, 'index'])->name('buyer.wishlist.index');
    Route::post('/wishlist/toggle', [WishlistController::class, 'toggle'])->name('wishlist.toggle');

    Route::post('/reviews', [ReviewController::class, 'store'])->name('reviews.store');

    Route::get('/notifications',       [NotificationController::class, 'index'])->name('notifications.index');
    Route::post('/notifications/read', [NotificationController::class, 'markRead'])->name('notifications.read');

    Route::get('/profile',    [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile',  [ProfileController::class, 'update'])->name('profile.update');
    Route::put('/password',   [ProfileController::class, 'updatePassword'])->name('password.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');
});

// ── Vendor ───────────────────────────────────────────
Route::middleware(['auth', 'verified', 'vendor.active'])
    ->prefix('vendor')->name('vendor.')
    ->group(function () {
        Route::get('/dashboard', [Vendor\DashboardController::class, 'index'])->name('dashboard');

        Route::get('/products',                    [Vendor\ProductController::class, 'index'])->name('products.index');
        Route::get('/products/create',             [Vendor\ProductController::class, 'create'])->name('products.create');
        Route::post('/products',                   [Vendor\ProductController::class, 'store'])->name('products.store');
        Route::get('/products/{product}/edit',     [Vendor\ProductController::class, 'edit'])->name('products.edit');
        Route::put('/products/{product}',          [Vendor\ProductController::class, 'update'])->name('products.update');
        Route::patch('/products/{product}/status', [Vendor\ProductController::class, 'updateStatus'])->name('products.status');
        Route::delete('/products/{product}',       [Vendor\ProductController::class, 'destroy'])->name('products.destroy');

        Route::get('/orders',                [Vendor\OrderController::class, 'index'])->name('orders.index');
        Route::get('/orders/{order}',        [Vendor\OrderController::class, 'show'])->name('orders.show');
        Route::patch('/items/{item}/status', [Vendor\OrderController::class, 'updateItemStatus'])->name('items.status');

        Route::get('/reviews',  [Vendor\ReviewController::class,   'index'])->name('reviews.index');
        Route::get('/earnings', [Vendor\EarningsController::class,  'index'])->name('earnings.index');
        Route::get('/payouts',  [Vendor\PayoutController::class,   'index'])->name('payouts.index');
        Route::post('/payouts', [Vendor\PayoutController::class,   'store'])->name('payouts.store');
        Route::get('/profile',  [Vendor\ProfileController::class,  'edit'])->name('profile.edit');
        Route::post('/profile', [Vendor\ProfileController::class,  'update'])->name('profile.update');
        Route::get('/settings', fn() => Inertia::render('Vendor/Settings'))->name('settings.index');
        Route::post('/settings',fn() => back()->with('success','Settings saved.'))->name('settings.store');
    });

// ── Admin ────────────────────────────────────────────
Route::middleware(['auth', 'role:admin'])
    ->prefix('admin')->name('admin.')
    ->group(function () {
        Route::get('/dashboard', [Admin\DashboardController::class, 'index'])->name('dashboard');

        Route::get('/vendors',                    [Admin\VendorController::class, 'index'])->name('vendors.index');
        Route::get('/vendors/{vendor}',           [Admin\VendorController::class, 'show'])->name('vendors.show');
        Route::post('/vendors/{vendor}/approve',  [Admin\VendorController::class, 'approve'])->name('vendors.approve');
        Route::post('/vendors/{vendor}/reject',   [Admin\VendorController::class, 'reject'])->name('vendors.reject');
        Route::post('/vendors/{vendor}/suspend',  [Admin\VendorController::class, 'suspend'])->name('vendors.suspend');
        Route::patch('/vendors/{vendor}/verify',  [Admin\VendorController::class, 'toggleVerified'])->name('vendors.verify');
        Route::delete('/vendors/{vendor}',        [Admin\VendorController::class, 'destroy'])->name('vendors.destroy');

        Route::get('/products',                      [Admin\ProductController::class, 'index'])->name('products.index');
        Route::patch('/products/{product}/feature',  [Admin\ProductController::class, 'toggleFeatured'])->name('products.feature');
        Route::delete('/products/{product}',         [Admin\ProductController::class, 'destroy'])->name('products.destroy');

        Route::get('/orders',                  [Admin\OrderController::class, 'index'])->name('orders.index');
        Route::get('/orders/{order}',          [Admin\OrderController::class, 'show'])->name('orders.show');
        Route::patch('/orders/{order}/status', [Admin\OrderController::class, 'updateStatus'])->name('orders.status');

        Route::get('/categories',               [Admin\CategoryController::class, 'index'])->name('categories.index');
        Route::post('/categories',              [Admin\CategoryController::class, 'store'])->name('categories.store');
        Route::put('/categories/{category}',    [Admin\CategoryController::class, 'update'])->name('categories.update');
        Route::delete('/categories/{category}', [Admin\CategoryController::class, 'destroy'])->name('categories.destroy');

        Route::get('/reviews',                    [Admin\ReviewController::class, 'index'])->name('reviews.index');
        Route::patch('/reviews/{review}/approve', [Admin\ReviewController::class, 'approve'])->name('reviews.approve');
        Route::delete('/reviews/{review}',        [Admin\ReviewController::class, 'destroy'])->name('reviews.destroy');

        Route::get('/buyers', [Admin\BuyerController::class, 'index'])->name('buyers.index');

        Route::get('/payouts',              [Admin\PayoutController::class, 'index'])->name('payouts.index');
        Route::patch('/payouts/{id}',       [Admin\PayoutController::class, 'update'])->name('payouts.update');

        Route::get('/promos',            [Admin\PromoController::class, 'index'])->name('promos.index');
        Route::post('/promos',           [Admin\PromoController::class, 'store'])->name('promos.store');
        Route::delete('/promos/{promo}', [Admin\PromoController::class, 'destroy'])->name('promos.destroy');

        Route::get('/settings',  [Admin\SettingsController::class, 'index'])->name('settings.index');
        Route::post('/settings', [Admin\SettingsController::class, 'store'])->name('settings.store');
    });

KODA_FILE_CF904F4D

# --- tailwind.config.js ---
mkdir -p "."
cat > "tailwind.config.js" << 'KODA_FILE_DB9703BF'
/** @type {import('tailwindcss').Config} */
export default {
    content: [
        './vendor/laravel/framework/src/Illuminate/Pagination/resources/views/*.blade.php',
        './storage/framework/views/*.php',
        './resources/views/**/*.blade.php',
        './resources/js/**/*.vue',
        './resources/js/**/*.js',
    ],
    theme: {
        extend: {
            colors: {
                // Koda Design System
                bg: {
                    primary:   '#0a0a0a',
                    secondary: '#111111',
                    tertiary:  '#1a1a1a',
                    card:      '#141414',
                    input:     '#1e1e1e',
                },
                accent: {
                    DEFAULT: '#f97316',
                    hover:   '#ea6c0a',
                    light:   '#fb923c',
                    muted:   '#7c3f12',
                    subtle:  '#1c0f07',
                },
                text: {
                    primary:   '#ffffff',
                    secondary: '#a3a3a3',
                    muted:     '#6b6b6b',
                    inverse:   '#0a0a0a',
                },
                border: {
                    DEFAULT: '#262626',
                    light:   '#333333',
                    focus:   '#f97316',
                },
                status: {
                    success: '#22c55e',
                    warning: '#eab308',
                    error:   '#ef4444',
                    info:    '#3b82f6',
                },
            },
            fontFamily: {
                heading: ['"Space Grotesk"', 'sans-serif'],
                body:    ['"Inter"', 'sans-serif'],
                mono:    ['"JetBrains Mono"', 'monospace'],
            },
            fontSize: {
                '2xs': ['0.625rem', { lineHeight: '1rem' }],
            },
            borderRadius: {
                card: '12px',
                btn:  '8px',
                xl2: '16px',
            },
            spacing: {
                18: '4.5rem',
                22: '5.5rem',
                88: '22rem',
                128: '32rem',
            },
            boxShadow: {
                glow:       '0 0 24px rgba(249,115,22,0.15)',
                'glow-lg':  '0 0 40px rgba(249,115,22,0.2)',
                card:       '0 4px 24px rgba(0,0,0,0.4)',
                'card-hover': '0 8px 40px rgba(0,0,0,0.6)',
            },
            backgroundImage: {
                'gradient-radial': 'radial-gradient(var(--tw-gradient-stops))',
                'gradient-conic':  'conic-gradient(from 180deg at 50% 50%, var(--tw-gradient-stops))',
                'accent-gradient': 'linear-gradient(135deg, #f97316 0%, #ea580c 100%)',
                'dark-gradient':   'linear-gradient(180deg, #111111 0%, #0a0a0a 100%)',
                'hero-gradient':   'radial-gradient(ellipse 80% 60% at 50% -10%, rgba(249,115,22,0.12) 0%, transparent 70%)',
            },
            keyframes: {
                'fade-in': {
                    '0%':   { opacity: '0', transform: 'translateY(8px)' },
                    '100%': { opacity: '1', transform: 'translateY(0)' },
                },
                'slide-in-right': {
                    '0%':   { transform: 'translateX(100%)' },
                    '100%': { transform: 'translateX(0)' },
                },
                'slide-out-right': {
                    '0%':   { transform: 'translateX(0)' },
                    '100%': { transform: 'translateX(100%)' },
                },
                shimmer: {
                    '0%':   { backgroundPosition: '-200% 0' },
                    '100%': { backgroundPosition: '200% 0' },
                },
                pulse: {
                    '0%, 100%': { opacity: '1' },
                    '50%':      { opacity: '0.5' },
                },
            },
            animation: {
                'fade-in':        'fade-in 0.3s ease-out',
                'slide-in-right': 'slide-in-right 0.3s ease-out',
                'slide-out-right':'slide-out-right 0.3s ease-out',
                shimmer:          'shimmer 2s linear infinite',
            },
        },
    },
    plugins: [],
};

KODA_FILE_DB9703BF

# --- vite.config.js ---
mkdir -p "."
cat > "vite.config.js" << 'KODA_FILE_E671B73A'
import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';
import vue from '@vitejs/plugin-vue';

export default defineConfig({
    plugins: [
        laravel({
            input: 'resources/js/app.js',
            refresh: true,
        }),
        vue({
            template: {
                transformAssetUrls: {
                    base: null,
                    includeAbsolute: false,
                },
            },
        }),
    ],
    resolve: {
        alias: {
            '@': '/resources/js',
        },
    },
});

KODA_FILE_E671B73A

# --- Create required storage directories ---
mkdir -p storage/logs
mkdir -p storage/framework/cache/data
mkdir -p storage/framework/sessions
mkdir -p storage/framework/views
mkdir -p storage/framework/testing
mkdir -p bootstrap/cache
mkdir -p storage/app/public

touch storage/logs/.gitkeep
touch storage/framework/cache/data/.gitkeep
touch storage/framework/sessions/.gitkeep
touch storage/framework/views/.gitkeep
touch bootstrap/cache/.gitkeep

# --- Make artisan executable ---
chmod +x artisan

echo ""
echo "✅ All files created successfully!"
echo ""
echo "Next steps:"
echo "  1. cd koda"
echo "  2. composer install"
echo "  3. npm install"
echo "  4. cp .env.example .env"
echo "  5. php artisan key:generate"
echo "  6. Edit .env with your DB credentials"
echo "  7. php artisan migrate --seed"
echo "  8. php artisan storage:link"
echo "  9. npm run dev   (terminal 1)"
echo " 10. php artisan serve   (terminal 2)"
echo ""
echo "Login: admin@koda.com / password"