import { Injectable } from '@angular/core';
import { NotificationConfig } from '@modules/shell/core';

@Injectable({
  providedIn: 'root'
})
export class NotificationService {
  private currentId = 1;

  private notifications : NotificationConfig[] = [];

  private doAnimate: boolean = true;
  private animateDuration = 2000;
  private closeAnimationClass = " close-animation";
  private wrapperClass = "";

  constructor() { }

  notify(config: NotificationConfig) {
    config.id = this.currentId++;
    this.notifications.push(config);
    if(config.autoCloseTimer) {
      setTimeout(()=> this.remove(config.id), config.autoCloseTimer);
    }
    if(config.classes)
      this.wrapperClass = config.classes;
    return config.id;
  }

  remove(id: number) {
    if(this.notifications.length > 0) {
      let config: NotificationConfig = this.notifications[0];
      let i = -1;
      this.notifications.forEach((val, index) => {config = val; i = index});
      if(i != -1) {
        if(this.doAnimate){
          this.wrapperClass += this.closeAnimationClass
          setTimeout(()=>this.notifications.splice(i,1), this.animateDuration);
        }else{
          this.notifications.splice(i,1);
        }
      }
    }
  }

}
