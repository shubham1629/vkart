import { Injectable } from '@angular/core';
import { User } from '@modules/customer/core';
import { UserQueries } from 'src/core/constant/db';
import { DBService } from '../db.service';

@Injectable({
  providedIn: 'root'
})
export class UserDBService {

  private userdb: User[] = [];

  constructor(private db: DBService) {
    if(db.isIPCON) {
      for (const obj of Object.values(UserQueries)) {
        db.storePreparedStmt(obj.key, obj.query, obj.type);
      }
    }
  }

  insert(user: User): boolean {

    // ${UserField.FIRST_NAME}, ${UserField.LAST_NAME}, ${UserField.CONTACT_NUMBER},
    //     ${UserField.EMAIL}, ${UserField.STATUS}, ${UserField.CREATED_ON}, ${UserField.CREATED_BY},
    //     ${UserField.PROFILE_PIC}, ${UserField.ADDRESS_ID})
    if(this.db.isIPCON) {
      const userParams = [user.firstName, user.lastName, user.contactNumber, 
        user.email, user.status, user.createdOn.toISOString(), user.createdBy, null, null];
      let id = this.db.callPreparedStmt(UserQueries.INSERT.key, userParams);
      return true;
    } else {
      user.id = this.userdb.length + 1;
      this.userdb.push(user);
      return true;
    }
  }

  findById(id: number): User[] {
    if(this.db.isIPCON) {
      return this.db.callPreparedStmt(UserQueries.SELECT_BY_ID.key, [id]);
    } else {
      return this.userdb.filter(u => u.id === id);
    }
  }

  findAll(): User[] {
    if(this.db.isIPCON) {
      return this.db.callPreparedStmt(UserQueries.SELECT_ALL.key, []);
    } else {
      return this.userdb;
    }
  }

  totalUsers(): number {
    if(this.db.isIPCON) {
      return this.db.callPreparedStmt(UserQueries.COUNT_ALL.key, [])[0].count;
    } else {
      return this.userdb.length;
    }
  }

}
