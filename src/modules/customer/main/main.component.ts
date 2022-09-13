import { Component, OnInit } from '@angular/core';
import { UserDBService } from '@app/services';
import { User } from '@modules/customer/core';

@Component({
  selector: 'app-customer-main',
  templateUrl: './main.component.html',
  styleUrls: ['./main.component.scss']
})
export class MainComponent implements OnInit {

  users: User[] = [];
  count = 0;

  constructor(private userService: UserDBService) { }

  ngOnInit(): void {
    this.count = this.userService.totalUsers();
    this.users = this.userService.findAll();
    console.log(this.users);
    
  }

  insert() {
    let user: User = {
      id : 1, 
      firstName: "admin",
      lastName: "admin",
      contactNumber: "23242",
      email: "23435@gmail.com",
      status: "0",
      createdOn: new Date(),
      createdBy: 0,
      updatedBy: new Date(),
      updatedOn: 0,
      profilePicURL: "url",
      pincode: "1234",
      fullAddress: "address"
    };
    this.userService.insert(user);
  }

}
