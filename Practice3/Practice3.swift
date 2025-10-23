import Foundation

// MARK: - Product
struct Product {
    let id: String
    let name: String
    let price: Double
    let category: Category
    let description: String
    
    enum Category {
        case electronics, clothing, food, books
    }
    
    var displayPrice: String {
        String(format: "$%.2f", price)
    }
    
    init(id: String, name: String, price: Double, category: Category, description: String) {
        self.id = id
        self.name = name
        self.price = price > 0 ? price : 0.0
        self.category = category
        self.description = description
    }
}

// MARK: - CartItem
struct CartItem {
    var product: Product
    var quantity: Int
    
    var subtotal: Double {
        product.price * Double(quantity)
    }
    
    mutating func updateQuantity(_ newQuantity: Int) {
        if newQuantity > 0 {
            quantity = newQuantity
        }
    }
    
    mutating func increaseQuantity(by amount: Int) {
        if amount > 0 {
            quantity += amount
        }
    }
}

// MARK: - ShoppingCart
class ShoppingCart {
    private(set) var items: [CartItem] = []
    var discountCode: String?
    
    func addItem(product: Product, quantity: Int = 1) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            items[index].increaseQuantity(by: quantity)
        } else {
            items.append(CartItem(product: product, quantity: quantity))
        }
    }
    
    func removeItem(productId: String) {
        items.removeAll { $0.product.id == productId }
    }
    
    func updateItemQuantity(productId: String, quantity: Int) {
        if let index = items.firstIndex(where: { $0.product.id == productId }) {
            if quantity <= 0 {
                removeItem(productId: productId)
            } else {
                items[index].updateQuantity(quantity)
            }
        }
    }
    
    func clearCart() {
        items.removeAll()
    }
    
    var subtotal: Double {
        items.reduce(0) { $0 + $1.subtotal }
    }
    
    var discountAmount: Double {
        guard let code = discountCode else { return 0 }
        switch code {
        case "SAVE10": return subtotal * 0.1
        case "SAVE20": return subtotal * 0.2
        default: return 0
        }
    }
    
    var total: Double {
        subtotal - discountAmount
    }
    
    var itemCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }
    
    var isEmpty: Bool {
        items.isEmpty
    }
}

// MARK: - Address
struct Address {
    var street: String
    var city: String
    var zipCode: String
    var country: String
    
    var formattedAddress: String {
        "\(street)\n\(city), \(zipCode)\n\(country)"
    }
}

// MARK: - Order
struct Order {
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
}

// MARK: - Test Scenarios

// 1. Create sample products
let laptop = Product(id: "1", name: "Laptop", price: 1200, category: .electronics, description: "Powerful laptop")
let book = Product(id: "2", name: "Swift Book", price: 40, category: .books, description: "Learn Swift")
let headphones = Product(id: "3", name: "Headphones", price: 100, category: .electronics, description: "Noise cancelling")

// 2. Create cart and add items
let cart = ShoppingCart()
cart.addItem(product: laptop, quantity: 1)
cart.addItem(product: book, quantity: 2)

// 3. Add same product again
cart.addItem(product: laptop, quantity: 1) // laptop qty should now be 2

// 4. Print info (in Russian)
print("🛍 Промежуточная сумма:", cart.subtotal)
print("📦 Количество товаров в корзине:", cart.itemCount)

// 5. Apply discount
cart.discountCode = "SAVE10"
print("💰 Итоговая сумма со скидкой:", cart.total)

// 6. Remove item
cart.removeItem(productId: book.id)
print("🗑 Количество товаров после удаления книги:", cart.items.count)

// 7. Reference type behavior
func modifyCart(_ c: ShoppingCart) {
    c.addItem(product: headphones, quantity: 1)
}
modifyCart(cart)
print("🧠 После вызова modifyCart():", cart.items.count, "товара(ов)") // changed!

// 8. Value type behavior
var item1 = CartItem(product: laptop, quantity: 1)
var item2 = item1
item2.updateQuantity(5)
print("🔹 Количество item1:", item1.quantity) // still 1
print("🔹 Количество item2:", item2.quantity) // changed to 5

// 9. Create order
let address = Address(street: "ул. Абая 12", city: "Алматы", zipCode: "050000", country: "Казахстан")
let order = Order(from: cart, shippingAddress: address)

// 10. Clear cart
cart.clearCart()

print("📦 Количество товаров в заказе:", order.itemCount) // not affected
print("🛒 Количество товаров в корзине:", cart.itemCount)   // now 0
print("📍 Адрес доставки:\n\(address.formattedAddress)")
