import { NavConfig } from "src/models/header";

export const nav: NavConfig = {
    items: [
        {
            symbol: "📈",
            title: "Dashboard",
            route: "dashboard"
        },
        {
            symbol: "📦",
            title: "Orders",
            route: "orders"
        },
        {
            symbol: "💰",
            title: "Expense",
            route: "expense"
        },
        {
            symbol: "📊",
            title: "Stock",
            route: "stock"
        },
        {
            symbol: "👨",
            title: "customer",
            route: "customer"
        }
    ]
}