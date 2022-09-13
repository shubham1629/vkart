import { Component, OnInit } from '@angular/core';
import { nav } from 'src/config/header';
import { NavConfig } from 'src/models/header';

@Component({
  selector: 'app-header-main',
  templateUrl: './main.component.html',
  styleUrls: ['./main.component.scss']
})
export class MainComponent implements OnInit {

  config: NavConfig = nav;

  constructor() { }

  ngOnInit(): void {
    
  }

}
