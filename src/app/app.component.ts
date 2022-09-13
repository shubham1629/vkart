import { Component } from '@angular/core';
import { ipcMain } from 'electron';

import { ElectronService } from 'ngx-electron';
import { Database } from 'sqlite3';
import { DBService } from 'src/core/services/db/db.service';



@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {
  title = 'vkart-app';
  constructor(private ele: ElectronService) {
    
  }

  run(query: string): any {
    // return this.db.select(query);
  }
}
