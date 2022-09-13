import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MainComponent } from './main/main.component';
import { ModalComponent } from './ui/components/modal/modal.component';
import { ModalService } from './core';
import { NotificationService } from './core/services/toast/toast.service';
import { FontAwesomeModule } from '@fortawesome/angular-fontawesome';



@NgModule({
  declarations: [
    MainComponent,
    ModalComponent
  ],
  imports: [
    CommonModule,
    FontAwesomeModule
  ],
  providers: [
    ModalService,
    NotificationService
  ],
  exports: [
    MainComponent
  ]
})
export class ShellModule { }
