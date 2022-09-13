import { Injectable, OnDestroy } from '@angular/core';
import { UserQueries } from 'src/core/constant/db';

@Injectable({
  providedIn: 'root'
})
export class DBService implements OnDestroy {
  private _ipc: any;

  private _isIPCON = false;

  get isIPCON(): boolean {
    return this._isIPCON;
  }

  constructor() {
    if (window.require) {
      this._ipc = window.require('electron').ipcRenderer;
      this._isIPCON = true;
    } else {
      this._isIPCON = false;
    }


  }

  ngOnDestroy(): void {
    if (this.isIPCON) {
      this._ipc.sendSync("close-db");
    }
  }

  storePreparedStmt(key: string, query: string, type: string) {
    if (this.isIPCON) {
      return this._ipc.sendSync("store-prerpare-stmt", key, query, type);
    }
  }

  callPreparedStmt(key: string, params: any[]): any {
    if (this.isIPCON) {
      return this._ipc.sendSync("call-prerpare-stmt", key, params);
    }
  }
}
