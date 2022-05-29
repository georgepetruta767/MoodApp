import { Component, OnInit } from '@angular/core';
import {Subscription} from 'rxjs';
import {Router} from '@angular/router';
import {AlertController} from '@ionic/angular';

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
      const page = this.router.url.slice(1, this.router.url.length);
      switch(page) {
        case 'event':
          this.activePage = 'Add Event';
          break;
        case 'calendar':
          this.activePage = 'Events';
          break;
        case 'people':
          this.activePage = 'People';
          break;
        case 'results':
          this.activePage = 'Results';
          break;
        case 'list':
          this.activePage = 'List';
          break;
        default:
          this.activePage = 'Edit event';
          break;
      }
    });
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
