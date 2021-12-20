import { Component, OnInit } from '@angular/core';
import {PersonModel} from "../person.model";
import {PeopleService} from "../people.service";
import {IonRouterOutlet, ModalController} from "@ionic/angular";
import {PeopleAddComponent} from "../people-add/people-add.component";

@Component({
  selector: 'app-people',
  templateUrl: './people-list.component.html',
  styleUrls: ['./people-list.component.scss'],
})
export class PeopleListComponent implements OnInit {
  public people: Array<PersonModel>;

  constructor(private peopleService: PeopleService,
              private modalController: ModalController) { }

  ngOnInit() {
    this.loadPeople();
   // this.presentModal();
  }

  private setupForm() {
  }

  async presentModal() {
    const modal = await this.modalController.create({
      component: PeopleAddComponent,
      breakpoints: [0.3, 0.5, 0.8, 1],
      initialBreakpoint: 0.9
    });
    return await modal.present();
  }

  private async loadPeople() {
    this.people = await this.peopleService.getPeople();
  }
}
