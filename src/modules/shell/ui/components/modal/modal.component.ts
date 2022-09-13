import { Component, Input, OnInit, TemplateRef } from '@angular/core';
import { ModalService } from '@modules/shell/core';

import { faClose } from '@fortawesome/free-solid-svg-icons';

@Component({
  selector: 'app-shell-simple-modal',
  templateUrl: './modal.component.html',
  styleUrls: ['./modal.component.scss', '../../style/modal.style.scss'],
  animations: []
})
export class ModalComponent implements OnInit {

  @Input() id: number = -1;
  @Input() header: TemplateRef<any> | string | null = null;
  @Input() footer: TemplateRef<any> | string | null = null;
  @Input() hideCrossBtn = false;

  closeIcon = faClose;


  closeClass = "close";

  constructor(private modalService: ModalService) { }

  ngOnInit(): void {
  }

  close() {
    this.modalService.remove(this.id);
  }

}
