import { Injectable } from '@angular/core';
import { NotificationConfig } from '@modules/shell/core';
import { ModalConfig } from '../../model/modal';

@Injectable({
  providedIn: 'root'
})
export class ModalService {

  private currentId = 1;

  private modals : ModalConfig[] = [];

  private doAnimate: boolean = true;
  private animateDuration = 2000;
  private closeAnimationClass = " close-animation";
  private wrapperClasses = "";

  constructor() { }

  open(config: ModalConfig) {
    config.id = this.currentId++;
    this.modals.push(config);
    return config.id;
  }

  remove(id: number) {
    if(this.modals.length > 0) {
      let config: ModalConfig = this.modals[0];
      let i = -1;
      this.modals.forEach((val, index) => {config = val; i = index});
      if(i != -1) {
        if(this.doAnimate){
          this.wrapperClasses += this.closeAnimationClass;
          setTimeout(()=>this.modals.splice(i,1), this.animateDuration);
        }else{
          this.modals.splice(i,1);
        }
      }
    }
  }
}
