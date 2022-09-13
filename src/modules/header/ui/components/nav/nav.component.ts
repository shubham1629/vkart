import { Component, Input, OnInit } from '@angular/core';
import { NavItemConfig } from 'src/models/header';

@Component({
  selector: 'app-header-nav',
  templateUrl: './nav.component.html',
  styleUrls: ['./nav.component.scss']
})
export class NavComponent implements OnInit {

  @Input() items: NavItemConfig[] = [];

  constructor() { }

  ngOnInit(): void {
  }

}
