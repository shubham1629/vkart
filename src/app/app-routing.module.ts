import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

const routes: Routes = [
  {
    path: "",
    redirectTo: "dashboard",
    pathMatch: "full"
  },
  {
    path: "dashboard",
    loadChildren: () => import("@modules").then(m=>m.DashboardModule)
  },
  {
    path: "orders",
    loadChildren: () => import("@modules").then(m=>m.OrdersModule)
  },
  {
    path: "expense",
    loadChildren: () => import("@modules").then(m=>m.ExpenseModule)
  },
  {
    path: "stock",
    loadChildren: () => import("@modules").then(m=>m.StockModule)
  },
  {
    path: "customer",
    loadChildren: () => import("@modules").then(m=>m.CustomerModule)
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
