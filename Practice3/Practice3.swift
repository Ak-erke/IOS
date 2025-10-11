import Foundation

// MARK: - Product

struct Product {
    let id: String
    let name: String
    let price: Double
    let category: Category
    let description: String
    var stockQuantity: Int  // наличие на складе

    enum Category: CaseIterable {
        case electronics, clothing, food, books
    }

    var displayPrice: String {
        String(format: "%.2f", price)
    }

}


// MARK: - CartItem

struct CartItem: CustomStringConvertible {
    var product: Product
    private(set) var quantity: Int

    var subtotal: Double {
        product.price * Double(quantity)
    }

    mutating func updateQuantity(_ newQuantity: Int) {
        guard newQuantity >= 0 else {
            print("Quantity cannot be negative")
            return
        }
        // Check stock
        if newQuantity <= product.stockQuantity {
            quantity = newQuantity
        } else {
            print("Not enough stock for \(product.name). Requested: \(newQuantity), available: \(product.stockQuantity)")
        }
    }

    mutating func increaseQuantity(by amount: Int) {
        guard amount > 0 else {
            print("Increase amount must be positive")
            return
        }
        let newQuantity = quantity + amount
        if newQuantity <= product.stockQuantity {
            quantity = newQuantity
        } else {
            print("Not enough stock for \(product.name). Requested total: \(newQuantity), available: \(product.stockQuantity)")
        }
    }

    var description: String {
        "\(product.name) x\(quantity) = $\(String(format: "%.2f", subtotal))"
    }
}


// MARK: - Discount System

enum DiscountType {
    case percentage(Double)           // percent as 10.0 for 10%
    case fixedAmount(Double)          // fixed amount off
    case buyXGetY(buy: Int, get: Int) // buy X get Y free
}


// MARK: - ShoppingCart

final class ShoppingCart {
    private(set) var items: [CartItem] = []
    var discount: DiscountType?

    init() {}

    /// Add item to cart. Returns true if added/updated successfully, false otherwise.
    @discardableResult
    func addItem(_ product: Product, quantity: Int = 1) -> Bool {
        guard quantity > 0 else {
            print("Quantity must be > 0")
            return false
        }
        guard product.stockQuantity >= quantity else {
            print("Not enough stock for \(product.name). Requested: \(quantity), available: \(product.stockQuantity)")
            return false
        }

        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            // increase existing entry but respect stock (we compare against product.stockQuantity)
            items[index].increaseQuantity(by: quantity)
        } else {
            let newItem = CartItem(product: product, quantity: quantity)
            items.append(newItem)
        }
        return true
    }

    func removeItem(productId: String) {
        items.removeAll { $0.product.id == productId }
    }

    func updateItemQuantity(productId: String, quantity: Int) {
        guard let index = items.firstIndex(where: { $0.product.id == productId }) else { return }
        if quantity <= 0 {
            removeItem(productId: productId)
        } else {
            items[index].updateQuantity(quantity)
        }
    }

    func clearCart() {
        items.removeAll()
    }

    var subtotal: Double {
        items.reduce(0) { $0 + $1.subtotal }
    }

    // discount calculation
    var discountAmount: Double {
        guard let discount = discount else { return 0.0 }

        switch discount {
        case .percentage(let percent):
            return subtotal * percent / 100.0
        case .fixedAmount(let amount):
            return min(amount, subtotal)
        case .buyXGetY(let buy, let get):
            guard buy > 0 && get > 0 else { return 0.0 }
            //
            var singleUnits: [Double] = []
            for item in items {
                for _ in 0..<item.quantity {
                    singleUnits.append(item.product.price)
                }
            }
            if singleUnits.isEmpty { return 0.0 }
            singleUnits.sort() // ascending
            let groupSize = buy + get
            let freeCount = (singleUnits.count / groupSize) * get
            guard freeCount > 0 else { return 0.0 }
            
            let freeValue = singleUnits.prefix(freeCount).reduce(0.0, +)
            return freeValue
        }
    }

    var total: Double {
        max(0.0, subtotal - discountAmount)
    }

    var itemCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }

    var isEmpty: Bool {
        items.isEmpty
    }

    /// Human-readable summary
    var cartSummary: String {
        var lines: [String] = []
        lines.append("Cart Summary")
        if items.isEmpty {
            lines.append(" (empty)")
        } else {
            for item in items {
                lines.append(" - \(item.description)")
            }
            lines.append(String(format: "Subtotal: $%.2f", subtotal))
            lines.append(String(format: "Discount: $%.2f", discountAmount))
            lines.append(String(format: "Total: $%.2f", total))
            lines.append("Item count: \(itemCount)")
        }
        return lines.joined(separator: "\n")
    }


    func checkout(shippingAddress: Address) -> Order {
        // Optionally reduce stock inside each cart item copy (local copies only)
        for i in items.indices {
            // reduce product.stockQuantity by purchased quantity (on the cart's copy)
            items[i].product.stockQuantity = max(0, items[i].product.stockQuantity - items[i].quantity)
        }
        let order = Order(from: self, shippingAddress: shippingAddress)
        clearCart()
        return order
    }
}


// MARK: - Address

struct Address {
    var street: String
    var city: String
    var zipCode: String
    var country: String

    var formattedAddress: String {
        """
        \(street)
        \(city), \(zipCode)
        \(country)
        """
    }
}


// MARK: - Order

struct Order: CustomStringConvertible {
    let orderId: String
    let items: [CartItem]
    let subtotal: Double
    let discountAmount: Double
    let total: Double
    let timestamp: Date
    let shippingAddress: Address

    init(from cart: ShoppingCart, shippingAddress: Address) {
        self.orderId = UUID().uuidString
        self.items = cart.items
        self.subtotal = cart.subtotal
        self.discountAmount = cart.discountAmount
        self.total = cart.total
        self.timestamp = Date()
        self.shippingAddress = shippingAddress
    }

    var itemCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }

    var description: String {
        var lines: [String] = []
        lines.append("Order \(orderId) — \(timestamp)")
        lines.append("Items (\(itemCount)):")
        for item in items {
            lines.append(" • \(item.description)")
        }
        lines.append(String(format: "Subtotal: $%.2f", subtotal))
        lines.append(String(format: "Discount: $%.2f", discountAmount))
        lines.append(String(format: "Total: $%.2f", total))
        lines.append("Ship to:")
        lines.append(shippingAddress.formattedAddress)
        return lines.joined(separator: "\n")
    }
}


// MARK: - Bonus 1: User

final class User {
    let userId: String
    let name: String
    let email: String
    private(set) var orderHistory: [Order] = []

    init(name: String, email: String) {
        self.userId = UUID().uuidString
        self.name = name
        self.email = email
    }

    func placeOrder(_ order: Order) {
        orderHistory.append(order)
        print("🧾 Order \(order.orderId) placed successfully by \(name).")
    }

    var totalSpent: Double {
        orderHistory.reduce(0) { $0 + $1.total }
    }

    func printOrderHistory() {
        guard !orderHistory.isEmpty else {
            print("📭 \(name) has no orders yet.")
            return
        }
        print("📜 Order history for \(name):")
        for order in orderHistory {
            print("- \(order.orderId): $\(String(format: "%.2f", order.total)) @ \(order.timestamp)")
        }
    }
}


// Part 4 Testing

// test scenarios + bonus checks.

// 1. Create sample products
var laptop = Product(id: "P001", name: "MacBook Air M3", price: 1200.00, category: .electronics, description: "Lightweight and powerful laptop", stockQuantity: 5)
var book = Product(id: "P002", name: "Swift Programming Guide", price: 45.99, category: .books, description: "Learn Swift step by step", stockQuantity: 10)
var headphones = Product(id: "P003", name: "Sony WH-1000XM5", price: 299.99, category: .electronics, description: "Noise cancelling", stockQuantity: 3)

// 2. Test adding items to cart
let cart = ShoppingCart()
cart.addItem(laptop, quantity: 1)
cart.addItem(book, quantity: 2)

// 3. Test adding same product twice (should update quantity)
cart.addItem(laptop, quantity: 1)
// Verify laptop quantity is now 2
if let idx = cart.items.firstIndex(where: { $0.product.id == laptop.id }) {
    print("✅ Laptop quantity (expected 2): \(cart.items[idx].quantity)")
} else {
    print("❌ Laptop not found in cart")
}

// 4. Test cart calculations
print(String(format: "Subtotal: $%.2f", cart.subtotal))
print("Item count: \(cart.itemCount)")

// 5. Test discount code (percentage)
cart.discount = .percentage(10)
print(String(format: "Total with 10%% discount: $%.2f (discount: $%.2f)", cart.total, cart.discountAmount))

// 6. Test removing items
cart.removeItem(productId: book.id)
print("After removing book — item count: \(cart.itemCount)")

// 7. Demonstrate REFERENCE TYPE behavior
@MainActor
func modifyCart(_ cart: ShoppingCart) {
    _ = cart.addItem(headphones, quantity: 1)
}
modifyCart(cart)
print("After modifyCart(), cart item count: \(cart.itemCount) — (original cart modified = reference type)")

// 8. Demonstrate VALUE TYPE behavior
let item1 = CartItem(product: laptop, quantity: 1)
var item2 = item1
item2.updateQuantity(5)
print("item1.quantity = \(item1.quantity), item2.quantity = \(item2.quantity) — (value type: original unchanged)")

// 9. Create order from cart (use checkout to also clear cart)
let shippingAddress = Address(street: "ул. Абая, 45", city: "Алматы", zipCode: "050000", country: "Kazakhstan")
let order = cart.checkout(shippingAddress: shippingAddress) // this clears the cart
print("\n✅ Order created:")
print(order.description)

// 10. Modify cart after order creation
print("\nAfter checkout cart count (expected 0): \(cart.itemCount)")
print("Order items count (expected >0): \(order.itemCount)")

// Bonus: user places order
let user = User(name: "Akerke Amirtay", email: "akerke@example.com")
user.placeOrder(order)
print("User total spent: $\(String(format: "%.2f", user.totalSpent))")
user.printOrderHistory()

// Bonus: Advanced discount - buyXGetY
let promoCart = ShoppingCart()
let cheap = Product(id: "P010", name: "Sticker", price: 1.0, category: .books, description: "Promo sticker", stockQuantity: 10)
let mid = Product(id: "P011", name: "Notebook", price: 5.0, category: .books, description: "Small notebook", stockQuantity: 10)
promoCart.addItem(cheap, quantity: 3)
promoCart.addItem(mid, quantity: 2)
// Buy 2 get 1 free -> groupSize = 3 -> with 5 items -> freeItems = (5 / 3) *1 =1 free cheapest ($1)
promoCart.discount = .buyXGetY(buy: 2, get: 1)
print("\nPromo cart subtotal: $\(String(format: "%.2f", promoCart.subtotal))")
print("Promo discount (buy2get1): $\(String(format: "%.2f", promoCart.discountAmount))")
print("Promo total: $\(String(format: "%.2f", promoCart.total))")

// Bonus: Inventory check (attempt to add more than stock)
let limited = Product(id: "P020", name: "Limited Edition", price: 99.99, category: .books, description: "Rare", stockQuantity: 1)
let success = promoCart.addItem(limited, quantity: 2)
print("\nAttempted to add 2 limited items (stock 1). Success? \(success)")

