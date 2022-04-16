import { Component, OnInit } from '@angular/core';
import {Subscription} from "rxjs";
import {Router} from "@angular/router";
import {AlertController} from "@ionic/angular";

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.page.html',
  styleUrls: ['./dashboard.page.scss'],
})
export class DashboardPage implements OnInit {
  public activePage!: string;

  public pageChangeSubscription = new Subscription();

  constructor(private router: Router,
              private alertController: AlertController) { }

  ngOnInit() {
    this.pageChangeSubscription = this.router.events.subscribe(() => {
      let page = this.router.url.slice(1, this.router.url.length);
      this.activePage = page.charAt(0).toUpperCase() + page.slice(1);;
    })
  }

  public async logout() {
    const alert = await this.alertController.create({
      cssClass: 'my-custom-class',
      header: 'Alert',
      message: `Are you sure you want to log out?`,
      buttons: [{
        text: 'Yes',
        handler: async () => {
          await this.router.navigateByUrl('login');
        }
      },
        'Cancel']
    });

    await alert.present();
  }
}
