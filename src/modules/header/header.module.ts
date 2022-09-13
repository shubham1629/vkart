import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MainComponent } from './main/main.component';
import { HeaderRoutingModule } from './header-routing.module';
import { NavComponent } from './ui/components/nav/nav.component';



@NgModule({
  declarations: [
    MainComponent,
    NavComponent
  ],
  imports: [
    CommonModule,
    HeaderRoutingModule
  ],
  exports: [
    MainComponent
  ]
})
export class HeaderModule { }
