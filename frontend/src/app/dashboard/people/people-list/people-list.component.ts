import { Component, EventEmitter, OnInit } from '@angular/core';
import {PersonModel} from "../../common/models/person.model";
import {PeopleService} from "../../common/services/people.service";
import {IonRouterOutlet, ModalController} from "@ionic/angular";
import {PeopleAddComponent} from "../people-add/people-add.component";

@Component({
  selector: 'app-people',
  templateUrl: './people-list.component.html',
  styleUrls: ['./people-list.component.scss'],
})
export class PeopleListComponent implements OnInit {
  public people: Array<PersonModel>;

  public closeModalEmitter = new EventEmitter();

  constructor(private peopleService: PeopleService,
              private modalController: ModalController) { }

  ngOnInit() {
    this.loadPeople();
    this.handleCloseModalEvent();
  }

  public async presentModal() {
    const modal = await this.modalController.create({
      component: PeopleAddComponent,
      breakpoints: [0.3, 0.5, 0.8, 1],
      initialBreakpoint: 0.9,
      componentProps: {
        closeModalEvent: this.closeModalEmitter
      }
    });
    return await modal.present();
  }

  public handleCloseModalEvent() {
    this.closeModalEmitter.subscribe(() => {
      this.modalController.dismiss({
        'dismissed': true
      });
      this.loadPeople();
    })
  }

  private async loadPeople() {
    this.people = await this.peopleService.getPeople();
  }
}
