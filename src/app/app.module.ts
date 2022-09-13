import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
 
import { NgxElectronModule } from 'ngx-electron';
import { HeaderModule, ShellModule } from '@modules';
import { DBService, UserDBService } from '@app/services';

@NgModule({
  declarations: [
    AppComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    NgxElectronModule,
    HeaderModule,
    ShellModule
  ],
  providers: [
    DBService,
    UserDBService
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
